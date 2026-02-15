---
name: ui-generation-workflow-runner
description: Executes UI generation tasks via a four-step method (structure planning -> component implementation -> code optimization -> quality acceptance), converting ui-generation-workflow.md into an executable process.
---

# UI Generation Workflow Runner

Goal: turn `ui-generation-workflow.md` from static documentation into an executable checklist for stable page-level UI delivery.

## SSOT

- `../../ui-generation-workflow.md`
- `../../ui-codegen-skill.md` (phase-definition supplement)
- Frontend development specification document (lifecycle-constraint supplement, Chinese source file in repo)
- `../contracts/quality-gates.md`

## Applicable Scenarios

- New page development: Landing, Dashboard, Form, and similar.
- Cases requiring strict step-by-step generation instead of one-shot draft output.

## Execution Flow

1. Pre-generation checks
- Clarify page type, target users, core CTA, and key modules.
- If information is missing, ask only the minimal question set (max 3).
- For style tasks, validate `style.scope.lock.json` first; stop when scope is unlocked.

2. Step 1 structure planning
- Produce page block tree and information hierarchy first.
- Define above-the-fold priority and mobile collapse strategy.

3. Step 2 component implementation
- Reuse existing `app/src/components/ui/*` first.
- Keep design tokens consistent: color, typography, spacing, radius, shadow.
- Complete state coverage: default/hover/focus/disabled/loading/error.
- If `icon.sprite.svg` exists, reuse icons from it first.

4. Step 3 code optimization
- Enforce structure/type/performance via `frontend-standards-enforcer`.
- Trigger `ui-component-extractor` when extraction conditions are met.

5. Step 4 quality acceptance
- Run three-level acceptance via `ui-acceptance-auditor`.
- If not passing, run one focused repair loop.

## Output Contract

1. Page structure summary
2. Implementation file list
3. Acceptance result (pass / needs optimization)
4. Next-round optimization priorities (max 3)

## Collaboration

- If visual direction is unclear, call `ui-aesthetic-coach` or `ui-aesthetic-generator` first.
- If component library is undecided, call `ui-selector-pro` or `ui-selector-playbook` first.
