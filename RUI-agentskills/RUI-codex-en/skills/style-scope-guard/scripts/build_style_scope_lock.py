#!/usr/bin/env python3
"""Build style scope lock artifacts to prevent out-of-scope code edits."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import List


STYLE_KEYWORDS = (
    "style",
    "style",
    "visual",
    "ui",
    "UI",
    "appearance",
    "glass",
    "glassmorphism",
    "color",
    "typography",
    "spacing",
    "radius",
)

TARGET_PATTERNS = (
    r"(?:enen|enen|enen|enen|enen|enenen|enen)([^  ,\n]{2,60}?)(?:style|style|visual|appearance|UI|ui)",
    r"(?:style|style|visual|appearance|UI|ui)(?:en|en|enen)([^  ,\n]{2,60})",
)


def normalize_text(value: str) -> str:
    return re.sub(r"\s+", " ", value or "").strip()


def parse_allowed_files(values: List[str]) -> List[str]:
    out: List[str] = []
    for item in values:
        chunks = [x.strip() for x in item.split(",")]
        for chunk in chunks:
            if chunk and chunk not in out:
                out.append(chunk)
    return out


def infer_target_from_brief(brief: str) -> str:
    text = normalize_text(brief)
    for pattern in TARGET_PATTERNS:
        match = re.search(pattern, text)
        if match:
            return normalize_text(match.group(1))
    if any(k in text for k in STYLE_KEYWORDS):
        return "global style enenenenenenconfirmenenenen "
    return ""


def build_markdown(payload: dict) -> str:
    target = payload.get("style_target") or "unlocked"
    allowed_files = payload.get("allowed_files", [])
    locked_areas = payload.get("locked_areas", [])
    forbidden = payload.get("forbidden_change_types", [])
    questions = payload.get("confirmation_questions", [])

    lines: List[str] = []
    lines.append("# Style Scope Checklist")
    lines.append("")
    lines.append(f"- scope_locked: {'yes' if payload.get('scope_locked') else 'no'}")
    lines.append(f"- style_target: {target}")
    lines.append("")
    lines.append("## Locked Areas")
    if locked_areas:
        for item in locked_areas:
            lines.append(f"- {item}")
    else:
        lines.append("- (none)")
    lines.append("")
    lines.append("## Allowed Files")
    if allowed_files:
        for file in allowed_files:
            lines.append(f"- {file}")
    else:
        lines.append("- (none, waiting user confirmation)")
    lines.append("")
    lines.append("## Forbidden Change Types")
    for item in forbidden:
        lines.append(f"- {item}")
    lines.append("")
    lines.append("## Pre-Edit Checklist")
    lines.append("- [ ] enenenstyleenentargetenen")
    lines.append("- [ ] enconfirmenenenenenenenen")
    lines.append("- [ ] enconfirmforbiddenenenenenenenenentargetenen")
    lines.append("")
    if questions:
        lines.append("## Need Confirmation")
        for q in questions:
            lines.append(f"- [ ] {q}")
        lines.append("")
    return "\n".join(lines) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(description="Build style scope lock artifacts")
    parser.add_argument("--brief", help="User brief text")
    parser.add_argument("--brief-file", help="Path to brief text file")
    parser.add_argument("--target", help="Explicit style target from user")
    parser.add_argument(
        "--allowed-file",
        action="append",
        default=[],
        help="Allowed file path for style edits, repeatable or comma-separated",
    )
    parser.add_argument("--json-out", required=True, help="Output path for style.scope.lock.json")
    parser.add_argument("--md-out", required=True, help="Output path for style.scope.checklist.md")
    args = parser.parse_args()

    brief = ""
    if args.brief_file:
        brief = Path(args.brief_file).read_text(encoding="utf-8").strip()
    elif args.brief:
        brief = args.brief.strip()

    explicit_target = normalize_text(args.target or "")
    inferred_target = infer_target_from_brief(brief) if not explicit_target else ""
    style_target = explicit_target or inferred_target
    allowed_files = parse_allowed_files(args.allowed_file or [])

    is_generic_target = style_target == "global style enenenenenenconfirmenenenen "
    scope_locked = bool(style_target) and not is_generic_target

    confirmation_questions: List[str] = []
    if not scope_locked:
        confirmation_questions.append("enenenenenenenstyleenen enen loginenenen sidebarenen enbutton  ")
    if not allowed_files:
        confirmation_questions.append("enconfirmenenenenenenenenenenen enenen  ")

    locked_areas = [style_target] if scope_locked else []

    payload = {
        "scope_locked": scope_locked,
        "style_target": style_target,
        "locked_areas": locked_areas,
        "allowed_files": allowed_files,
        "allowed_change_types": [
            "design_tokens",
            "css_rules",
            "class_name_style_binding",
            "layout_spacing_typography",
            "animation_transition",
        ],
        "forbidden_change_types": [
            "business_logic",
            "api_contract",
            "router_config",
            "state_shape",
            "data_fetching_flow",
            "dependency_change_unrelated_to_style",
        ],
        "non_target_code_policy": "forbiddenenentargetstyleenenenenenenenen ",
        "requires_confirmation": bool(confirmation_questions),
        "confirmation_questions": confirmation_questions,
    }

    json_out = Path(args.json_out)
    md_out = Path(args.md_out)
    json_out.parent.mkdir(parents=True, exist_ok=True)
    md_out.parent.mkdir(parents=True, exist_ok=True)
    json_out.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    md_out.write_text(build_markdown(payload), encoding="utf-8")
    print(json.dumps(payload, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
