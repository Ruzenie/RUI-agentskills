# Fullflow Handoff Contract

用于在各技能间传递一致上下文，避免“每一步重新猜测需求”。

## 输入对象（FlowInput）

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

## 中间产物（FlowArtifacts）

1. `selector.recommend.json`
- 来源：`ui-selector-pro`
- 用途：候选库 shortlist

2. `selector.evaluate.json`
- 来源：`ui-selector-pro`
- 用途：量化评分对比

3. `requirements.summary.json`
- 来源：`requirements-elicitation-engine`
- 用途：需求完整度与反问结果摘要

4. `style.scope.lock.json` / `style.scope.checklist.md`
- 来源：`style-scope-guard`
- 用途：锁定样式改动目标与可改文件边界

5. `icon.manifest.json` / `icon.spec.md` / `icon.sprite.svg`
- 来源：`svg-canvas-icon-engine`
- 用途：图标系统规范与复用资产（按需生成）

6. `requirements.prd.md` / `requirements.questions.md` / `style-profile.yaml`
- 来源：`requirements-elicitation-engine`
- 用途：需求草案、待确认问题、风格档案

7. `aesthetic.score.json`
- 来源：`ui-aesthetic-coach`
- 用途：审美问题诊断与风格方向

8. `tokens.json` / `tokens.css`
- 来源：`ui-aesthetic-coach`
- 用途：实现阶段样式基线

9. `stage.status.json`
- 来源：`ui-fullflow-orchestrator`
- 用途：五阶段生命周期状态追踪

10. `quality.gates.md`
- 来源：`ui-fullflow-orchestrator`
- 用途：功能/视觉/代码/性能/安全兼容门禁清单

11. `self-eval.scorecard.json`
- 来源：`ui-fullflow-orchestrator`
- 用途：量化门槛对齐（需求完备度/审美门槛/就绪状态）

12. `optimization.plan.md`
- 来源：`ui-fullflow-orchestrator`
- 用途：基于门槛失败项生成优先级优化清单

13. `decision.trace.md`
- 来源：`ui-fullflow-orchestrator`
- 用途：用户可见的决策过程摘要（非私有推理）

14. `fullflow.report.md`
- 来源：`ui-fullflow-orchestrator`
- 用途：交付汇总与下一步执行清单

## 输出对象（FlowOutput）

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

说明：
- `requirements-elicitation-engine` 仅在 `completeness_score < 70` 时进入 `next_skills`。
- `svg-canvas-icon-engine` 为按需项，仅在命中图标需求时进入 `next_skills`。
