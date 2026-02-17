---
name: ui-fullflow-orchestrator
description: 打通 UI 全流程的总编排技能。将选型、审美、令牌、生成、重构、验收、自评串成可执行流水线并产出统一报告。
---

# UI Fullflow Orchestrator

目标：把现有 17 个技能从“可协作”升级为“可串行执行”。

## SSOT

- `../contracts/fullflow-handoff.md`
- `../contracts/quality-gates.md`
- `../contracts/reasoning-visibility.md`
- `../README.md`
- `../ui-codegen-master/SKILL.md`
- `../style-scope-guard/SKILL.md`
- `../svg-canvas-icon-engine/SKILL.md`
- `../references/AI_UI_Skill_Design_Document.md`
- `../references/AI前端开发技能规范.md`

## 一键流水线脚本

```bash
bash skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh \
  --brief "SaaS数据看板，强调可读性与主CTA" \
  --style-target "仪表盘头部与核心卡片区域" \
  --scope-file "src/pages/dashboard.css" \
  --icon-mode auto \
  --icon-style outline \
  --framework react \
  --project-type saas-modern \
  --priority performance \
  --priority accessibility \
  --density comfortable
```

默认输出目录：`.fullflow-output/<timestamp>/`

产物：
- `flow.input.json`
- `requirements.summary.json`
- `requirements.prd.md`
- `requirements.questions.md`
- `style-profile.yaml`
- `style.scope.lock.json`
- `style.scope.checklist.md`
- `icon.manifest.json`（按需）
- `icon.spec.md`（按需）
- `icon.sprite.svg`（按需）
- `selector.recommend.json`
- `selector.evaluate.json`
- `aesthetic.score.json`
- `tokens.json`
- `tokens.css`
- `stage.status.json`
- `quality.gates.md`
- `self-eval.scorecard.json`
- `optimization.plan.md`
- `decision.trace.md`（用户可见的决策轨迹摘要）
- `fullflow.report.md`

## 流程编排

按元规范使用五阶段生命周期：
- Phase 1 需求分析与设计探索
- Phase 2 架构规划与组件设计
- Phase 3 代码生成与实现
- Phase 4 自我审查与重构
- Phase 5 验收与交付

0. `app-workspace-guide`：读取当前工作区技术基线
1. `requirements-elicitation-engine`：生成需求草案、反问清单、风格档案
2. `style-scope-guard`：锁定“只改哪部分样式”的边界并输出范围锁
3. `ui-selector-pro`：生成推荐 shortlist
4. `ui-selector-pro`：对 shortlist 做量化评估
5. `ui-aesthetic-coach`：brief 审美评分与方向建议
6. `ui-aesthetic-coach`：生成设计令牌（JSON/CSS）
7. `svg-canvas-icon-engine`：按需生成图标系统产物
8. `ui-generation-workflow-runner`：进入代码实现
9. `ui-component-extractor` + `frontend-standards-enforcer`：结构与规范优化
10. `ui-acceptance-auditor` + `ui-self-reviewer`：质量闭环
11. `ui-codegen-master`：最终交付收敛

## 规则

- 流水线输出必须遵循 `fullflow-handoff.md` 约定。
- 阶段状态和质量门禁必须遵循 `quality-gates.md`。
- 思维过程可见化必须遵循 `reasoning-visibility.md`：只输出可审计决策摘要，不输出私有推理细节。
- 若必填输入缺失（brief/framework/project-type），立即失败并提示。
- 若 `style_target` 未明确，或 `style.scope.lock.json` 未锁定成功，立即失败并提示。
- 当 `icon-mode=auto|on` 且命中图标需求时，必须产出 `icon.manifest.json`。
- `requirements.summary.json` 的 `completeness_score < 70` 时，在报告中标记需求完备度风险。
- 需输出量化评分卡（`self-eval.scorecard.json`）与优化计划（`optimization.plan.md`），作为迭代入口。
- 若脚本结果与文档经验冲突，先保留脚本结果，再在报告中写出人工修正理由。

## 输出约定

1. pipeline 执行结果（成功/失败）
2. 产物目录和报告路径
3. 推荐库 + 推荐方向
4. 阶段状态摘要（五阶段）
5. 下一步应执行的技能链
