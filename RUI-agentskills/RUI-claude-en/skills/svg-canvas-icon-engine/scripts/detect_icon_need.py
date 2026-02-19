#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
from dataclasses import asdict, dataclass


@dataclass
class IconNeedAnalysis:
    needed: bool
    confidence: float
    categories: list[str]
    estimated_count: int
    style_preference: str
    rationale: str
    keywords_found: list[str]


ICON_PATTERNS = {
    "navigation": {"patterns": [r"导航", r"菜单", r"sidebar", r"breadcrumb", r"tab", r"nav"], "typical": 5, "weight": 0.9},
    "action": {"patterns": [r"按钮", r"操作", r"提交", r"删除", r"编辑", r"添加"], "typical": 8, "weight": 0.7},
    "status": {"patterns": [r"状态", r"成功", r"失败", r"警告", r"loading", r"spinner"], "typical": 6, "weight": 0.8},
    "data_visualization": {"patterns": [r"图表", r"统计", r"dashboard", r"analytics", r"graph", r"chart"], "typical": 10, "weight": 1.0},
    "brand": {"patterns": [r"logo", r"品牌", r"标识", r"favicon"], "typical": 3, "weight": 0.9},
}

STYLE_PATTERNS = {
    "outline": [r"简洁", r"现代", r"minimal", r"clean", r"outline"],
    "filled": [r"饱满", r"solid", r"填充", r"醒目"],
    "two-tone": [r"双色", r"渐变", r"多彩", r"colorful", r"two-tone"],
}


def detect_style(text: str) -> str:
    scores = {}
    for style, patterns in STYLE_PATTERNS.items():
        score = sum(1 for p in patterns if re.search(p, text, re.IGNORECASE))
        if score:
            scores[style] = score
    return max(scores, key=scores.get) if scores else "outline"


def analyze(brief: str) -> IconNeedAnalysis:
    text = brief or ""
    lower = text.lower()
    categories = []
    keywords = []
    total_weight = 0.0

    for category, cfg in ICON_PATTERNS.items():
        for pattern in cfg["patterns"]:
            if re.search(pattern, lower, re.IGNORECASE):
                categories.append(category)
                keywords.append(pattern)
                total_weight += float(cfg["weight"])
                break

    confidence = 0.1 if not categories else min(0.95, 0.3 + total_weight * 0.2)
    estimated = 0
    if categories:
        estimated = int(sum(ICON_PATTERNS[c]["typical"] for c in categories) / len(categories))

    needed = confidence > 0.5 or len(categories) > 0
    rationale = "未检测到明确图标需求" if not categories else f"检测到{len(categories)}类图标需求: {', '.join(categories)}"

    return IconNeedAnalysis(
        needed=needed,
        confidence=round(confidence, 2),
        categories=categories,
        estimated_count=estimated,
        style_preference=detect_style(lower),
        rationale=rationale,
        keywords_found=sorted(set(keywords))[:8],
    )


def main() -> None:
    parser = argparse.ArgumentParser(description="Detect icon requirements from brief")
    parser.add_argument("--brief", default="")
    parser.add_argument("--brief-file", default="")
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()

    brief = args.brief
    if args.brief_file:
        with open(args.brief_file, "r", encoding="utf-8") as f:
            brief = f.read()

    result = asdict(analyze(brief))
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
