#!/usr/bin/env python3
"""Render CN/EN skill index markdown from bilingual JSON catalog."""

from __future__ import annotations

import json
from collections import OrderedDict
from pathlib import Path


def render_cn(skills: list[dict]) -> str:
    grouped: OrderedDict[str, list[dict]] = OrderedDict()
    for item in skills:
        grouped.setdefault(item["category_zh"], []).append(item)

    lines = ["# Skills 索引（中文）", "", "本文件由双语清单自动生成。", ""]
    idx = 1
    for category, items in grouped.items():
        lines.append(f"## {category}")
        lines.append("")
        for it in items:
            lines.append(f"{idx}. `{it['id']}`")
            lines.append(f"- {it['title_zh']}：{it['desc_zh']}")
            idx += 1
        lines.append("")
    lines.append("校验命令：`python3 skills/skill-structure-governor/scripts/validate_structure.py`")
    lines.append("分发命令：`python3 skills/skill-structure-governor/scripts/export_skill_bundles.py`")
    lines.append("")
    return "\n".join(lines)


def render_en(skills: list[dict]) -> str:
    grouped: OrderedDict[str, list[dict]] = OrderedDict()
    for item in skills:
        grouped.setdefault(item["category_en"], []).append(item)

    lines = ["# Skills Index (English)", "", "This file is generated from the bilingual catalog.", ""]
    idx = 1
    for category, items in grouped.items():
        lines.append(f"## {category}")
        lines.append("")
        for it in items:
            lines.append(f"{idx}. `{it['id']}`")
            lines.append(f"- {it['title_en']}: {it['desc_en']}")
            idx += 1
        lines.append("")
    lines.append("Validation command: `python3 skills/skill-structure-governor/scripts/validate_structure.py`")
    lines.append("Export command: `python3 skills/skill-structure-governor/scripts/export_skill_bundles.py`")
    lines.append("")
    return "\n".join(lines)


def main() -> int:
    root = Path(__file__).resolve().parents[3]
    catalog_path = root / "skills" / "variants" / "skills.bilingual.json"
    data = json.loads(catalog_path.read_text(encoding="utf-8"))
    skills = data.get("skills", [])

    cn_path = root / "skills" / "variants" / "CN" / "SKILLS.md"
    en_path = root / "skills" / "variants" / "EN" / "SKILLS.md"
    cn_path.write_text(render_cn(skills), encoding="utf-8")
    en_path.write_text(render_en(skills), encoding="utf-8")
    print("rendered:", cn_path)
    print("rendered:", en_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
