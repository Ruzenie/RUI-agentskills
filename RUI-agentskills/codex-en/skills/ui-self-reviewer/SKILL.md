---
name: ui-self-reviewer
description: Converts ui-self-evaluation.md into a self-review process (code/visual/interaction/aesthetics) and outputs an improvement loop.
---

# UI Self Reviewer

Goal: run structured self-checks before delivery and discover issues proactively instead of waiting for rejection.

## SSOT

- `../../ui-self-evaluation.md`
- `../../AI_UI_Skill_Design_Document.md`
- Frontend development specification document (Chinese source file in repo)
- `../contracts/quality-gates.md`

## Self-Review Steps

1. Code self-review
- Syntax, typing, structure, naming, and potential dead code.

2. Visual self-review
- Consistency of hierarchy, color, typography, and spacing.

3. Interaction self-review
- State completeness, feedback clarity, and motion naturalness.

4. Aesthetic self-review
- Modern quality, detail completion, brand alignment, and differentiation.

## Scoring Mechanism

- Each step outputs score and evidence.
- Use unified weight model:
  - Completeness 30%
  - Aesthetics 25%
  - Maintainability 25%
  - Performance 20%
- Output grade band: excellent/good/pass/needs improvement/fail.

## Refactor Trigger Rules

- Single file > 200 lines
- Render logic > 30 lines
- Same pattern repeated >= 3
- Prop drilling depth > 3

If any rule is triggered, mark as "refactor required" and provide shortest refactor path.

## Output Contract

1. Four-step self-review results
2. Total score and decision
3. Refactor trigger status (yes/no + reason)
4. Mandatory issues (release blockers)
5. Incremental optimization items (can be scheduled)

## Collaboration

- Run before `ui-acceptance-auditor` as internal pre-audit.
- Can pair with `ui-aesthetic-coach` to supplement aesthetic/style findings.
