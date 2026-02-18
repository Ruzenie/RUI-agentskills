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
  "density": "compact|comfortable|spacious"
}
```

## Intermediate Artifacts (FlowArtifacts)

1. `selector.recommend.json` from `ui-selector-pro` for shortlist.
2. `selector.evaluate.json` from `ui-selector-pro` for quantified comparison.
3. `requirements.summary.json` from `requirements-elicitation-engine` for completeness summary.
4. `style.scope.lock.json` / `style.scope.checklist.md` from `style-scope-guard` for style boundary lock.
5. `icon.manifest.json` / `icon.spec.md` / `icon.sprite.svg` from `svg-canvas-icon-engine` for icon assets (on demand).
6. `requirements.prd.md` / `requirements.questions.md` / `style-profile.yaml` from `requirements-elicitation-engine`.
7. `aesthetic.score.json` from `ui-aesthetic-coach` for visual diagnosis.
8. `tokens.json` / `tokens.css` from `ui-aesthetic-coach` for style baseline.
9. `stage.status.json` from `ui-fullflow-orchestrator` for lifecycle tracking.
10. `quality.gates.md` from `ui-fullflow-orchestrator` for gate checklist.
11. `self-eval.scorecard.json` from `ui-fullflow-orchestrator` for quantitative readiness.
12. `optimization.plan.md` from `ui-fullflow-orchestrator` for prioritized improvements.
13. `decision.trace.md` from `ui-fullflow-orchestrator` for user-visible decision summary.
14. `fullflow.report.md` from `ui-fullflow-orchestrator` for delivery summary and next steps.

## Output Object (FlowOutput)

```json
{
  "recommended_library": "string",
  "recommended_direction": "string",
  "icon_enabled": "boolean",
  "artifacts": ["requirements.summary.json", "style.scope.lock.json", "style.scope.checklist.md", "icon.manifest.json", "icon.spec.md", "icon.sprite.svg", "requirements.prd.md", "requirements.questions.md", "style-profile.yaml", "selector.recommend.json", "selector.evaluate.json", "aesthetic.score.json", "tokens.json", "tokens.css", "stage.status.json", "quality.gates.md", "self-eval.scorecard.json", "optimization.plan.md", "decision.trace.md", "fullflow.report.md"],
  "next_skills": [
    "requirements-elicitation-engine",
    "svg-canvas-icon-engine",
    "ui-generation-workflow-runner",
    "ui-component-extractor",
    "frontend-standards-enforcer",
    "ui-acceptance-auditor",
    "ui-self-reviewer"
  ]
}
```

Notes:
- `requirements-elicitation-engine` enters `next_skills` only when `completeness_score < 70`.
- `svg-canvas-icon-engine` is optional and appears only when icon requirements are detected.
