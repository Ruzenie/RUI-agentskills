#!/usr/bin/env python3
"""Build style scope lock artifacts to prevent out-of-scope code edits."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import List
from datetime import datetime, timezone


STYLE_KEYWORDS = (
    "样式",
    "风格",
    "视觉",
    "ui",
    "UI",
    "外观",
    "glass",
    "glassmorphism",
    "颜色",
    "排版",
    "间距",
    "圆角",
)

TARGET_PATTERNS = (
    r"(?:修改|优化|调整|改造|重做|改一下|改下)([^。；,\n]{2,60}?)(?:样式|风格|视觉|外观|UI|ui)",
    r"(?:样式|风格|视觉|外观|UI|ui)(?:在|为|针对)([^。；,\n]{2,60})",
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
        return "全局样式（需用户进一步确认具体区域）"
    return ""


def build_markdown(payload: dict) -> str:
    target = payload.get("style_target") or "未锁定"
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
    lines.append("## Forbidden File Patterns")
    for item in payload.get("forbidden_patterns", []):
        lines.append(f"- {item.get('pattern')}: {item.get('reason')}")
    lines.append("")
    lines.append("## CSS Property Policy")
    lines.append("- allowed_css_properties:")
    for prop in payload.get("allowed_css_properties", []):
        lines.append(f"  - {prop}")
    lines.append("- forbidden_css_properties:")
    for item in payload.get("forbidden_css_properties", []):
        lines.append(f"  - {item.get('property')}: {item.get('reason')}")
    lines.append("")
    lines.append("## Pre-Edit Checklist")
    lines.append("- [ ] 已明确样式改动目标区域")
    lines.append("- [ ] 已确认允许改动文件清单")
    lines.append("- [ ] 已确认禁止改动业务逻辑与非目标模块")
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

    is_generic_target = style_target == "全局样式（需用户进一步确认具体区域）"
    scope_locked = bool(style_target) and not is_generic_target

    confirmation_questions: List[str] = []
    if not scope_locked:
        confirmation_questions.append("请明确要修改的样式区域（例如：登录页头部、侧边栏导航、主按钮）。")
    if not allowed_files:
        confirmation_questions.append("请确认允许改动的文件路径清单（可多项）。")

    locked_areas = [style_target] if scope_locked else []

    payload = {
        "version": "2.0.0",
        "scope_locked": scope_locked,
        "style_target": style_target,
        "locked_areas": locked_areas,
        "allowed_files": allowed_files,
        "forbidden_patterns": [
            {"pattern": "*.service.ts", "reason": "禁止修改服务层"},
            {"pattern": "*.{spec,test}.ts", "reason": "禁止修改测试文件"},
            {"pattern": "src/routes/*", "reason": "禁止修改路由配置"},
            {"pattern": "src/store/*", "reason": "禁止修改状态管理"},
            {"pattern": "src/api/*", "reason": "禁止修改API层"},
        ],
        "allowed_change_types": [
            "design_tokens",
            "css_rules",
            "class_name_style_binding",
            "layout_spacing_typography",
            "animation_transition",
        ],
        "allowed_css_properties": [
            "color",
            "background",
            "font-size",
            "padding",
            "margin",
            "border",
            "border-radius",
            "box-shadow",
            "display",
            "flex",
            "gap",
            "line-height",
            "letter-spacing",
            "opacity",
            "transition",
        ],
        "forbidden_css_properties": [
            {"property": "position", "reason": "可能影响布局结构"},
            {"property": "z-index", "reason": "可能破坏层级关系"},
            {"property": "transform", "reason": "可能影响动效和布局"},
        ],
        "forbidden_change_types": [
            "business_logic",
            "api_contract",
            "router_config",
            "state_shape",
            "data_fetching_flow",
            "dependency_change_unrelated_to_style",
        ],
        "validation_hooks": {
            "pre_commit": "check_style_boundary",
            "post_change": "verify_no_logic_change",
            "ci_pipeline": "validate_scope_lock",
        },
        "audit_log": [
            {
                "action": "scope_locked" if scope_locked else "scope_pending",
                "timestamp": datetime.now(timezone.utc).isoformat(),
                "by": "style-scope-guard",
            }
        ],
        "non_target_code_policy": "禁止修改目标样式范围外的任何代码。",
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
