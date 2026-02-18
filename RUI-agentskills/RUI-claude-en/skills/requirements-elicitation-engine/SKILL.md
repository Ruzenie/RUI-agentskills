---
name: requirements-elicitation-engine
description: Completes ambiguous requirements via structured elicitation and produces a PRD draft, open-question list, and style profile.
---

# Requirements Elicitation Engine

Goal: turn ambiguous requests into executable requirement inputs as the first step of the full pipeline.

## SSOT

- Kimi Agent UI skill spec (Chinese-source directory in repo)
- Kimi Agent UI overview (Chinese-source directory in repo)
- `../contracts/quality-gates.md`

## When To Use

- User requests are short or missing key information.
- New project initialization requires a PRD draft.
- Long-cycle collaboration needs persisted style and quality preferences.

## Eight-Dimension Coverage

- Project baseline information
- Technology stack
- Visual style
- Functional scope
- Quality and constraints
- Responsiveness and adaptation
- Content management
- Integration and deployment

## Executable Script

```bash
python3 skills/requirements-elicitation-engine/scripts/generate_requirements_brief.py \
  --brief "Build a SaaS analytics dashboard" \
  --out-dir /tmp/req-artifacts \
  --json
```

Artifacts:
- `requirements.prd.md`
- `requirements.questions.md`
- `style-profile.yaml`
- `requirements.summary.json` including `completeness_score`, `missing_dimensions`, and other coverage fields

## Rules

1. Clarify before implementation
- If requirement clarity is insufficient, do not jump directly into implementation.

2. Prioritize question ordering
- Prioritize project goals, stack, style, feature scope, and quality constraints.

3. Structured output is mandatory
- Output must directly feed `ui-selector-pro` / `ui-codegen-master`.

4. Threshold suggestion
- If `completeness_score < 70`, complete `requirements.questions.md` first, then proceed.

5. Interaction load control
- Output no more than 5 questions by default to avoid overload.

## Collaboration

- Use with `ui-fullflow-orchestrator` as the standard Phase 1 entry.
- Use with `ui-selector-playbook` to complete review-readiness inputs.
