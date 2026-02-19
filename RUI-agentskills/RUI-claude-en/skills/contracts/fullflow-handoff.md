# Fullflow Handoff Contract

Defines the shared context format passed between skills, so each stage does not need to re-infer requirements.

## Input Object (FlowInput)

```json
{
  "brief": "string",
  "style_target": "string",
  "scope_files": ["string"],
  "icon_mode": "auto|on|off",
  "icon_style": "outline|filled|two-tone",
  "framework": "react|vue|angular|svelte|universal|other",
  "project_type": "string",
  "priorities": ["performance", "accessibility", "customization", "ecosystem", "dx", "enterprise"],
  "design_style": "string|null",
  "team_size": "small|medium|large|null",
  "density": "compact|comfortable|spacious",
  "refactor_threshold": "number",
  "render_threshold": "number",
  "duplicate_threshold": "number",
  "props_depth_threshold": "number"
}
```

## Intermediate Artifacts (FlowArtifacts)

1. `selector.recommend.json` from `ui-selector-pro` for shortlist.
2. `selector.evaluate.json` from `ui-selector-pro` for quantified comparison.
3. `requirements.summary.json` from `requirements-elicitation-engine` for completeness summary.
4. `style.scope.lock.json` / `style.scope.checklist.md` from `style-scope-guard` for style boundary lock.
5. `style.scope.validation.json` from `style-scope-guard` for lock-to-change linkage validation.
6. `icon.need.analysis.json` from `svg-canvas-icon-engine` for semantic icon need detection.
7. `icon.manifest.json` / `icon.spec.md` / `icon.sprite.svg` from `svg-canvas-icon-engine` for icon assets (on demand).
8. `requirements.prd.md` / `requirements.questions.md` / `style-profile.yaml` from `requirements-elicitation-engine`.
9. `aesthetic.score.json` from `ui-aesthetic-coach` for visual diagnosis.
10. `tokens.json` / `tokens.css` from `ui-aesthetic-coach` for style baseline.
11. `flow.metrics.json` from `ui-fullflow-orchestrator` for pipeline timing metrics.
12. `plugin.hooks.phase4.before.json` / `plugin.hooks.phase5.after.json` from `ui-fullflow-orchestrator` for plugin hook traces.
13. `stage.status.json` from `ui-fullflow-orchestrator` for lifecycle tracking.
14. `quality.gates.md` from `ui-fullflow-orchestrator` for gate checklist.
15. `phase4.refactor.report.json` / `phase4.refactor.report.md` from `ui-fullflow-orchestrator` (Phase 4) for self-review/refactor results.
16. `phase5.acceptance.report.json` / `phase5.acceptance.report.md` from `ui-fullflow-orchestrator` (Phase 5) for acceptance conclusion, risks, and recommendations.
17. `gate-validation-report.json` from `ui-fullflow-orchestrator` for automated gate validation summary.
18. `flow.state.json` from `ui-fullflow-orchestrator` for workflow state snapshot.
19. `self-eval.scorecard.json` from `ui-fullflow-orchestrator` for quantitative readiness.
20. `optimization.plan.md` from `ui-fullflow-orchestrator` for prioritized improvements.
21. `decision.trace.md` from `ui-fullflow-orchestrator` for user-visible decision summary.
22. `fullflow.report.md` from `ui-fullflow-orchestrator` for delivery summary and next steps.

## Output Object (FlowOutput)

```json
{
  "recommended_library": "string",
  "recommended_direction": "string",
  "icon_enabled": "boolean",
  "artifacts": ["requirements.summary.json", "style.scope.lock.json", "style.scope.checklist.md", "style.scope.validation.json", "icon.need.analysis.json", "icon.manifest.json", "icon.spec.md", "icon.sprite.svg", "requirements.prd.md", "requirements.questions.md", "style-profile.yaml", "selector.recommend.json", "selector.evaluate.json", "aesthetic.score.json", "tokens.json", "tokens.css", "flow.metrics.json", "plugin.hooks.phase4.before.json", "plugin.hooks.phase5.after.json", "stage.status.json", "phase4.refactor.report.json", "phase5.acceptance.report.json", "quality.gates.md", "gate-validation-report.json", "flow.state.json", "self-eval.scorecard.json", "optimization.plan.md", "decision.trace.md", "fullflow.report.md"],
  "next_skills": [
    "ui-codegen-master",
    "ui-selector-playbook",
    "svg-canvas-icon-engine",
    "ui-generation-workflow-runner",
    "ui-acceptance-auditor",
    "ui-self-reviewer",
    "ui-agent-workspace"
  ]
}
```

Notes:
- `next_skills` now means "still-pending items in the must-pass chain", plus optional skills (for example `svg-canvas-icon-engine`).
- `svg-canvas-icon-engine` is optional and appears only when icon requirements are detected.
