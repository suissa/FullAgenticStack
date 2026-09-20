#!/usr/bin/env python3
"""Generate and verify FullAgenticStack semantic lockfiles.

The manifest is OUTPUT, never source of truth.

Annotations recognized in project source/tests:
  // @satisfies FAS-RUNTIME-003
  // @test FAS-RUNTIME-003
  // @evidence FAS-RUNTIME-003 Governance.Rejected
  // @not-applicable FAS-PROJ-001 condition=independent_projection_exists:false reason=no_independent_projections
"""

from __future__ import annotations
import argparse
import os
import re
import sys
from pathlib import Path

try:
    from blake3 import blake3
except ImportError:
    print("error: Python package 'blake3' is required (pip install blake3)", file=sys.stderr)
    raise SystemExit(2)

ROOT = Path(__file__).resolve().parents[1]
RFCS = ROOT / "docs" / "RFCs"
REQ_RE = re.compile(r"^###\s+(FAS-[A-Z0-9-]+)\s+[—-]\s+(.+?)\s*$")
META_RE = re.compile(r"^\|\s*(FAS-[A-Z0-9-]+)\s*\|\s*(REQUIRED|CONDITIONAL|OPTIONAL)\s*\|\s*([^|]+?)\s*\|")
ANNOT_RE = re.compile(r"@(?P<kind>satisfies|test|evidence)\s+(?P<id>FAS-[A-Z0-9-]+)(?:\s+(?P<value>[^\r\n]+))?")
NA_RE = re.compile(r"@not-applicable\s+(?P<id>FAS-[A-Z0-9-]+)\s+condition=(?P<condition>\S+)\s+reason=(?P<reason>\S+)")
SOURCE_EXTS = {".zig", ".rs", ".go", ".ts", ".tsx", ".js", ".py", ".hs", ".pl", ".c", ".cpp", ".java", ".kt", ".swift"}

def normalize_statement(text: str) -> str:
    # Editorial-only whitespace changes do not affect the requirement hash.
    lines = []
    for raw in text.splitlines():
        line = raw.strip()
        if not line:
            continue
        line = re.sub(r"\s+", " ", line)
        lines.append(line)
    return "\n".join(lines)

def extract_requirements(path: Path):
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    metadata = {}
    for line in lines:
        mm = META_RE.match(line)
        if mm:
            metadata[mm.group(1)] = {
                "class": mm.group(2),
                "activation_condition": mm.group(3).strip(),
            }
    found = []
    i = 0
    while i < len(lines):
        m = REQ_RE.match(lines[i])
        if not m:
            i += 1
            continue
        req_id, title = m.groups()
        body = []
        j = i + 1
        while j < len(lines):
            if lines[j].startswith("### "):
                break
            if lines[j].startswith("## "):
                break
            body.append(lines[j])
            j += 1
        normalized = normalize_statement("\n".join([f"{req_id} — {title}", *body]))
        meta = metadata.get(req_id, {"class": "REQUIRED", "activation_condition": "always"})
        found.append((req_id, normalized, "blake3:" + blake3(normalized.encode()).hexdigest(), meta))
        i = j
    return found

def ignored(path: Path) -> bool:
    parts = set(path.parts)
    if ".git" in parts or "zig-cache" in parts or ".zig-cache" in parts or "node_modules" in parts:
        return True
    if path.name == "manifest.yml":
        return True
    return False

def scan_annotations():
    out = {}
    for path in ROOT.rglob("*"):
        if not path.is_file() or ignored(path):
            continue
        if path.suffix not in SOURCE_EXTS:
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        rel = path.relative_to(ROOT).as_posix()
        for m in ANNOT_RE.finditer(text):
            item = out.setdefault(m.group("id"), {"sources": [], "tests": [], "evidence": [], "na": None})
            kind = m.group("kind")
            value = (m.group("value") or "").strip()
            if kind == "satisfies":
                item["sources"].append(rel)
            elif kind == "test":
                item["tests"].append(rel)
            elif kind == "evidence":
                literal = re.escape(value)
                if not re.search(r'expectEmitted\(\s*"' + literal + r'"\s*\)', text):
                    raise ValueError(f"{rel}: @evidence {m.group('id')} {value!r} has no matching expectEmitted assertion")
                item["evidence"].append({"path": rel, "assertion": value})
        for m in NA_RE.finditer(text):
            item = out.setdefault(m.group("id"), {"sources": [], "tests": [], "evidence": [], "na": None})
            item["na"] = {"condition": m.group("condition"), "reason": m.group("reason"), "path": rel}
    return out

def parse_previous_verified(path: Path):
    if not path.exists():
        return {}
    result = {}
    current = None
    for line in path.read_text(encoding="utf-8").splitlines():
        m = re.match(r'^\s{2}(FAS-[A-Z0-9-]+):\s*$', line)
        if m:
            current = m.group(1)
        elif current:
            m = re.match(r'^\s{4}verified_against:\s*(.+?)\s*$', line)
            if m:
                value = m.group(1)
                result[current] = None if value == "null" else value.strip('"')
    return result

def q(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'

def manifest_for(rfc_dir: Path, annotations, mark_verified=False):
    semantic = rfc_dir / "semantic.md"
    requirements = extract_requirements(semantic)
    previous = parse_previous_verified(rfc_dir / "implemented" / "manifest.yml")
    rows = []
    rows.append("# GENERATED FILE — DO NOT EDIT")
    rows.append("# Generated by tools/rfc_lock.py from semantic requirements and code annotations.")
    rows.append(f"rfc: {q(rfc_dir.name.split('-', 3)[0] + '-' + rfc_dir.name.split('-', 3)[1] + '-' + rfc_dir.name.split('-', 3)[2])}")
    rows.append("generated_by: tools/rfc_lock.py")
    rows.append("source_of_truth: semantic.md")
    rows.append("requirements:")
    for req_id, normalized, statement_hash, meta in requirements:
        a = annotations.get(req_id, {"sources": [], "tests": [], "evidence": [], "na": None})
        verified = previous.get(req_id)
        fully_bound = bool(a["sources"] and a["tests"])
        if mark_verified and fully_bound and not a["na"]:
            verified = statement_hash
        if a["na"]:
            if meta["class"] != "CONDITIONAL":
                raise ValueError(f"{req_id}: not_applicable is only valid for CONDITIONAL requirements")
            status = "not_applicable"
        elif verified and verified != statement_hash:
            status = "stale"
        elif fully_bound:
            status = "implemented"
        elif a["sources"] or a["tests"]:
            status = "partial"
        else:
            status = "not_implemented"

        rows.append(f"  {req_id}:")
        rows.append(f"    requirement_class: {meta['class'].lower()}")
        rows.append(f"    activation_condition: {q(meta['activation_condition'])}")
        rows.append(f"    statement_hash: {q(statement_hash)}")
        rows.append(f"    verified_against: {q(verified) if verified else 'null'}")
        rows.append(f"    status: {status}")
        rows.append("    sources:")
        for p in sorted(set(a["sources"])):
            rows.append(f"      - {q(p)}")
        rows.append("    tests:")
        for p in sorted(set(a["tests"])):
            rows.append(f"      - {q(p)}")
        rows.append("    evidence_assertions:")
        for ev in a["evidence"]:
            rows.append(f"      - path: {q(ev['path'])}")
            rows.append(f"        assertion: {q(ev['assertion'])}")
        if a["na"]:
            rows.append("    not_applicable:")
            rows.append(f"      activation_condition: {q(a['na']['condition'])}")
            rows.append(f"      justification: {q(a['na']['reason'])}")
            rows.append(f"      asserted_by: {q(a['na']['path'])}")
        rows.append(f"    normalized_statement: {q(normalized)}")
    return "\n".join(rows) + "\n"

def verify_bindings(rfc_dir: Path, generated: str):
    bindings = rfc_dir / "implementation" / "bindings.yml"
    if not bindings.exists():
        raise ValueError(f"{rfc_dir}: missing implementation/bindings.yml")
    # bindings.yml is descriptive only. If it names a requirement, the requirement
    # must exist in the generated lock; this prevents silent component/requirement drift.
    lock_ids = set(re.findall(r"^\s{2}(FAS-[A-Z0-9-]+):", generated, re.M))
    for req in set(re.findall(r"FAS-[A-Z][A-Z0-9]*-\\d+", bindings.read_text(encoding="utf-8"))):
        if req not in lock_ids:
            raise ValueError(f"{bindings}: references unknown requirement {req}")

def validate_refs(generated: str):
    for ref in re.findall(r'^\s+- "([^"]+)"\s*$', generated, re.M):
        # Evidence assertions are handled separately; list entries here are source/test paths.
        if ref.startswith("docs/") or ref.startswith("src/") or ref.startswith("tests/") or ref.startswith("tools/"):
            if not (ROOT / ref).exists():
                raise ValueError(f"referenced path does not exist: {ref}")

def main():
    ap = argparse.ArgumentParser()
    mode = ap.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    ap.add_argument("--verify", action="store_true", help="mark fully bound requirements verified after successful conformance")
    args = ap.parse_args()

    if args.verify and not args.write:
        print("error: --verify requires --write", file=sys.stderr)
        return 2

    try:
        annotations = scan_annotations()
    except ValueError as exc:
        print("error:", exc, file=sys.stderr)
        return 1
    changed = False
    errors = []

    for rfc_dir in sorted(p for p in RFCS.iterdir() if p.is_dir() and p.name.startswith("RFC-FAS-")):
        manifest = rfc_dir / "implemented" / "manifest.yml"
        generated = manifest_for(rfc_dir, annotations, mark_verified=args.verify)
        try:
            verify_bindings(rfc_dir, generated)
            validate_refs(generated)
        except ValueError as exc:
            errors.append(str(exc))
            continue

        if args.write:
            manifest.write_text(generated, encoding="utf-8")
        else:
            existing = manifest.read_text(encoding="utf-8") if manifest.exists() else ""
            if existing != generated:
                errors.append(f"{manifest.relative_to(ROOT)} is not generated/current; run: python tools/rfc_lock.py --write")
                changed = True

    if errors:
        for e in errors:
            print("error:", e, file=sys.stderr)
        return 1
    if args.check:
        print("RFC semantic lockfiles are generated, current, and path-valid.")
    else:
        print("RFC semantic lockfiles generated.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
