#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Dict, List

LOGIC_INDICATORS = [
    r"\bfetch\s*\(",
    r"\baxios\.",
    r"\bdispatch\s*\(",
    r"\buseEffect\s*\(",
    r"\brouter\.",
    r"\bapi[A-Z_\-]",
]


def parse_changed(args: argparse.Namespace) -> List[str]:
    items: List[str] = []
    for v in args.changed_file or []:
        if v and v not in items:
            items.append(v)
    if args.changed_files:
        for p in args.changed_files.split(","):
            p = p.strip()
            if p and p not in items:
                items.append(p)
    return items


def main() -> None:
    parser = argparse.ArgumentParser(description="Validate style scope lock against changed files")
    parser.add_argument("--lock-file", required=True)
    parser.add_argument("--changed-file", action="append", default=[])
    parser.add_argument("--changed-files", default="")
    parser.add_argument("--workspace-root", default=".")
    parser.add_argument("--json-out", default="")
    args = parser.parse_args()

    lock = json.loads(Path(args.lock_file).read_text(encoding="utf-8"))
    changed = parse_changed(args)
    workspace = Path(args.workspace_root).resolve()

    allowed_files = set(lock.get("allowed_files") or [])
    forbidden_patterns = [x.get("pattern", "") for x in (lock.get("forbidden_patterns") or []) if isinstance(x, dict)]
    forbidden_css_props = {x.get("property") for x in (lock.get("forbidden_css_properties") or []) if isinstance(x, dict) and x.get("property")}
    allowed_css_props = set(lock.get("allowed_css_properties") or [])

    violations: List[Dict[str, str]] = []

    # file boundary checks
    for f in changed:
        if allowed_files and f not in allowed_files:
            violations.append({"type": "file_boundary", "file": f, "reason": "不在 allowed_files 中"})
        for pattern in forbidden_patterns:
            regex = "^" + re.escape(pattern).replace("\\*", ".*") + "$"
            if pattern and re.match(regex, f):
                violations.append({"type": "forbidden_pattern", "file": f, "reason": f"命中禁止模式: {pattern}"})

    # heuristic logic-change checks
    for f in changed:
        p = (workspace / f).resolve()
        if not p.exists() or not p.is_file():
            continue
        if p.suffix.lower() not in {".ts", ".tsx", ".js", ".jsx", ".vue", ".svelte"}:
            continue
        content = p.read_text(encoding="utf-8", errors="ignore")
        for indicator in LOGIC_INDICATORS:
            if re.search(indicator, content):
                violations.append({"type": "logic_change", "file": f, "reason": f"检测到逻辑变更信号: {indicator}"})
                break

    # css property policy checks
    for f in changed:
        p = (workspace / f).resolve()
        if not p.exists() or not p.is_file():
            continue
        if p.suffix.lower() not in {".css", ".scss", ".less", ".sass"}:
            continue
        content = p.read_text(encoding="utf-8", errors="ignore")
        props = re.findall(r"([a-zA-Z-]+)\s*:", content)
        for prop in props:
            prop_l = prop.lower()
            if prop_l in forbidden_css_props:
                violations.append({"type": "css_forbidden_property", "file": f, "reason": f"命中禁止CSS属性: {prop_l}"})
            if allowed_css_props and prop_l not in allowed_css_props:
                # keep this as warning-level violation signal to make scope risk visible
                violations.append({"type": "css_outside_allowed", "file": f, "reason": f"超出允许CSS属性白名单: {prop_l}"})

    result = {
        "scope_lock_valid": len(violations) == 0,
        "lock_file": args.lock_file,
        "changed_files": changed,
        "violations": violations,
        "summary": {
            "changed_count": len(changed),
            "violation_count": len(violations),
        },
    }

    out = json.dumps(result, ensure_ascii=False, indent=2)
    if args.json_out:
        Path(args.json_out).write_text(out + "\n", encoding="utf-8")
    print(out)

    if not result["scope_lock_valid"]:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
