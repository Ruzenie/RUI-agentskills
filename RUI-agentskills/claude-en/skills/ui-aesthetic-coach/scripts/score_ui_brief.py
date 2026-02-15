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
        label="visualenen",
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
            "enenenen",
            "enen",
            "enen",
            "enen",
            "enen",
            "enenbutton",
        ),
        improve="enenenenenen enenenenenenenenen enen3enenen ",
    ),
    Dimension(
        key="typography",
        label="enenenen",
        keywords=(
            "typography",
            "font",
            "type scale",
            "line-height",
            "weight",
            "letter spacing",
            "readability",
            "enen",
            "enen",
            "enen",
            "enen",
            "enenen",
            "enen",
        ),
        improve="enen5-7enenenenen enenenenenen enenenenenenen ",
    ),
    Dimension(
        key="color",
        label="enenenen",
        keywords=(
            "color",
            "palette",
            "semantic",
            "token",
            "contrast",
            "neutral",
            "accent",
            "color",
            "enen",
            "enenen",
            "enenen",
            "enenen",
            "enenen",
        ),
        improve="enenenenenenenen enenenenenenenenenenenenenenen ",
    ),
    Dimension(
        key="spacing",
        label="spacingenen",
        keywords=(
            "spacing",
            "padding",
            "margin",
            "grid",
            "density",
            "rhythm",
            "8pt",
            "4pt",
            "spacing",
            "enen",
            "enen",
            "enen",
            "enen",
        ),
        improve="enen4/8ptenen enenenenen/enenen/enenenspacingenen ",
    ),
    Dimension(
        key="components",
        label="enenenenen",
        keywords=(
            "component",
            "button",
            "input",
            "card",
            "variant",
            "radius",
            "shadow",
            "state",
            "enen",
            "button",
            "enenen",
            "enen",
            "radius",
            "enen",
            "enen",
            "enen",
        ),
        improve="enenenenenenenradius enen enenenenenenen enenenen ",
    ),
    Dimension(
        key="brand",
        label="enenenen",
        keywords=(
            "brand",
            "tone",
            "voice",
            "personality",
            "premium",
            "playful",
            "professional",
            "enen",
            "enen",
            "enen",
            "style",
            "enen",
            "enen",
            "enen",
            "enen",
        ),
        improve="enen3enenenenenen enenenenenen enen enenenenenenen ",
    ),
    Dimension(
        key="interaction",
        label="enenenenen",
        keywords=(
            "hover",
            "focus",
            "active",
            "disabled",
            "loading",
            "error",
            "feedback",
            "enen",
            "enen",
            "enen",
            "enen",
            "enen",
            "enen",
            "enen",
            "enen",
        ),
        improve="enenenenenenenenenenen enenenenenenenenen ",
    ),
)

STYLE_DIRECTIONS: Tuple[Dict[str, object], ...] = (
    {
        "name": "Editorial Minimal",
        "score": 0,
        "triggers": ("portfolio", "premium", "editorial", "agency", "content", "enenenen", "enenen", "enen"),
        "fit": "enenenenenenenenenenenenen enenenenenenenen ",
    },
    {
        "name": "Data Clarity",
        "score": 0,
        "triggers": ("dashboard", "analytics", "data", "saas", "admin", "enen", "data", "dashboard", "enen"),
        "fit": "enendataenenenen enenenenenenenenen ",
    },
    {
        "name": "Friendly Utility",
        "score": 0,
        "triggers": ("onboarding", "productivity", "smb", "utility", "workflow", "enenenen", "enen", "enen"),
        "fit": "enenenenenenen enenenenenenenenenen ",
    },
    {
        "name": "Bold Productive",
        "score": 0,
        "triggers": ("creator", "growth", "mobile", "action", "conversion", "enen", "enen", "enenen", "enen"),
        "fit": "enenenenenenenenenenenen CTAenenenen ",
    },
    {
        "name": "Neo Brutal Light",
        "score": 0,
        "triggers": ("campaign", "playful", "youth", "experimental", "memorable", "enenen", "enen", "enen", "enenen"),
        "fit": "enenenenenenenenenenenen visualenenenen ",
    },
    {
        "name": "Calm Glass",
        "score": 0,
        "triggers": ("ai", "assistant", "media", "futuristic", "immersive", "AI", "enen", "enen", "enenen"),
        "fit": "enenAIenenenenen enenenenenenenen ",
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
        return "enenenen enenenenstructureenenenen "
    if total <= 24:
        return "enenenen enenenenenenstyleenenenenen "
    if total <= 30:
        return "enenenen enenenenenenenenenenenenen "
    return "visualenenenen enenenenenenenenenenenen "


def suggest_directions(content: str) -> List[Dict[str, str]]:
    ranked = []
    for item in STYLE_DIRECTIONS:
        score = hit_count(content, item["triggers"])
        ranked.append({"name": item["name"], "fit": item["fit"], "score": score})
    ranked.sort(key=lambda x: x["score"], reverse=True)

    if ranked[0]["score"] == 0:
        # Default safe set when no clear signal.
        return [
            {"name": "Data Clarity", "fit": "enenenenenen enenenenenenenenenen ", "score": 0},
            {"name": "Friendly Utility", "fit": "enenenenenenenenenenenenen ", "score": 0},
            {"name": "Editorial Minimal", "fit": "enenenenenenenenenenenenen ", "score": 0},
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
    lines.append("## aestheticenen")
    lines.append(f"- enen: **{result['total_score']}/35**")
    lines.append(f"- enen: {result['band']}")
    lines.append("- enenenen:")
    for item in dims:
        lines.append(f"  - {item['label']}: {item['score']}/5 (enenenen {item['hits']})")

    lines.append("")
    lines.append("## enenenen")
    for idx, item in enumerate(issues, start=1):
        lines.append(f"{idx}. {item['label']}enen: {item['improve']}")

    lines.append("")
    lines.append("## enenenen")
    lines.append(f"- enen: **{rec['name']}** - {rec['fit']}")
    if alts:
        lines.append("- enen:")
        for alt in alts:
            lines.append(f"  - {alt['name']} - {alt['fit']}")

    lines.append("")
    lines.append("## enenenenenen")
    lines.append("- Typography: enenenen `12/14/16/20/24/32` enenenenenenen ")
    lines.append("- Spacing: enenenen 4/8pt enen enenspacingenen 24/32/48 ")
    lines.append("- Color: enenenenenen token (`surface/text/border/primary/state`) enenenenenenen ")
    lines.append("- Components: enenbutton/enenen/enenenradius enen enenstyle ")

    lines.append("")
    lines.append("## acceptanceenen")
    lines.append("- [ ] 3enenenenenenentargetenenCTA")
    lines.append("- [ ] enenenenenenenenenenenenen")
    lines.append("- [ ] enenenenenen hover/focus/disabled/loading/error ")
    lines.append("- [ ] visualenenstyleenen enenenenen")

    return "\n".join(lines)


def read_input(path: str | None, text: str | None) -> str:
    if text:
        return text
    if path:
        with open(path, "r", encoding="utf-8") as f:
            return f.read()
    if not sys.stdin.isatty():
        return sys.stdin.read()
    raise SystemExit("enenen --text --file enenen stdin enen UI brief enen ")


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
