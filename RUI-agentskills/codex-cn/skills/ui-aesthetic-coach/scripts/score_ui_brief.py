#!/usr/bin/env python3
"""Score UI brief quality and output actionable aesthetic guidance."""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from typing import Dict, List, Tuple


@dataclass(frozen=True)
class Dimension:
    key: str
    label: str
    keywords: Tuple[str, ...]
    improve: str


DIMENSIONS: Tuple[Dimension, ...] = (
    Dimension(
        key="hierarchy",
        label="视觉层级",
        keywords=(
            "hierarchy",
            "hero",
            "cta",
            "primary",
            "secondary",
            "priority",
            "headline",
            "section",
            "fold",
            "信息层级",
            "主次",
            "首屏",
            "标题",
            "模块",
            "行动按钮",
        ),
        improve="强化主次对比，压缩竞争性强调元素，确保3秒可读。",
    ),
    Dimension(
        key="typography",
        label="字体系统",
        keywords=(
            "typography",
            "font",
            "type scale",
            "line-height",
            "weight",
            "letter spacing",
            "readability",
            "字号",
            "字重",
            "行高",
            "字距",
            "可读性",
            "字体",
        ),
        improve="定义5-7级字体比例，统一字重用途，并校准正文行高。",
    ),
    Dimension(
        key="color",
        label="色彩系统",
        keywords=(
            "color",
            "palette",
            "semantic",
            "token",
            "contrast",
            "neutral",
            "accent",
            "颜色",
            "配色",
            "语义色",
            "中性色",
            "强调色",
            "对比度",
        ),
        improve="先定义语义角色色，再限制强调色数量并优化中性色阶。",
    ),
    Dimension(
        key="spacing",
        label="间距节奏",
        keywords=(
            "spacing",
            "padding",
            "margin",
            "grid",
            "density",
            "rhythm",
            "8pt",
            "4pt",
            "间距",
            "留白",
            "栅格",
            "密度",
            "节奏",
        ),
        improve="采用4/8pt节奏，明确页面级/区块级/组件级间距规则。",
    ),
    Dimension(
        key="components",
        label="组件一致性",
        keywords=(
            "component",
            "button",
            "input",
            "card",
            "variant",
            "radius",
            "shadow",
            "state",
            "组件",
            "按钮",
            "输入框",
            "卡片",
            "圆角",
            "阴影",
            "变体",
            "状态",
        ),
        improve="统一基础组件的圆角、边框、阴影与尺寸层级，减少特例。",
    ),
    Dimension(
        key="brand",
        label="品牌气质",
        keywords=(
            "brand",
            "tone",
            "voice",
            "personality",
            "premium",
            "playful",
            "professional",
            "品牌",
            "调性",
            "气质",
            "风格",
            "个性",
            "高端",
            "专业",
            "活泼",
        ),
        improve="提炼3个品牌形容词，并映射到字体、色彩、形态和动效决策。",
    ),
    Dimension(
        key="interaction",
        label="交互清晰度",
        keywords=(
            "hover",
            "focus",
            "active",
            "disabled",
            "loading",
            "error",
            "feedback",
            "状态",
            "悬停",
            "聚焦",
            "点击",
            "禁用",
            "加载",
            "错误",
            "反馈",
        ),
        improve="为关键交互补齐状态矩阵，确保操作反馈可预测。",
    ),
)

STYLE_DIRECTIONS: Tuple[Dict[str, object], ...] = (
    {
        "name": "Editorial Minimal",
        "score": 0,
        "triggers": ("portfolio", "premium", "editorial", "agency", "content", "品牌官网", "作品集", "高端"),
        "fit": "适合内容导向或高端品牌表达，强调留白与高级感。",
    },
    {
        "name": "Data Clarity",
        "score": 0,
        "triggers": ("dashboard", "analytics", "data", "saas", "admin", "后台", "数据", "看板", "运营"),
        "fit": "适合数据密集场景，优先清晰度与信任感。",
    },
    {
        "name": "Friendly Utility",
        "score": 0,
        "triggers": ("onboarding", "productivity", "smb", "utility", "workflow", "中小企业", "工具", "效率"),
        "fit": "适合工具型产品，平衡亲和力与功能效率。",
    },
    {
        "name": "Bold Productive",
        "score": 0,
        "triggers": ("creator", "growth", "mobile", "action", "conversion", "创作", "增长", "移动端", "转化"),
        "fit": "适合强调行动和增长的产品，CTA导向明确。",
    },
    {
        "name": "Neo Brutal Light",
        "score": 0,
        "triggers": ("campaign", "playful", "youth", "experimental", "memorable", "活动页", "年轻", "实验", "记忆点"),
        "fit": "适合品牌活动和差异化表达，视觉记忆点强。",
    },
    {
        "name": "Calm Glass",
        "score": 0,
        "triggers": ("ai", "assistant", "media", "futuristic", "immersive", "AI", "助手", "媒体", "未来感"),
        "fit": "适合AI与内容产品，营造柔和科技氛围。",
    },
)


def normalize_text(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip().lower()


def hit_count(content: str, keywords: Tuple[str, ...]) -> int:
    return sum(1 for kw in keywords if kw.lower() in content)


def score_from_hits(hits: int) -> int:
    if hits <= 0:
        return 1
    if hits <= 2:
        return 2
    if hits <= 4:
        return 3
    if hits <= 6:
        return 4
    return 5


def total_band(total: int) -> str:
    if total <= 14:
        return "基础薄弱，建议进行结构级重设计。"
    if total <= 24:
        return "中等水平，建议做系统性样式清理与重构。"
    if total <= 30:
        return "基础较好，建议强化品牌表达与细节抛光。"
    return "视觉成熟度高，建议优化边缘场景与一致性。"


def suggest_directions(content: str) -> List[Dict[str, str]]:
    ranked = []
    for item in STYLE_DIRECTIONS:
        score = hit_count(content, item["triggers"])
        ranked.append({"name": item["name"], "fit": item["fit"], "score": score})
    ranked.sort(key=lambda x: x["score"], reverse=True)

    if ranked[0]["score"] == 0:
        # Default safe set when no clear signal.
        return [
            {"name": "Data Clarity", "fit": "默认保守方向：先保证清晰和任务可达。", "score": 0},
            {"name": "Friendly Utility", "fit": "用于提升亲和力与可用性平衡。", "score": 0},
            {"name": "Editorial Minimal", "fit": "用于建立简洁高级的内容层次。", "score": 0},
        ]
    return ranked[:3]


def build_result(raw_text: str) -> Dict[str, object]:
    content = normalize_text(raw_text)
    results = []
    for dim in DIMENSIONS:
        hits = hit_count(content, dim.keywords)
        score = score_from_hits(hits)
        results.append(
            {
                "key": dim.key,
                "label": dim.label,
                "hits": hits,
                "score": score,
                "improve": dim.improve,
            }
        )

    total = sum(item["score"] for item in results)
    directions = suggest_directions(content)
    weakest = sorted(results, key=lambda x: x["score"])[:3]

    return {
        "total_score": total,
        "band": total_band(total),
        "dimensions": results,
        "top_issues": weakest,
        "recommended_direction": directions[0],
        "alternatives": directions[1:],
    }


def render_markdown(result: Dict[str, object]) -> str:
    dims = result["dimensions"]
    issues = result["top_issues"]
    rec = result["recommended_direction"]
    alts = result["alternatives"]

    lines: List[str] = []
    lines.append("## 审美诊断")
    lines.append(f"- 总分: **{result['total_score']}/35**")
    lines.append(f"- 结论: {result['band']}")
    lines.append("- 维度评分:")
    for item in dims:
        lines.append(f"  - {item['label']}: {item['score']}/5 (命中要素 {item['hits']})")

    lines.append("")
    lines.append("## 关键问题")
    for idx, item in enumerate(issues, start=1):
        lines.append(f"{idx}. {item['label']}偏弱: {item['improve']}")

    lines.append("")
    lines.append("## 设计方向")
    lines.append(f"- 推荐: **{rec['name']}** - {rec['fit']}")
    if alts:
        lines.append("- 备选:")
        for alt in alts:
            lines.append(f"  - {alt['name']} - {alt['fit']}")

    lines.append("")
    lines.append("## 快速规范建议")
    lines.append("- Typography: 建议建立 `12/14/16/20/24/32` 或同等比例级别。")
    lines.append("- Spacing: 建议采用 4/8pt 栅格，区块间距优先 24/32/48。")
    lines.append("- Color: 先定义语义色 token (`surface/text/border/primary/state`) 再上品牌强调色。")
    lines.append("- Components: 统一按钮/输入框/卡片的圆角、边框、状态样式。")

    lines.append("")
    lines.append("## 验收清单")
    lines.append("- [ ] 3秒内看清页面主目标与主CTA")
    lines.append("- [ ] 正文对比度与字号满足可读性")
    lines.append("- [ ] 交互状态完整（hover/focus/disabled/loading/error）")
    lines.append("- [ ] 视觉元素风格一致，无明显特例")

    return "\n".join(lines)


def read_input(path: str | None, text: str | None) -> str:
    if text:
        return text
    if path:
        with open(path, "r", encoding="utf-8") as f:
            return f.read()
    if not sys.stdin.isatty():
        return sys.stdin.read()
    raise SystemExit("请使用 --text、--file 或通过 stdin 提供 UI brief 文本。")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Score UI brief and output aesthetic guidance.")
    parser.add_argument("--file", help="Path to brief text file")
    parser.add_argument("--text", help="Inline brief text")
    parser.add_argument("--json", action="store_true", help="Output JSON instead of markdown")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    raw = read_input(args.file, args.text)
    result = build_result(raw)

    if args.json:
        print(json.dumps(result, ensure_ascii=False, indent=2))
    else:
        print(render_markdown(result))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
