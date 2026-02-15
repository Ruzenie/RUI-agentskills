#!/usr/bin/env python3
"""Generate icon system artifacts (manifest/spec/sprite/demo) from a brief."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Dict, List, Tuple


ICON_CATALOG: Dict[str, List[Dict[str, str]]] = {
    "navigation": [
        {"id": "home", "label": "enen", "path": "M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z M9 22V12h6v10"},
        {"id": "menu", "label": "enen", "path": "M3 6h18 M3 12h18 M3 18h18"},
        {"id": "search", "label": "enen", "path": "M11 11m-8 0a8 8 0 1 0 16 0a8 8 0 1 0 -16 0 M21 21l-4.35-4.35"},
        {"id": "arrow-left", "label": "enen", "path": "M19 12H5 M12 19l-7-7 7-7"},
    ],
    "user": [
        {"id": "user", "label": "enen", "path": "M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2 M12 11a4 4 0 1 0 0-8a4 4 0 0 0 0 8"},
        {"id": "users", "label": "enenen", "path": "M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2 M9 11a4 4 0 1 0 0-8a4 4 0 0 0 0 8 M23 21v-2a4 4 0 0 0-3-3.87"},
        {"id": "login", "label": "login", "path": "M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4 M10 17l5-5-5-5 M15 12H3"},
    ],
    "action": [
        {"id": "edit", "label": "enen", "path": "M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7 M18.5 2.5a2.12 2.12 0 0 1 3 3L12 15l-4 1 1-4z"},
        {"id": "trash", "label": "enen", "path": "M3 6h18 M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6 M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"},
        {"id": "save", "label": "enen", "path": "M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2 M17 21v-8H7v8"},
    ],
    "status": [
        {"id": "check", "label": "enen", "path": "M20 6L9 17l-5-5"},
        {"id": "warning", "label": "enen", "path": "M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0 M12 9v4 M12 17h.01"},
        {"id": "error", "label": "enen", "path": "M12 2a10 10 0 1 0 0 20a10 10 0 0 0 0-20 M15 9l-6 6 M9 9l6 6"},
        {"id": "info", "label": "enen", "path": "M12 8h.01 M11 12h2v6h-2z M12 2a10 10 0 1 0 0 20a10 10 0 0 0 0-20"},
    ],
    "data": [
        {"id": "bar-chart", "label": "enenen", "path": "M4 20V10 M10 20V4 M16 20v-7 M22 20v-12 M2 20h20"},
        {"id": "line-chart", "label": "enenen", "path": "M3 17l5-5 4 3 8-8 M3 21h18"},
        {"id": "pie-chart", "label": "enen", "path": "M12 2v10h10 A10 10 0 1 1 12 2"},
    ],
}

ICON_KEYWORDS = ("icon", "icon", "svg", "canvas", "enen", "logo", "enenen")
CANVAS_HINTS = ("enen", "enen", "enen", "enenenen", "enenenen", "enen", "enen")

CATEGORY_HINTS: List[Tuple[str, Tuple[str, ...]]] = [
    ("navigation", ("enen", "enen", "enen", "enen")),
    ("user", ("enen", "enen", "login", "enen")),
    ("action", ("enen", "enen", "enen", "enen")),
    ("status", ("enen", "enen", "enen", "enen")),
    ("data", ("enen", "data", "enen", "enen")),
]


def normalize(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip().lower()


def needs_icons(brief: str) -> bool:
    text = normalize(brief)
    return any(k in text for k in ICON_KEYWORDS)


def choose_engine(brief: str, mode: str) -> str:
    if mode in ("svg", "canvas"):
        return mode
    text = normalize(brief)
    if any(k in text for k in CANVAS_HINTS):
        return "canvas"
    return "svg"


def choose_categories(brief: str, categories: List[str]) -> List[str]:
    if categories:
        out = [c for c in categories if c in ICON_CATALOG]
        return out if out else ["navigation", "action", "status"]
    text = normalize(brief)
    selected: List[str] = []
    for key, hints in CATEGORY_HINTS:
        if any(h in text for h in hints):
            selected.append(key)
    return selected if selected else ["navigation", "action", "status"]


def build_sprite(icons: List[Dict[str, str]]) -> str:
    lines: List[str] = []
    lines.append('<svg xmlns="http://www.w3.org/2000/svg" style="display:none;">')
    lines.append("  <defs>")
    for icon in icons:
        lines.append(f'    <symbol id="icon-{icon["id"]}" viewBox="0 0 24 24">')
        lines.append(
            f'      <path d="{icon["path"]}" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />'
        )
        lines.append("    </symbol>")
    lines.append("  </defs>")
    lines.append("</svg>")
    lines.append("")
    lines.append("<!-- Usage: <svg width=\"24\" height=\"24\"><use href=\"#icon-home\" /></svg> -->")
    return "\n".join(lines) + "\n"


def build_canvas_demo() -> str:
    return """// Canvas icon starter
const canvas = document.getElementById('icon-canvas');
const ctx = canvas.getContext('2d');
canvas.width = 128;
canvas.height = 128;

ctx.clearRect(0, 0, canvas.width, canvas.height);
ctx.strokeStyle = '#2563eb';
ctx.lineWidth = 6;
ctx.lineCap = 'round';
ctx.lineJoin = 'round';

// simple check icon
ctx.beginPath();
ctx.moveTo(28, 66);
ctx.lineTo(54, 92);
ctx.lineTo(100, 36);
ctx.stroke();
"""


def build_spec(engine: str, style: str, categories: List[str], icon_count: int) -> str:
    cat_text = ", ".join(categories)
    return f"""# Icon System Spec

## Summary
- engine: {engine}
- style: {style}
- categories: {cat_text}
- icon_count: {icon_count}

## Design Rules
- enenenen 16/20/24 enen 24 
- enenenen 2px enenenenenenenenen 1.5px 
- enenenen round
- enenenen `icon-<category>-<name>`

## Usage Rules
- UI iconenenenen SVG sprite enenenenenenenen 
- enenenenenen enenenenenenenenenen Canvas 
- iconenenenenenenen enenspacing 8px 
- eneniconcolorenenenenenen success/warning/error/info  
"""


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate icon system artifacts")
    parser.add_argument("--brief", help="Brief text")
    parser.add_argument("--brief-file", help="Brief file path")
    parser.add_argument("--framework", default="unknown", help="Framework id")
    parser.add_argument("--out-dir", required=True, help="Output directory")
    parser.add_argument("--mode", default="auto", choices=["auto", "svg", "canvas"], help="Preferred render engine")
    parser.add_argument("--style", default="outline", choices=["outline", "filled", "two-tone"], help="Icon style")
    parser.add_argument("--category", action="append", default=[], help="Target category (repeatable)")
    parser.add_argument("--json", action="store_true", help="Print JSON summary")
    args = parser.parse_args()

    brief = ""
    if args.brief_file:
        brief = Path(args.brief_file).read_text(encoding="utf-8").strip()
    elif args.brief:
        brief = args.brief.strip()

    if not brief:
        raise SystemExit("brief is required: use --brief or --brief-file")

    icon_requested = needs_icons(brief)
    engine = choose_engine(brief, args.mode)
    categories = choose_categories(brief, args.category)

    icons: List[Dict[str, str]] = []
    for category in categories:
        icons.extend([{**item, "category": category} for item in ICON_CATALOG.get(category, [])[:3]])

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    manifest_path = out_dir / "icon.manifest.json"
    spec_path = out_dir / "icon.spec.md"
    sprite_path = out_dir / "icon.sprite.svg"
    canvas_demo_path = out_dir / "canvas.icon.demo.js"

    manifest = {
        "icon_requested": icon_requested,
        "framework": args.framework,
        "engine": engine,
        "style": args.style,
        "categories": categories,
        "icon_count": len(icons),
        "icons": [{"id": icon["id"], "label": icon["label"], "category": icon["category"]} for icon in icons],
        "artifacts": {
            "icon_manifest": str(manifest_path),
            "icon_spec": str(spec_path),
            "icon_sprite": str(sprite_path),
            "canvas_demo": str(canvas_demo_path),
        },
    }

    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    spec_path.write_text(build_spec(engine, args.style, categories, len(icons)), encoding="utf-8")
    sprite_path.write_text(build_sprite(icons), encoding="utf-8")
    canvas_demo_path.write_text(build_canvas_demo(), encoding="utf-8")

    if args.json:
        print(json.dumps(manifest, ensure_ascii=False, indent=2))
    else:
        print(f"icon_requested: {icon_requested}")
        print(f"engine: {engine}")
        print(f"categories: {', '.join(categories)}")
        print(f"icon_count: {len(icons)}")
        print(f"out: {out_dir}")


if __name__ == "__main__":
    main()
