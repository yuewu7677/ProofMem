#!/usr/bin/env python3
"""ProofMem verification framework.

Extracts theorems from .lean files, runs `lake build` once (batch mode),
parses errors, and attributes each error to the correct theorem.

Supports single-file and batch verification modes.
"""

import sys
import re
import json
import subprocess
import os
from pathlib import Path

# ---------------------------------------------------------------------------
# Extraction
# ---------------------------------------------------------------------------

def extract_theorems(filepath: str) -> list[dict]:
    """Extract all theorem/lemma declarations from a .lean file.

    Returns list of dicts with 'name', 'line', and 'kind' (theorem/lemma).
    """
    theorems = []
    # [ \\t]* not \\s* — we only want horizontal whitespace (indentation).
    # \\s matches \\n which consumes blank lines and breaks line counting.
    pattern = re.compile(r'^[ \t]*(theorem|lemma)\s+(\w+)', re.MULTILINE)

    with open(filepath, 'r', encoding='utf-8', newline='') as f:
        content = f.read()

    # newline='' gives us raw line endings. Normalize CRLF → LF for
    # accurate line counting (Windows writes \\r\\n which shifts positions).
    normalized = content.replace('\r\n', '\n')

    for match in pattern.finditer(normalized):
        kind = match.group(1)
        name = match.group(2)
        pos = match.start()
        line_num = normalized[:pos].count('\n') + 1
        theorems.append({"name": name, "line": line_num, "kind": kind})

    return theorems


# ---------------------------------------------------------------------------
# Lake build
# ---------------------------------------------------------------------------

def run_lake_build(project_dir: str) -> tuple[bool, str, str]:
    """Run `lake build` in the given project directory.

    Returns (success: bool, stdout: str, stderr: str).
    """
    elan_bin = os.path.expanduser("~/.elan/bin")
    lake_exe = os.path.join(elan_bin, "lake.exe" if os.name == "nt" else "lake")
    env = os.environ.copy()
    env["PATH"] = elan_bin + os.pathsep + env.get("PATH", "")

    result = subprocess.run(
        [lake_exe, "build"],
        cwd=project_dir,
        capture_output=True,
        env=env,
        timeout=600,  # 10 min — mathlib is big
    )
    stdout = result.stdout.decode('utf-8', errors='replace')
    stderr = result.stderr.decode('utf-8', errors='replace')

    success = result.returncode == 0
    return success, stdout, stderr


# ---------------------------------------------------------------------------
# Error parsing
# ---------------------------------------------------------------------------

def parse_errors(output: str) -> list[dict]:
    """Parse Lean error messages from lake build output.

    Returns list of dicts with 'file', 'line', 'column', 'message'.

    Uses the next ``error: <path>.lean:<line>:<col>:`` header as the
    boundary — this handles multi-line error messages reliably, even if
    the message text itself contains the word "error:".
    """
    errors = []
    # Boundary: next full error header, or end-of-string.
    # Error headers look like:  error: Some/Path.lean:123:45:
    error_pattern = re.compile(
        r'error:\s*([^\s:]+\.lean):(\d+):(\d+):\s*'
        r'(.+?)'
        r'(?=\n[ \t]*error:\s*[^\s:]+\.lean:\d+:\d+:|$)',  # noqa
        re.DOTALL,
    )

    for match in error_pattern.finditer(output):
        filepath = match.group(1)
        line = int(match.group(2))
        col = int(match.group(3))
        message = match.group(4).strip()
        errors.append({
            "file": filepath,
            "line": line,
            "column": col,
            "message": message,
        })

    return errors


# ---------------------------------------------------------------------------
# Theorem / error matching
# ---------------------------------------------------------------------------

def match_theorem_to_error(
    theorems: list[dict],
    errors: list[dict],
    target_file: str,
) -> list[dict]:
    """Match errors to the theorems they affect.

    Filters errors by target_file first (lake build compiles the whole
    project — errors from other .lean files must not leak in).

    Within the target file, an error on line L is attributed to the theorem
    whose declaration line is the nearest preceding one.

    Time: O(T log T + E log E) via precomputed boundaries and single-pass
    walk — previously O(T * E + T²).
    """
    # Precompute upper-boundary line for each theorem.
    # A theorem owns all lines from its declaration up to (but not including)
    # the next theorem's declaration.  The last theorem has no upper bound.
    sorted_lines = sorted(t["line"] for t in theorems)
    boundaries: dict[int, float] = {}
    for i, line in enumerate(sorted_lines):
        boundaries[line] = (
            sorted_lines[i + 1] if i + 1 < len(sorted_lines) else float('inf')
        )

    # Filter to target file and sort by line number
    file_errors = sorted(
        [e for e in errors if e["file"].endswith(target_file)],
        key=lambda e: e["line"],
    )

    result = []
    err_idx = 0
    n_errs = len(file_errors)

    for thm in theorems:
        thm_errors = []

        # Skip errors that fall before this theorem's declaration
        while err_idx < n_errs and file_errors[err_idx]["line"] < thm["line"]:
            err_idx += 1

        # Collect errors that fall within this theorem's range
        while (
            err_idx < n_errs
            and file_errors[err_idx]["line"] < boundaries[thm["line"]]
        ):
            thm_errors.append(file_errors[err_idx])
            err_idx += 1

        result.append({
            "name": thm["name"],
            "kind": thm["kind"],
            "line": thm["line"],
            "status": "fail" if thm_errors else "pass",
            "errors": thm_errors,
        })

    return result


# ---------------------------------------------------------------------------
# Project directory resolution
# ---------------------------------------------------------------------------

def find_project_dir(filepath: str) -> str:
    """Find the Lake project root directory for a given .lean file.

    Looks for lakefile.toml by walking up the directory tree.
    """
    path = Path(filepath).resolve()
    for parent in [path.parent, *path.parents]:
        if (parent / "lakefile.toml").exists():
            return str(parent)
    raise FileNotFoundError(
        f"No lakefile.toml found in any parent directory of {filepath}"
    )


# ---------------------------------------------------------------------------
# Single-file verify (delegates to batch for consistency)
# ---------------------------------------------------------------------------

def verify(filepath: str) -> dict:
    """Verify a single .lean file.

    Args:
        filepath: Path to a .lean file.

    Returns:
        dict with keys: file, status, total, passed, failed, theorems
    """
    results = verify_batch([filepath])
    return results[0]


# ---------------------------------------------------------------------------
# Batch verify
# ---------------------------------------------------------------------------

def verify_batch(filepaths: list[str]) -> list[dict]:
    """Verify multiple .lean files with a single lake build.

    Args:
        filepaths: List of path strings to .lean files.

    Returns:
        List of result dicts (one per file), each with:
        file, status, total, passed, failed, theorems[, error][, message]
    """
    filepaths = [os.path.abspath(fp) for fp in filepaths]

    # --- Early-validation pass -------------------------------------------------
    early_errors = []
    valid = []
    for fp in filepaths:
        if not os.path.exists(fp):
            early_errors.append({
                "file": fp, "status": "error",
                "error": f"File not found: {fp}",
            })
        elif not fp.endswith('.lean'):
            early_errors.append({
                "file": fp, "status": "error",
                "error": f"Not a .lean file: {fp}",
            })
        else:
            valid.append(fp)

    if not valid:
        return early_errors

    # --- Find common project root ----------------------------------------------
    project_dir = find_project_dir(valid[0])

    # --- Extract theorems ------------------------------------------------------
    file_theorems: dict[str, list[dict]] = {}
    for fp in valid:
        file_theorems[fp] = extract_theorems(fp)

    # --- Run lake build ONCE ---------------------------------------------------
    build_ok, stdout, stderr = run_lake_build(project_dir)

    # --- Build results ---------------------------------------------------------
    if build_ok:
        results = []
        for fp in valid:
            theorems = file_theorems[fp]
            if not theorems:
                results.append({
                    "file": fp, "status": "warning", "total": 0,
                    "passed": 0, "failed": 0, "theorems": [],
                    "message": "No theorem or lemma declarations found in file",
                })
            else:
                results.append({
                    "file": fp, "status": "pass", "total": len(theorems),
                    "passed": len(theorems), "failed": 0,
                    "theorems": [
                        {"name": t["name"], "kind": t["kind"],
                         "line": t["line"], "status": "pass"}
                        for t in theorems
                    ],
                })
        return early_errors + results

    # Build failed — parse errors and attribute to each file
    combined_output = stdout + "\n" + stderr
    all_errors = parse_errors(combined_output)

    results = []
    for fp in valid:
        theorems = file_theorems[fp]
        if not theorems:
            results.append({
                "file": fp, "status": "warning", "total": 0,
                "passed": 0, "failed": 0, "theorems": [],
                "message": "No theorem or lemma declarations found in file",
            })
            continue

        target = os.path.basename(fp)
        matched = match_theorem_to_error(theorems, all_errors, target)
        passed = sum(1 for r in matched if r["status"] == "pass")
        failed = len(matched) - passed

        results.append({
            "file": fp,
            "status": "fail" if failed > 0 else "pass",
            "total": len(theorems),
            "passed": passed,
            "failed": failed,
            "theorems": [
                {
                    "name": r["name"], "kind": r["kind"],
                    "status": r["status"], "line": r["line"],
                    "errors": (
                        [{"line": e["line"], "column": e["column"],
                          "message": e["message"]} for e in r["errors"]]
                        if r["errors"] else None
                    ),
                }
                for r in matched
            ],
        })

    return early_errors + results


# ---------------------------------------------------------------------------
# Formatting
# ---------------------------------------------------------------------------

def _clean_msg(msg: str, limit: int = 100) -> str:
    """Collapse whitespace in an error message to one line."""
    return " ".join(msg.split())[:limit]


def _shorten_path(filepath: str) -> str:
    """Return a concise display path."""
    cwd = os.getcwd()
    for prefix in [cwd + os.sep, cwd]:
        if filepath.startswith(prefix):
            return filepath[len(prefix):]
    return filepath


def format_report(result: dict) -> str:
    """Format single-file verification result as a human-readable report."""
    lines = []
    lines.append("")
    lines.append("=" * 60)
    lines.append("  ProofMem Verification Report")
    lines.append("=" * 60)

    if result.get("status") == "error":
        lines.append(f"\n  ERROR: {result['error']}")
        return "\n".join(lines)

    if result.get("status") == "warning":
        lines.append(f"\n  {result['message']}")
        return "\n".join(lines)

    display_path = _shorten_path(result["file"])
    total = result["total"]
    passed = result["passed"]
    failed = result["failed"]

    lines.append(f"\n  File:   {display_path}")
    lines.append(f"  Result: {passed}/{total} theorems verified")
    lines.append("")

    if result["status"] == "pass":
        lines.append(f"  Status: ALL {total}/{total} THEOREMS VERIFIED [PASS]")
    else:
        lines.append(f"  Status: {failed}/{total} FAILED [FAIL]")

    lines.append("")

    for thm in result["theorems"]:
        icon = "[PASS]" if thm["status"] == "pass" else "[FAIL]"
        lines.append(
            f"  {icon} {thm['name']} ({thm['kind']}, line {thm.get('line', '?')})"
        )
        if thm.get("errors"):
            for err in thm["errors"]:
                lines.append(
                    f"       line {err['line']}:{err['column']}"
                    f" — {_clean_msg(err['message'], 100)}"
                )

    lines.append("")
    lines.append("=" * 60)

    return "\n".join(lines)


def format_batch_report(results: list[dict]) -> str:
    """Format batch verification results as a human-readable report."""
    lines = []
    lines.append("")
    lines.append("=" * 60)
    lines.append("  ProofMem Batch Verification Report")
    lines.append("=" * 60)

    total_files = len(results)
    passed_files = sum(1 for r in results if r.get("status") == "pass")
    failed_files = sum(1 for r in results if r.get("status") == "fail")
    error_files = sum(1 for r in results if r.get("status") == "error")

    lines.append(
        f"\n  Files: {total_files} | "
        f"Passed: {passed_files} | "
        f"Failed: {failed_files} | "
        f"Errors: {error_files}"
    )
    lines.append("")

    for result in results:
        status = result.get("status", "error")
        display_path = _shorten_path(result["file"])

        if status == "error":
            lines.append(f"  [ERR] {display_path} — {result['error']}")
            continue
        if status == "warning":
            lines.append(f"  [WARN] {display_path} — {result['message']}")
            continue

        passed = result["passed"]
        total = result["total"]
        icon = "[PASS]" if status == "pass" else "[FAIL]"
        lines.append(f"  {icon} {display_path} — {passed}/{total} theorems")

        for thm in result.get("theorems", []):
            t_icon = "[OK]" if thm["status"] == "pass" else "[XX]"
            lines.append(
                f"       {t_icon} {thm['name']}"
                f" ({thm['kind']}, line {thm.get('line', '?')})"
            )
            if thm.get("errors"):
                for err in thm["errors"]:
                    lines.append(
                        f"          line {err['line']}:{err['column']}"
                        f" — {_clean_msg(err['message'], 100)}"
                    )

    lines.append("")
    lines.append("=" * 60)

    return "\n".join(lines)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    if len(sys.argv) < 2 or sys.argv[1] in ("-h", "--help"):
        print("Usage: python verify.py <lean_file> [<lean_file2> ...] [--json]")
        print("       python verify.py <directory> [--json]")
        print()
        print("  <lean_file>   One or more .lean files to verify.")
        print("  <directory>   Directory of .lean files (recursive).")
        print("  --json        Output machine-readable JSON.")
        print("  --batch       Force batch mode (default when >1 file or directory).")
        print()
        print("Examples:")
        print("  python verify.py ProofMem/Basic.lean")
        print("  python verify.py ProofMem/Basic.lean ProofMem/Broken.lean --json")
        print("  python verify.py ProofMem/ --json")
        sys.exit(0)

    # Separate flags from file/dir arguments
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    use_json = "--json" in sys.argv
    force_batch = "--batch" in sys.argv

    # Expand directories to .lean file lists
    raw_files = []
    for a in args:
        p = Path(a)
        if p.is_dir():
            raw_files.extend(str(f) for f in sorted(p.rglob("*.lean")))
        else:
            raw_files.append(a)

    if not raw_files:
        print("Error: no .lean files found.", file=sys.stderr)
        sys.exit(1)

    # Decide mode
    batch_mode = force_batch or len(raw_files) > 1

    if batch_mode:
        results = verify_batch(raw_files)
        if use_json:
            print(json.dumps(results, indent=2, ensure_ascii=False))
        else:
            if sys.stdout.encoding != 'utf-8':
                sys.stdout.reconfigure(encoding='utf-8', errors='replace')
            print(format_batch_report(results))
    else:
        result = verify(raw_files[0])
        if use_json:
            print(json.dumps(result, indent=2, ensure_ascii=False))
        else:
            if sys.stdout.encoding != 'utf-8':
                sys.stdout.reconfigure(encoding='utf-8', errors='replace')
            print(format_report(result))

    # Exit with non-zero if any file had a verification failure
    results = verify_batch(raw_files) if batch_mode else [verify(raw_files[0])]
    if any(r.get("status") in ("fail", "error") for r in results):
        sys.exit(1)


if __name__ == "__main__":
    main()
