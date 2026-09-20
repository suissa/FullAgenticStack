#!/usr/bin/env python3
"""Generate and verify FullAgenticStack semantic lockfiles.

The manifest is generated output, never source of truth.

Supported annotations in project source/tests:
  // @satisfies FAS-RUNTIME-003
  // @test FAS-RUNTIME-003
  // @evidence FAS-RUNTIME-003 Governance.Rejected
  // @not-applicable FAS-PROJ-001 condition=independent_projection_exists:false reason=no_independent_projections
"""

from __future__ import annotations

import argparse
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
BUILD_FILE = ROOT / "build.zig"

REQ_RE = re.compile(r"^###\s+(FAS-[A-Z0-9-]+)\s+[—-]\s+(.+?)\s*$")
META_RE = re.compile(
    r"^\|\s*(FAS-[A-Z0-9-]+)\s*\|\s*(REQUIRED|CONDITIONAL|OPTIONAL)\s*\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|"
)
ANNOT_RE = re.compile(
    r"@(?P<kind>satisfies|test|evidence)\s+(?P<id>FAS-[A-Z0-9-]+)(?:\s+(?P<value>[^\r\n]+))?"
)
NA_RE = re.compile(
    r"@not-applicable\s+(?P<id>FAS-[A-Z0-9-]+)\s+condition=(?P<condition>\S+)\s+reason=(?P<reason>\S+)"
)

SOURCE_EXTS = {
    ".zig", ".rs", ".go", ".ts", ".tsx", ".js", ".py",
    ".hs", ".pl", ".c", ".cpp", ".java", ".kt", ".swift",
}


def normalize_statement(text: str) -> str:
    """Remove editorial-only formatting while retaining semantic tokens."""
    normalized_lines: list[str] = []

    for raw in text.splitlines():
        line = raw.strip()
        if not line:
            continue

        line = line.replace("**", "").replace("__", "").replace("\`", "")
        line = re.sub(r"^[-*+]\s+", "", line)
        line = re.sub(r"[,;](?=\s|$)", "", line)
        line = re.sub(r"\.(?=\s*$)", "", line)
        line = re.sub(r"\s+", " ", line)
        normalized_lines.append(line)

    return "\n".join(normalized_lines)


def extract_requirements(path: Path):
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()

    metadata: dict[str, dict[str, str]] = {}
    for line in lines:
        match = META_RE.match(line)
        if match:
            metadata[match.group(1)] = {
                "class": match.group(2),
                "activation_condition": match.group(3).strip(),
                "required_evidence": match.group(4).strip(),
            }

    found = []
    i = 0
    while i < len(lines):
        match = REQ_RE.match(lines[i])
        if not match:
            i += 1
            continue

        req_id, title = match.groups()
        body: list[str] = []
        j = i + 1

        while j < len(lines):
            if lines[j].startswith("### ") or lines[j].startswith("## "):
                break
            body.append(lines[j])
            j += 1

        normalized = normalize_statement("\n".join([f"{req_id} — {title}", *body]))
        statement_hash = "blake3:" + blake3(normalized.encode("utf-8")).hexdigest()
        meta = metadata.get(
            req_id,
            {
                "class": "REQUIRED",
                "activation_condition": "always",
                "required_evidence": "unspecified",
            },
        )

        found.append((req_id, normalized, statement_hash, meta))
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
    out: dict[str, dict] = {}

    for path in ROOT.rglob("*"):
        if not path.is_file() or ignored(path):
            continue
        if path.resolve() == Path(__file__).resolve():
            continue
        if path.suffix not in SOURCE_EXTS:
            continue

        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue

        rel = path.relative_to(ROOT).as_posix()

        for match in ANNOT_RE.finditer(text):
            item = out.setdefault(
                match.group("id"),
                {"sources": [], "tests": [], "evidence": [], "na": None},
            )
            kind = match.group("kind")
            value = (match.group("value") or "").strip()

            if kind == "satisfies":
                item["sources"].append(rel)
            elif kind == "test":
                item["tests"].append(rel)
            elif kind == "evidence":
                literal = re.escape(value)
                assertion = re.search(
                    r'expectEmitted\s*\(\s*"' + literal + r'"\s*\)',
                    text,
                )
                if not assertion:
                    raise ValueError(
                        f"{rel}: @evidence {match.group('id')} {value!r} "
                        "has no matching expectEmitted assertion"
                    )
                item["evidence"].append({"path": rel, "assertion": value})

        for match in NA_RE.finditer(text):
            item = out.setdefault(
                match.group("id"),
                {"sources": [], "tests": [], "evidence": [], "na": None},
            )
            item["na"] = {
                "condition": match.group("condition"),
                "reason": match.group("reason"),
                "path": rel,
            }

    return out


def parse_previous_verified(path: Path):
    if not path.exists():
        return {}

    result: dict[str, str | None] = {}
    current = None

    for line in path.read_text(encoding="utf-8").splitlines():
        match = re.match(r"^\s{2}(FAS-[A-Z0-9-]+):\s*$", line)
        if match:
            current = match.group(1)
            continue

        if current:
            verified = re.match(r"^\s{4}verified_against:\s*(.+?)\s*$", line)
            if verified:
                value = verified.group(1)
                result[current] = None if value == "null" else value.strip('"')

    return result


def q(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def validate_not_applicable(req_id: str, meta: dict[str, str], annotation: dict) -> None:
    if meta["class"] != "CONDITIONAL":
        raise ValueError(
            f"{req_id}: not_applicable is only valid for CONDITIONAL requirements"
        )

    condition = annotation["condition"]
    if not condition.endswith(":false"):
        raise ValueError(
            f"{req_id}: not_applicable condition must be explicitly evaluated false"
        )

    declared_name = meta["activation_condition"]
    evaluated_name = condition.rsplit(":", 1)[0]

    if declared_name not in {"always", evaluated_name} and evaluated_name not in declared_name:
        raise ValueError(
            f"{req_id}: evaluated activation condition {evaluated_name!r} "
            f"does not match declared condition {declared_name!r}"
        )

    if not annotation["reason"]:
        raise ValueError(f"{req_id}: not_applicable requires a justification")


def manifest_for(rfc_dir: Path, annotations, mark_verified: bool = False):
    semantic = rfc_dir / "semantic.md"
    requirements = extract_requirements(semantic)
    previous = parse_previous_verified(rfc_dir / "implemented" / "manifest.yml")

    match = re.match(r"^(RFC-FAS-\d{4})-", rfc_dir.name)
    rfc_id = match.group(1) if match else rfc_dir.name

    rows = [
        "# GENERATED FILE — DO NOT EDIT",
        "# Generated by tools/rfc_lock.py from semantic requirements and code annotations.",
        f"rfc: {q(rfc_id)}",
        "generated_by: tools/rfc_lock.py",
        "source_of_truth: semantic.md",
        "requirements:",
    ]

    for req_id, normalized, statement_hash, meta in requirements:
        annotation = annotations.get(
            req_id,
            {"sources": [], "tests": [], "evidence": [], "na": None},
        )
        verified = previous.get(req_id)

        sources = sorted(set(annotation["sources"]))
        tests = sorted(set(annotation["tests"]))
        fully_bound = bool(sources and tests)

        if annotation["na"]:
            validate_not_applicable(req_id, meta, annotation["na"])

        if mark_verified and fully_bound and not annotation["na"]:
            verified = statement_hash

        if annotation["na"]:
            status = "not_applicable"
        elif verified and verified != statement_hash:
            status = "stale"
        elif fully_bound:
            status = "implemented"
        elif sources or tests:
            status = "partial"
        else:
            status = "not_implemented"

        rows.extend(
            [
                f"  {req_id}:",
                f"    requirement_class: {meta['class'].lower()}",
                f"    activation_condition: {q(meta['activation_condition'])}",
                f"    required_evidence: {q(meta['required_evidence'])}",
                f"    statement_hash: {q(statement_hash)}",
                f"    verified_against: {q(verified) if verified else 'null'}",
                f"    status: {status}",
                "    sources:",
            ]
        )

        for source in sources:
            rows.append(f"      - {q(source)}")

        rows.append("    tests:")
        for test in tests:
            rows.append(f"      - {q(test)}")

        rows.append("    evidence_assertions:")
        for evidence in annotation["evidence"]:
            rows.append(f"      - path: {q(evidence['path'])}")
            rows.append(f"        assertion: {q(evidence['assertion'])}")

        if annotation["na"]:
            rows.extend(
                [
                    "    not_applicable:",
                    f"      activation_condition: {q(annotation['na']['condition'])}",
                    f"      justification: {q(annotation['na']['reason'])}",
                    f"      asserted_by: {q(annotation['na']['path'])}",
                ]
            )

        rows.append(f"    normalized_statement: {q(normalized)}")

    return "\n".join(rows) + "\n"


def verify_bindings(rfc_dir: Path, generated: str):
    bindings = rfc_dir / "implementation" / "bindings.yml"
    if not bindings.exists():
        raise ValueError(f"{rfc_dir}: missing implementation/bindings.yml")

    lock_ids = set(re.findall(r"^\s{2}(FAS-[A-Z0-9-]+):", generated, re.M))
    binding_text = bindings.read_text(encoding="utf-8")

    for req in set(re.findall(r"FAS-[A-Z][A-Z0-9]*-\d+", binding_text)):
        if req not in lock_ids:
            raise ValueError(f"{bindings}: references unknown requirement {req}")


def validate_refs(generated: str):
    for ref in re.findall(r'^\s+- "([^"]+)"\s*$', generated, re.M):
        if ref.startswith(("docs/", "src/", "tests/", "tools/")):
            if not (ROOT / ref).exists():
                raise ValueError(f"referenced path does not exist: {ref}")


def validate_test_visibility(generated: str):
    build_text = BUILD_FILE.read_text(encoding="utf-8") if BUILD_FILE.exists() else ""

    for test_path in re.findall(
        r'^\s+- "(docs/RFCs/.+/implemented/conformance\.zig)"\s*$',
        generated,
        re.M,
    ):
        if test_path not in build_text:
            raise ValueError(
                f"{test_path}: annotated conformance test is not reachable from build.zig"
            )


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    parser.add_argument(
        "--verify",
        action="store_true",
        help="mark fully bound requirements verified after successful conformance",
    )
    args = parser.parse_args()

    if args.verify and not args.write:
        print("error: --verify requires --write", file=sys.stderr)
        return 2

    try:
        annotations = scan_annotations()
    except ValueError as exc:
        print("error:", exc, file=sys.stderr)
        return 1

    errors: list[str] = []

    for rfc_dir in sorted(
        p for p in RFCS.iterdir() if p.is_dir() and p.name.startswith("RFC-FAS-")
    ):
        manifest = rfc_dir / "implemented" / "manifest.yml"

        try:
            generated = manifest_for(rfc_dir, annotations, mark_verified=args.verify)
            verify_bindings(rfc_dir, generated)
            validate_refs(generated)
            validate_test_visibility(generated)
        except ValueError as exc:
            errors.append(str(exc))
            continue

        if args.write:
            manifest.write_text(generated, encoding="utf-8")
        else:
            existing = manifest.read_text(encoding="utf-8") if manifest.exists() else ""
            if existing != generated:
                errors.append(
                    f"{manifest.relative_to(ROOT)} is not generated/current; "
                    "run: python tools/rfc_lock.py --write"
                )

    if errors:
        for error in errors:
            print("error:", error, file=sys.stderr)
        return 1

    if args.check:
        print("RFC semantic lockfiles are generated, current, and path-valid.")
    else:
        print("RFC semantic lockfiles generated.")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
