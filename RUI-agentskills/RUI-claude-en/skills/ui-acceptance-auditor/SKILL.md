---
name: ui-acceptance-auditor
description: Implements ui-acceptance-criteria.md as a three-level acceptance workflow with scoring output, pass/fail decision, and repair list.
---

# UI Acceptance Auditor

Goal: turn subjective "looks fine" into measurable acceptance.

## SSOT

- `../references/ui-acceptance-criteria.md`
- `../references/AI_UI_Skill_Design_Document.md`
- Frontend development specification document (Chinese source file in repo)
- `../contracts/quality-gates.md`

## Three Acceptance Levels

1. Level 0 baseline compliance (Pass/Fail)
- Syntax, typing, responsiveness, basic interaction, and no blocking errors.
- Security baseline (input escaping, sensitive-data exposure check) and mainstream browser compatibility.

2. Level 1 quality standard (0-100)
- Visual hierarchy, color usage, typography quality, spacing discipline, and component quality.

3. Level 2 excellence experience (bonus)
- Micro-interactions, design highlights, responsive details, and enhanced accessibility.

## Execution Flow

1. Run Level 0 first
- Any fail returns blocking issues immediately; do not continue scoring.

2. Run Level 1 next
- Output dimension scores, total score, and lowest-scoring weakness.

3. Evaluate Level 2 last
- Treat as enhancement only; it must not mask baseline issues.

4. Output five-dimension acceptance matrix
- Function / Visual / Code / Performance / Security & Compatibility.

## Recommendation Thresholds

- `>= 85`: release-ready (minor polish recommended)
- `70-84`: usable, but fix key weaknesses before release
- `< 70`: continue iteration before release

## Output Contract

1. Acceptance conclusion (pass / conditional pass / fail)
2. Scoring table by dimension
3. Five-dimension matrix (function/visual/code/performance/security-compatibility)
4. Top 5 issues with fixes (sorted by severity)
5. Re-test guidance (what to verify again)

## Collaboration

- Final quality gate in `ui-codegen-master`.
- Pair with `ui-self-reviewer` to form external acceptance + internal self-review.
