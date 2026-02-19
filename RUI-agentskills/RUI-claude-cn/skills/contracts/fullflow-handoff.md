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
  "density": "compact|comfortable|spacious",
  "refactor_threshold": "number",
  "render_threshold": "number",
  "duplicate_threshold": "number",
  "props_depth_threshold": "number"
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

5. `style.scope.validation.json`
- 来源：`style-scope-guard`
- 用途：样式范围锁与工作区改动的联动验证结果

6. `icon.need.analysis.json`
- 来源：`svg-canvas-icon-engine`
- 用途：图标需求语义检测结果（confidence/categories/style_preference）

7. `icon.manifest.json` / `icon.spec.md` / `icon.sprite.svg`
- 来源：`svg-canvas-icon-engine`
- 用途：图标系统规范与复用资产（按需生成）

8. `requirements.prd.md` / `requirements.questions.md` / `style-profile.yaml`
- 来源：`requirements-elicitation-engine`
- 用途：需求草案、待确认问题、风格档案

9. `aesthetic.score.json`
- 来源：`ui-aesthetic-coach`
- 用途：审美问题诊断与风格方向

10. `tokens.json` / `tokens.css`
- 来源：`ui-aesthetic-coach`
- 用途：实现阶段样式基线

11. `flow.metrics.json`
- 来源：`ui-fullflow-orchestrator`
- 用途：流水线执行时长与阶段耗时统计

12. `plugin.hooks.phase4.before.json` / `plugin.hooks.phase5.after.json`
- 来源：`ui-fullflow-orchestrator`
- 用途：插件 Hook 执行记录（可插拔技能系统）

13. `stage.status.json`
- 来源：`ui-fullflow-orchestrator`
- 用途：五阶段生命周期状态追踪

14. `quality.gates.md`
- 来源：`ui-fullflow-orchestrator`
- 用途：功能/视觉/代码/性能/安全兼容门禁清单

15. `phase4.refactor.report.json` / `phase4.refactor.report.md`
- 来源：`ui-fullflow-orchestrator` (Phase 4)
- 用途：自我审查/重构检查结果与建议

16. `phase5.acceptance.report.json` / `phase5.acceptance.report.md`
- 来源：`ui-fullflow-orchestrator` (Phase 5)
- 用途：自动化验收结论、风险与建议

17. `gate-validation-report.json`
- 来源：`ui-fullflow-orchestrator`
- 用途：门禁自动校验结果（通过率、失败项、修复建议）

18. `flow.state.json`
- 来源：`ui-fullflow-orchestrator`
- 用途：工作流状态机快照（当前阶段、技能状态、阻塞项、下一步）

19. `self-eval.scorecard.json`
- 来源：`ui-fullflow-orchestrator`
- 用途：量化门槛对齐（需求完备度/审美门槛/就绪状态）

20. `optimization.plan.md`
- 来源：`ui-fullflow-orchestrator`
- 用途：基于门槛失败项生成优先级优化清单

21. `decision.trace.md`
- 来源：`ui-fullflow-orchestrator`
- 用途：用户可见的决策过程摘要（非私有推理）

22. `fullflow.report.md`
- 来源：`ui-fullflow-orchestrator`
- 用途：交付汇总与下一步执行清单

## 输出对象（FlowOutput）

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

说明：
- `next_skills` 现在表示“必过技能链中仍未通过的项”，并可能附加按需技能（如 `svg-canvas-icon-engine`）。
- `svg-canvas-icon-engine` 为按需项，仅在命中图标需求时进入 `next_skills`。
