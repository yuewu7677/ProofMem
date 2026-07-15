#!/usr/bin/env python3
"""Merge an evenly-distributed sample of Lean files into one compilable file.

Designed for large Lean theorem-proving datasets (e.g. LEAN-GAP-style repos)
that contain many ``.lean`` files across nested directories.

This version produces output that Lean 4 can actually parse:

  * Every ``import`` line from every selected file is collected, de-duplicated,
    and hoisted to the very top of the output. Lean requires all imports to
    precede the first declaration, so leaving them inline (as a naive
    concatenation does) causes
    "invalid 'import' command, it must be used in the beginning of the file".
  * Aggregator files (``DF.lean`` / ``Formal.lean``) and any ``import Formal.*``
    lines are dropped. Those imports reference module paths that only resolve
    inside a Lake project with that directory layout, not in a flat merged file.
  * The metadata banner and per-file ``FILE:`` separators are emitted as Lean
    block comments (``/- ... -/``) so no bare text sits between declarations.

Compatible with Python 3.10+.
"""

from __future__ import annotations

import argparse
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

# --------------------------------------------------------------------------- #
# Configuration                                                               #
# --------------------------------------------------------------------------- #

DEFAULT_COUNT = 45

# Files that are pure aggregators (nothing but `import Formal.*` lines). They
# must never be merged: their imports are unresolvable in a flat file.
AGGREGATOR_NAMES = {"DF.lean", "Formal.lean"}

_IMPORT_RE = re.compile(r"^\s*import\s+(\S+)")


# --------------------------------------------------------------------------- #
# Discovery                                                                   #
# --------------------------------------------------------------------------- #

def discover_lean_files(inputs: list[str]) -> list[Path]:
    """Recursively discover ``.lean`` files from directories or explicit files.

    Directories are searched recursively with ``rglob``. Explicit file paths
    are included as-is if they end in ``.lean``. The result is sorted
    deterministically by full path string so sampling is reproducible.
    """
    found: set[Path] = set()
    for raw in inputs:
        p = Path(raw)
        if p.is_dir():
            for f in p.rglob("*.lean"):
                if f.is_file():
                    found.add(f.resolve())
        elif p.is_file() and p.suffix == ".lean":
            found.add(p.resolve())
        else:
            print(f"warning: skipping '{raw}' (not a .lean file or directory)",
                  file=sys.stderr)
    return sorted(found, key=lambda x: str(x))


# --------------------------------------------------------------------------- #
# Sampling                                                                     #
# --------------------------------------------------------------------------- #

def sample_evenly(files: list[Path], count: int) -> list[Path]:
    """Select ``count`` files spread as evenly as possible across the list.

    Uses midpoint-stride interval sampling: the i-th pick lands near the centre
    of its bucket via ``(i * n) // count + n // (2 * count)`` rather than at the
    left edge, avoiding clustering at index 0. A monotonicity guard clamps each
    index to ``[0, n-1]`` and forces strictly increasing values, guaranteeing
    ``count`` distinct picks with no duplicates.

    If fewer than ``count`` files exist, all are returned unchanged.
    """
    n = len(files)
    if count <= 0:
        return []
    if n <= count:
        return list(files)

    indices: list[int] = []
    last = -1
    for i in range(count):
        idx = (i * n) // count + n // (2 * count)
        if idx < 0:
            idx = 0
        if idx > n - 1:
            idx = n - 1
        if idx <= last:
            idx = last + 1
        if idx > n - 1:
            idx = n - 1
        indices.append(idx)
        last = idx
    return [files[i] for i in indices]


# --------------------------------------------------------------------------- #
# Merge                                                                        #
# --------------------------------------------------------------------------- #

def _read(path: Path) -> str:
    """Read a file as UTF-8, replacing malformed bytes rather than aborting."""
    return path.read_text(encoding="utf-8", errors="replace")


def _display_path(path: Path, relative_to: Path | None) -> str:
    """Return a path string for banners, relative to ``relative_to`` if given."""
    if relative_to is not None:
        try:
            return str(path.resolve().relative_to(relative_to.resolve()))
        except ValueError:
            pass
    return str(path)


def split_imports(body: str) -> tuple[list[str], str]:
    """Split a file body into (import_lines, remaining_body).

    ``import Formal.*`` lines are discarded entirely (unresolvable when flat).
    All other ``import`` lines are returned for hoisting. Everything else,
    including blank lines and comments, stays in the remaining body.
    """
    imports: list[str] = []
    rest: list[str] = []
    for line in body.splitlines():
        m = _IMPORT_RE.match(line)
        if m:
            module = m.group(1)
            if module.startswith("Formal."):
                continue
            imports.append(line.strip())
        else:
            rest.append(line)
    # Trim leading/trailing blank lines from the remaining body.
    while rest and rest[0].strip() == "":
        rest.pop(0)
    while rest and rest[-1].strip() == "":
        rest.pop()
    return imports, "\n".join(rest)


def build_metadata(total: int, selected: list[str]) -> str:
    """Build the metadata banner as a Lean block comment."""
    ts = datetime.now(timezone.utc).isoformat()
    lines = [
        "/-",
        "=" * 78,
        "MERGED LEAN DATASET",
        "=" * 78,
        f"Total Lean files discovered : {total}",
        f"Number of files selected    : {len(selected)}",
        f"Generated (UTC)             : {ts}",
        "=" * 78,
        "Selected files:",
    ]
    for i, s in enumerate(selected, start=1):
        lines.append(f"  [{i:3d}] {s}")
    lines.append("=" * 78)
    lines.append("-/")
    return "\n".join(lines)


def merge_files(
    selected: list[Path],
    total_discovered: int,
    relative_to: Path | None,
) -> str:
    """Merge selected files into one Lean source string with hoisted imports."""
    # Filter out aggregator files up front.
    usable: list[Path] = []
    for p in selected:
        if p.name in AGGREGATOR_NAMES:
            print(f"note: skipping aggregator file '{p.name}'", file=sys.stderr)
            continue
        usable.append(p)

    display_names = [_display_path(p, relative_to) for p in usable]

    all_imports: set[str] = set()
    sections: list[tuple[str, str]] = []  # (display_name, body_without_imports)

    for path, name in zip(usable, display_names):
        try:
            raw = _read(path)
        except OSError as e:
            print(f"warning: could not read '{name}': {e}", file=sys.stderr)
            sections.append((name, f"/- ERROR: could not read this file: {e} -/"))
            continue
        imports, rest = split_imports(raw)
        all_imports.update(imports)
        sections.append((name, rest))
        print(f"merged [{len(sections):2d}/{len(usable)}] {name}")

    parts: list[str] = []

    # 1. Hoisted, de-duplicated, sorted imports at the very top.
    for imp in sorted(all_imports):
        parts.append(imp)
    parts.append("")  # blank line after the import block

    # 2. Metadata banner as a block comment (after imports so it never splits
    #    the import block; Lean allows comments between imports and code).
    parts.append(build_metadata(total_discovered, display_names))
    parts.append("")

    # 3. Each file body, prefixed by a block-comment separator.
    for name, body in sections:
        parts.append(f"/- FILE: {name} -/")
        if body:
            parts.append(body)
        parts.append("")  # spacer between sections

    return "\n".join(parts) + "\n"


# --------------------------------------------------------------------------- #
# CLI                                                                          #
# --------------------------------------------------------------------------- #

def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Merge an evenly-distributed sample of Lean files into one "
                    "compilable file (imports hoisted, aggregators dropped).",
    )
    parser.add_argument(
        "--input", "-i", nargs="+", required=True,
        help="One or more directories or .lean files.",
    )
    parser.add_argument(
        "--count", "-c", type=int, default=DEFAULT_COUNT,
        help=f"Number of files to select (default: {DEFAULT_COUNT}).",
    )
    parser.add_argument(
        "--output", "-o", required=True,
        help="Path to write the merged output file.",
    )
    parser.add_argument(
        "--relative-to", "-r", default=None,
        help="Directory to make FILE: banner paths relative to.",
    )
    args = parser.parse_args(argv)

    files = discover_lean_files(args.input)
    if not files:
        print("error: no .lean files found in the given input(s).",
              file=sys.stderr)
        return 1

    total = len(files)
    print(f"discovered {total} .lean file(s)")

    selected = sample_evenly(files, args.count)
    print(f"selected {len(selected)} file(s)")

    relative_to = Path(args.relative_to) if args.relative_to else None
    merged = merge_files(selected, total, relative_to)

    out_path = Path(args.output)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    # newline="" preserves the exact newlines already in the string.
    with out_path.open("w", encoding="utf-8", newline="") as f:
        f.write(merged)

    print(f"Done. Wrote {out_path.resolve()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
