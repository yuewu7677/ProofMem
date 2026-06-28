#!/usr/bin/env python3
import sys
import re
import json
import subprocess
import os
from pathlib import Path


def extract_theorems(filepath: str) -> list[dict]:
    """Extract all theorem/lemma declarations from a .lean file.

    Returns list of dicts with 'name', 'line', and 'kind' (theorem/lemma).
    """
    theorems = []
    # [ \t]* not \s* — we only want horizontal whitespace (indentation).
    # \s matches \n which consumes blank lines and breaks line counting.
    pattern = re.compile(r'^[ \t]*(theorem|lemma)\s+(\w+)', re.MULTILINE)

    with open(filepath, 'r', encoding='utf-8', newline='') as f:
        content = f.read()

    # newline='' gives us raw line endings. Normalize CRLF → LF for
    # accurate line counting (Windows writes \r\n which shifts positions).
    normalized = content.replace('\r\n', '\n')

    for match in pattern.finditer(normalized):
        kind = match.group(1)
        name = match.group(2)
        pos = match.start()
        line_num = normalized[:pos].count('\n') + 1
        theorems.append({"name": name, "line": line_num, "kind": kind})

    return theorems


def run_lake_build(project_dir: str) -> tuple[bool, str, str]:
    """Run `lake build` in the given project directory.

    Returns (success: bool, stdout: str, stderr: str).
    """
    # Use full path to lake — on Windows, subprocess needs the .exe
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
    # Decode output with UTF-8 (lake uses Unicode characters in Lean errors)
    stdout = result.stdout.decode('utf-8', errors='replace')
    stderr = result.stderr.decode('utf-8', errors='replace')

    success = result.returncode == 0
    return success, stdout, stderr


def parse_errors(stderr: str) -> list[dict]:
    """Parse Lean error messages from lake build output.

    Returns list of dicts with 'line', 'message', and optional 'identifier'.
    """
    errors = []
    # Lean errors look like: error: path/to/file.lean:line:col: message
    error_pattern = re.compile(
        r'error:\s*(.+?\.lean):(\d+):(\d+):\s*(.+?)(?=\n\s*(?:error:|$))',
        re.DOTALL
    )

    for match in error_pattern.finditer(stderr):
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


def match_theorem_to_error(theorems: list[dict], errors: list[dict],
                           target_file: str) -> list[dict]:
    """Match errors to the theorems they affect.

    Filters errors by target_file first (lake build compiles the whole
    project — errors from other .lean files must not leak in).

    Within the target file, an error on line L is attributed to the theorem
    whose declaration line is the nearest preceding one.
    """
    result = []
    for thm in theorems:
        thm_errors = []
        for err in errors:
            # Must be from the same file
            if not err["file"].endswith(target_file):
                continue
            # Error line must be at or after this theorem
            if err["line"] < thm["line"]:
                continue
            # Find upper boundary: next theorem's declaration line
            next_thm_line = None
            for t in theorems:
                if t["line"] > thm["line"]:
                    next_thm_line = t["line"]
                    break
            if next_thm_line is None or err["line"] < next_thm_line:
                thm_errors.append(err)

        result.append({
            "name": thm["name"],
            "kind": thm["kind"],
            "line": thm["line"],
            "status": "fail" if thm_errors else "pass",
            "errors": thm_errors,
        })

    return result


def find_project_dir(filepath: str) -> str:
    """Find the Lake project root directory for a given .lean file.

    Looks for lakefile.toml by walking up the directory tree.
    """
    path = Path(filepath).resolve()
    for parent in [path.parent] + list(path.parents):
        if (parent / "lakefile.toml").exists():
            return str(parent)
    raise FileNotFoundError(
        f"No lakefile.toml found in any parent directory of {filepath}"
    )


def verify(filepath: str) -> dict:
    """Main verification routine.

    Args:
        filepath: Path to a .lean file relative to project root.

    Returns:
        dict with keys: file, status, total, passed, failed, theorems, errors
    """
    filepath = os.path.abspath(filepath)

    if not os.path.exists(filepath):
        return {
            "file": filepath,
            "status": "error",
            "error": f"File not found: {filepath}",
        }

    if not filepath.endswith('.lean'):
        return {
            "file": filepath,
            "status": "error",
            "error": f"Not a .lean file: {filepath}",
        }

    # Find the project root (where lakefile.toml lives)
    project_dir = find_project_dir(filepath)

    # Extract theorems from the file
    theorems = extract_theorems(filepath)

    if not theorems:
        return {
            "file": filepath,
            "status": "warning",
            "total": 0,
            "passed": 0,
            "failed": 0,
            "theorems": [],
            "message": "No theorem or lemma declarations found in file",
        }

    # Run lake build
    build_ok, stdout, stderr = run_lake_build(project_dir)

    if build_ok:
        # All theorems pass
        return {
            "file": filepath,
            "status": "pass",
            "total": len(theorems),
            "passed": len(theorems),
            "failed": 0,
            "theorems": [{"name": t["name"], "kind": t["kind"], "line": t["line"], "status": "pass"} for t in theorems],
        }

    # Build failed — parse errors from BOTH stdout and stderr
    # (lake prints Lean errors to stdout, only the final summary to stderr)
    combined_output = stdout + "\n" + stderr
    errors = parse_errors(combined_output)
    target = os.path.basename(filepath)  # e.g. "Broken.lean"
    results = match_theorem_to_error(theorems, errors, target)

    passed = sum(1 for r in results if r["status"] == "pass")
    failed = len(results) - passed

    return {
        "file": filepath,
        "status": "fail" if failed > 0 else "pass",
        "total": len(theorems),
        "passed": passed,
        "failed": failed,
        "theorems": [
            {
                "name": r["name"],
                "kind": r["kind"],
                "status": r["status"],
                "line": r["line"],
                "errors": [
                    {"line": e["line"], "column": e["column"], "message": e["message"]}
                    for e in r["errors"]
                ] if r["errors"] else None,
            }
            for r in results
        ],
    }


def format_report(result: dict) -> str:
    """Format verification result as a human-readable report."""
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

    filepath = result["file"]
    total = result["total"]
    passed = result["passed"]
    failed = result["failed"]

    # Shorten file path for display
    display_path = filepath
    for prefix in [os.getcwd() + os.sep, os.getcwd()]:
        if filepath.startswith(prefix):
            display_path = filepath[len(prefix):]
            break

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
        lines.append(f"  {icon} {thm['name']} ({thm['kind']}, line {thm.get('line', '?')})")
        if thm.get("errors"):
            for err in thm["errors"]:
                lines.append(f"       line {err['line']}:{err['column']} — {err['message'][:100]}")

    lines.append("")
    lines.append("=" * 60)

    return "\n".join(lines)


def main():
    if len(sys.argv) < 2 or sys.argv[1] in ("-h", "--help"):
        print("Usage: python scripts/verify.py <lean_file> [--json]")
        print()
        print("  <lean_file>  Path to a .lean file (relative to project root)")
        print("  --json        Output machine-readable JSON")
        print()
        print("Examples:")
        print("  python scripts/verify.py test-lean/ProofMem/ProofMem/Basic.lean")
        print("  python scripts/verify.py test-lean/ProofMem/ProofMem/Basic.lean --json")
        sys.exit(0)

    filepath = sys.argv[1]
    use_json = "--json" in sys.argv

    result = verify(filepath)

    if use_json:
        print(json.dumps(result, indent=2, ensure_ascii=False))
    else:
        # Force UTF-8 output to handle checkmark symbols
        if sys.stdout.encoding != 'utf-8':
            sys.stdout.reconfigure(encoding='utf-8', errors='replace')
        print(format_report(result))

    # Exit with non-zero if verification failed
    if result.get("status") in ("fail", "error"):
        sys.exit(1)


if __name__ == "__main__":
    main()
