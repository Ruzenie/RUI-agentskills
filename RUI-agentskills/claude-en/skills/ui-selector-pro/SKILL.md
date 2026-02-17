---
name: ui-selector-pro
description: Performs systematic UI library selection, evaluation, and comparison. Reuses real data and scoring logic from app when available, and outputs implementable technical decisions with risk explanations.
---

# UI Selector Pro

Goal: combine repository methodology docs with real data in `app/src/data/uiLibraries.ts` into repeatable selection capability.

## When To Use

- Users need recommendations for UI component libraries, CSS frameworks, or headless solutions.
- Users need quantified multi-option evaluation (accessibility, performance, customization, DX, ecosystem, enterprise readiness).
- Users need migration suggestions, comparison tables, or POC evaluation framework.

## Data and Implementation Sources (SSOT)

1. Data: `app/src/data/uiLibraries.ts`
- If missing, fallback to `data/uiLibraries.seed.json`.
2. Recommendation logic reference: `app/src/components/RecommendationPanel.tsx`
3. Evaluation logic reference: `app/src/components/EvaluationPanel.tsx`
4. Workflow/template supplements:
- `../references/ui-selector-skill.md`
- `../references/ui-evaluation-flow.md`
- `../references/ui-selector-cheatsheet.md`
- `../references/ui-selector-prompts.md`
- `../references/AI_UI_Skill_Design_Document.md`

## Workflow

1. Clarify inputs
- Minimum required: `framework` + `projectType`.
- Optional: `priority[]`, `teamSize`, `designStyle`, migration context.

2. Run deterministic computation first
- Script execution is mandatory before contextual judgment:

```bash
node skills/ui-selector-pro/scripts/ui_library_engine.mjs recommend \
  --framework react \
  --project-type saas-modern \
  --priority performance \
  --priority accessibility \
  --team-size medium \
  --design-style modern \
  --format json
```

```bash
node skills/ui-selector-pro/scripts/ui_library_engine.mjs evaluate \
  --libraries shadcn-ui,mantine,chakra-ui \
  --format json
```

3. Apply context adjustments
- Adjust with team experience, migration cost, and legacy constraints.
- Explicitly separate deterministic output from context-based adjustment.

4. Produce decision output
- Top 3 recommendations (with reasons and risks)
- Dimension score summary
- Primary + fallback + rejection reasons
- Implementation suggestions (POC scope, phased migration, rollback points)

## Output Contract

Output in this order:

1. Input assumptions and constraints
2. Recommendation results (Top 3)
3. Dimension-evaluation summary
4. Risks and migration suggestions
5. Final decision recommendation

## Rules

- If user input is ambiguous, ask for `framework/projectType` first.
- If user specifies libraries, prioritize `evaluate` + `compare` path.
- Every conclusion must separate:
- deterministic script result
- context-based human judgment
- If docs conflict with `app` data, trust `app/src/data/uiLibraries.ts`.

## Collaboration

- For ADR/review materials/migration roadmap, pair with `$ui-selector-playbook`.
- After selection, handoff to `$ui-codegen-master` for implementation.
