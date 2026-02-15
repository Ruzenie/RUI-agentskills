---
name: svg-canvas-icon-engine
description: Converts Kimi SVG/Canvas icon capabilities into an executable skill that generates icon manifests, specs, and reusable assets.
---

# SVG Canvas Icon Engine

Goal: provide consistent icon strategy and artifacts quickly when requirements involve icons, illustrations, or visualization.

## SSOT

- Kimi SVG/Canvas icon skill spec (Chinese-source directory in repo)
- Kimi SVG/Canvas icon cheatsheet (Chinese-source directory in repo)
- Kimi icon library reference (Chinese-source directory in repo)
- `../contracts/fullflow-handoff.md`
- `../contracts/quality-gates.md`

## When To Use

- Requirements mention icon systems, SVG, Canvas, visualization graphics, or dynamic shapes.
- You need unified icon style, sizing, naming, and delivery format.
- You need an icon baseline for UI generation.

## Executable Script

```bash
python3 skills/svg-canvas-icon-engine/scripts/generate_icon_assets.py \
  --brief "SaaS dashboard requiring navigation and status icons with motion support" \
  --framework react \
  --out-dir /tmp/icon-artifacts \
  --mode auto \
  --style outline
```

## Output Artifacts

- `icon.manifest.json`: icon inventory, categories, and technical route recommendation (SVG/Canvas)
- `icon.spec.md`: icon-system standards (size, stroke, naming, usage)
- `icon.sprite.svg`: reusable SVG symbol sprite
- `canvas.icon.demo.js`: starter Canvas drawing template (when needed)

## Rules

1. Prefer SVG by default
- For icons and UI controls, SVG is preferred by default (scalable, styleable, lightweight).

2. Canvas trigger conditions
- Recommend Canvas for heavy dynamic graphics, pixel operations, or complex rendering performance needs.

3. Style consistency
- Size tiers, stroke width, corner radius, line cap/join, and naming must be unified.

## Collaboration

- `ui-fullflow-orchestrator`: optional insertion stage that generates icon baselines.
- `ui-generation-workflow-runner`: prefer reusing `icon.sprite.svg` during implementation.
- `frontend-standards-enforcer`: checks naming, size, and maintainability consistency.
