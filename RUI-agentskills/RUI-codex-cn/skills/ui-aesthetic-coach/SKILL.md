---
name: ui-aesthetic-coach
description: Elevate UI visual quality and design taste with concrete critique, redesign direction, and style systems. Use when users ask for UI审美提升, visual polish, look-and-feel overhaul, design review, style guide definition, color/typography refinement, layout hierarchy improvements, or conversion of vague style intent into actionable design decisions for web/app interfaces.
---

# UI Aesthetic Coach

Deliver high-signal UI审美建议 that can be implemented immediately.
Focus on visual hierarchy, typography, color, spacing, composition, interaction clarity, and brand coherence.

## Workflow

1. Frame the brief.
- Extract product type, audience, platform, brand traits, and constraints.
- Infer missing context only when low risk; otherwise ask 1-2 targeted questions.

2. Diagnose current quality.
- Evaluate with `references/aesthetic-rubric.md`.
- Identify top 3 issues that most damage perceived quality.

3. Choose visual direction.
- If no clear direction exists, propose 2-3 options from `references/style-directions.md`.
- For each option, state mood, key components, and why it fits audience + brand.

4. Produce implementation-ready guidance.
- Specify typography scale, spacing system, radius/shadow policy, and component density.
- Specify color tokens (semantic roles first, then accent).
- Specify layout rules for hero/content/card/form/navigation patterns.

5. Validate quality.
- Re-score after proposed changes.
- Call out tradeoffs: expressiveness vs readability, novelty vs consistency, density vs accessibility.

## Deterministic Scoring

Use `scripts/score_ui_brief.py` when user provides text brief and asks for fast, repeatable scoring.

- Input options:
  - `--text "<brief>"`
  - `--file <brief.txt>`
  - stdin pipe
- Output modes:
  - default: markdown report
  - `--json`: structured result for downstream processing

Command examples:

```bash
python3 scripts/score_ui_brief.py --text "AI客服后台，强调数据可读性与主CTA"
python3 scripts/score_ui_brief.py --file brief.txt --json
cat brief.txt | python3 scripts/score_ui_brief.py
```

Use script output as baseline, then refine with context-specific design judgment.

## Deterministic Token Generation

Use `scripts/generate_design_tokens.py` when user needs implementation-ready design tokens (JSON/CSS).

- Inputs:
  - preset direction: `--direction`
  - density: `--density compact|comfortable|spacious`
  - optional brand override: `--brand-color #RRGGBB`
  - score linkage: `--from-score-json <score.json>`
- Outputs:
  - `--format json|css|both`
  - optional file write: `--json-out` and `--css-out`

Command examples:

```bash
python3 scripts/generate_design_tokens.py --direction "Data Clarity" --density comfortable --format both
python3 scripts/generate_design_tokens.py --direction "Bold Productive" --brand-color "#ff5a1f" --format css
python3 scripts/score_ui_brief.py --text "AI数据看板，强调可读性和主CTA" --json > score.json
python3 scripts/generate_design_tokens.py --from-score-json score.json --json-out tokens.json --css-out tokens.css
```

Prefer this pipeline for deterministic outputs:
1. `score_ui_brief.py` for diagnosis
2. `generate_design_tokens.py` for token artifacts
3. Manual refinement for brand nuances

## Output Contract

Structure responses in this order:

1. Aesthetic diagnosis (top issues and impact).
2. Design direction (one recommended + alternatives).
3. Design spec (tokens + component rules).
4. Before/after checklist (quick verification points).
5. Optional implementation prompt (for code/figma generation).

## Rules

- Prioritize coherence over decoration.
- Enforce strong hierarchy before adding visual effects.
- Use color to encode meaning, not random emphasis.
- Keep interaction states explicit: hover, active, focus, disabled, loading, error.
- Reject generic defaults when user asks for a distinctive look.
- Preserve accessibility baselines: text contrast, focus visibility, hit target size.

## Use References On Demand

- Read `references/aesthetic-rubric.md` when reviewing or scoring a UI.
- Read `references/style-directions.md` when proposing visual themes.
- Read `references/prompt-patterns.md` when user needs generation-ready prompts.

## Skill Collaboration

- Pair with `$ui-codegen-master` when the user also needs code implementation or refactor delivery.
- Pair with `$ui-selector-pro` when visual direction depends on component-library strategy.
- Pair with `$ui-aesthetic-generator` when the user needs generation-oriented visual spec output.
- Keep output boundaries clear:
  - This skill: diagnosis + direction + token strategy.
  - `$ui-aesthetic-generator`: generation-ready visual system.
  - Other skills: code generation, architecture, and library decisions.
