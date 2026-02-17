---
name: ui-fullflow-orchestrator
description: Master orchestration skill for end-to-end UI workflow. Connects selection, aesthetics, token generation, implementation, refactor, acceptance, and self-review into an executable pipeline with unified reports.
---

# UI Fullflow Orchestrator

Goal: upgrade 17 existing skills from "collaborative" to "serially executable".

## SSOT

- `../contracts/fullflow-handoff.md`
- `../contracts/quality-gates.md`
- `../contracts/reasoning-visibility.md`
- `../README.md`
- `../ui-codegen-master/SKILL.md`
- `../style-scope-guard/SKILL.md`
- `../svg-canvas-icon-engine/SKILL.md`
- `../references/AI_UI_Skill_Design_Document.md`
- Frontend development specification document (Chinese source file in repo)

## One-Click Pipeline Script

```bash
bash skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh \
  --brief "SaaS dashboard with data readability and strong primary CTA" \
  --style-target "Dashboard header and core card area" \
  --scope-file "src/pages/dashboard.css" \
  --icon-mode auto \
  --icon-style outline \
  --framework react \
  --project-type saas-modern \
  --priority performance \
  --priority accessibility \
  --density comfortable
```

Default output directory (current workspace): `Ruiagents/<timestamp>/` (override with `--workspace-root` or `--out-dir`)

Artifacts:
- `flow.input.json`
- `requirements.summary.json`
- `requirements.prd.md`
- `requirements.questions.md`
- `style-profile.yaml`
- `style.scope.lock.json`
- `style.scope.checklist.md`
- `icon.manifest.json` (on demand)
- `icon.spec.md` (on demand)
- `icon.sprite.svg` (on demand)
- `selector.recommend.json`
- `selector.evaluate.json`
- `aesthetic.score.json`
- `tokens.json`
- `tokens.css`
- `stage.status.json`
- `quality.gates.md`
- `self-eval.scorecard.json`
- `optimization.plan.md`
- `decision.trace.md` (user-visible decision trace summary)
- `fullflow.report.md`

## Orchestration Flow

Follow the five-phase lifecycle from meta standards:
- Phase 1 requirement analysis and design exploration
- Phase 2 architecture planning and component design
- Phase 3 code generation and implementation
- Phase 4 self-review and refactor
- Phase 5 acceptance and delivery

0. `app-workspace-guide`: read current workspace baseline
1. `requirements-elicitation-engine`: generate requirement draft, question list, style profile
2. `style-scope-guard`: lock style-only change boundary and output scope lock
3. `ui-selector-pro`: generate recommendation shortlist
4. `ui-selector-pro`: run quantified evaluation for shortlist
5. `ui-aesthetic-coach`: score brief aesthetics and suggest direction
6. `ui-aesthetic-coach`: generate design tokens (JSON/CSS)
7. `svg-canvas-icon-engine`: generate icon-system artifacts on demand
8. `ui-generation-workflow-runner`: enter implementation
9. `ui-component-extractor` + `frontend-standards-enforcer`: structure and standards optimization
10. `ui-acceptance-auditor` + `ui-self-reviewer`: quality closure
11. `ui-codegen-master`: final delivery convergence

## Rules

- Pipeline outputs must follow `fullflow-handoff.md`.
- Stage status and quality gates must follow `quality-gates.md`.
- Reasoning visibility must follow `reasoning-visibility.md`: output auditable decision summaries only, not private reasoning details.
- If required inputs are missing (`brief/framework/project-type`), fail immediately with clear prompt.
- If `style_target` is missing or `style.scope.lock.json` is not successfully locked, fail immediately.
- When `icon-mode=auto|on` and icon requirements are detected, `icon.manifest.json` must be generated.
- If `requirements.summary.json` has `completeness_score < 70`, mark requirement-completeness risk in report.
- Must output quantitative scorecard (`self-eval.scorecard.json`) and optimization plan (`optimization.plan.md`) as iteration entry.
- If script output conflicts with document heuristics, keep script output first and explain manual correction rationale in report.

## Output Contract

1. Pipeline execution result (success/failure)
2. Artifact directory and report path
3. Recommended library + recommended direction
4. Stage status summary (five phases)
5. Next skill chain to execute
