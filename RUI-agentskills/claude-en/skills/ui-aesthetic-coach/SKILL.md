---
name: ui-aesthetic-coach
description: Elevates UI visual quality with concrete critique, redesign direction, and style systems. Use when users request visual polish, style direction, design review, or actionable conversion from vague aesthetic intent.
---

# UI Aesthetic Coach

Goal: deliver high-signal aesthetic guidance that can be implemented immediately.

Focus areas: visual hierarchy, typography, color, spacing, composition, interaction clarity, and brand coherence.

## Workflow

1. Frame the brief
- Extract product type, audience, platform, brand traits, and constraints.
- Infer missing context only when low-risk; otherwise ask 1-2 targeted questions.

2. Diagnose current quality
- Evaluate with `references/aesthetic-rubric.md`.
- Identify the top 3 issues that most damage perceived quality.

3. Choose visual direction
- If direction is unclear, propose 2-3 options from `references/style-directions.md`.
- For each option, explain mood, key components, and fit to audience + brand.

4. Produce implementation-ready guidance
- Specify typography scale, spacing system, radius/shadow policy, and component density.
- Specify color tokens (semantic roles first, accent second).
- Specify layout rules for hero/content/card/form/navigation patterns.

5. Validate quality
- Re-score after proposed changes.
- Explain tradeoffs: expressiveness vs readability, novelty vs consistency, density vs accessibility.

## Deterministic Scoring

Use `scripts/score_ui_brief.py` when users provide text briefs and require repeatable scoring.

- Input options:
  - `--text "<brief>"`
  - `--file <brief.txt>`
  - stdin pipe
- Output modes:
  - default: markdown report
  - `--json`: structured output for downstream processing

Command examples:

```bash
python3 scripts/score_ui_brief.py --text "AI customer-support console emphasizing data readability and primary CTA"
python3 scripts/score_ui_brief.py --file brief.txt --json
cat brief.txt | python3 scripts/score_ui_brief.py
```

Use script output as baseline, then refine with context-specific design judgment.

## Deterministic Token Generation

Use `scripts/generate_design_tokens.py` when implementation-ready design tokens (JSON/CSS) are required.

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
python3 scripts/score_ui_brief.py --text "AI dashboard emphasizing readability and primary CTA" --json > score.json
python3 scripts/generate_design_tokens.py --from-score-json score.json --json-out tokens.json --css-out tokens.css
```

Preferred deterministic pipeline:
1. `score_ui_brief.py` for diagnosis
2. `generate_design_tokens.py` for token artifacts
3. Manual refinement for brand nuances

## Output Contract

Return in this order:

1. Aesthetic diagnosis (top issues and impact)
2. Design direction (one recommendation + alternatives)
3. Design spec (tokens + component rules)
4. Before/after checklist (quick verification)
5. Optional implementation prompt (for code/Figma generation)

## Rules

- Prioritize coherence over decoration.
- Enforce strong hierarchy before adding visual effects.
- Use color to encode meaning, not random emphasis.
- Keep interaction states explicit: hover, active, focus, disabled, loading, error.
- Reject generic defaults when users request a distinctive look.
- Preserve accessibility baseline: text contrast, focus visibility, hit target size.

## Use References On Demand

- Read `references/aesthetic-rubric.md` when reviewing/scoring UI.
- Read `references/style-directions.md` when proposing visual themes.
- Read `references/prompt-patterns.md` when generation-ready prompts are needed.

## Skill Collaboration

- Pair with `$ui-codegen-master` when implementation/refactor delivery is required.
- Pair with `$ui-selector-pro` when visual direction depends on library strategy.
- Pair with `$ui-aesthetic-generator` when generation-oriented spec output is required.
- Keep boundaries clear:
  - This skill: diagnosis + direction + token strategy.
  - `$ui-aesthetic-generator`: generation-ready visual system.
  - Other skills: code generation, architecture, and library decisions.
