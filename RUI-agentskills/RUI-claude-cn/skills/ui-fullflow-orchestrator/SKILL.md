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
  --density comfortable \
  --auto-complete \
  --refactor-threshold 200 \
  --render-threshold 30 \
  --duplicate-threshold 3 \
  --props-depth-threshold 3 \
  --acceptance-level strict
```

默认输出目录（当前工作区）：`Ruiagents/<timestamp>/`（可用 `--workspace-root` 或 `--out-dir` 覆盖）

产物：
- `flow.input.json`
- `requirements.summary.json`
- `requirements.prd.md`
- `requirements.questions.md`
- `style-profile.yaml`
- `style.scope.lock.json`
- `style.scope.checklist.md`
- `style.scope.validation.json`
- `icon.manifest.json`（按需）
- `icon.spec.md`（按需）
- `icon.sprite.svg`（按需）
- `icon.need.analysis.json`
- `selector.recommend.json`
- `selector.evaluate.json`
- `aesthetic.score.json`
- `tokens.json`
- `tokens.css`
- `flow.metrics.json`
- `plugin.hooks.phase4.before.json`
- `plugin.hooks.phase5.after.json`
- `stage.status.json`
- `phase4.refactor.report.json`
- `phase4.refactor.report.md`
- `phase5.acceptance.report.json`
- `phase5.acceptance.report.md`
- `quality.gates.md`
- `gate-validation-report.json`
- `flow.state.json`
- `self-eval.scorecard.json`
- `optimization.plan.md`
- `decision.trace.md`（用户可见的决策轨迹摘要）
- `fullflow.report.md`

状态查询：

```bash
bash skills/ui-fullflow-orchestrator/scripts/flow_status.sh --format table
```

## 流程编排

按元规范使用五阶段生命周期：
- Phase 1 需求分析与设计探索
- Phase 2 架构规划与组件设计
- Phase 3 代码生成与实现
- Phase 4 自我审查与重构
- Phase 5 验收与交付

0. `app-workspace-guide`：读取当前工作区技术基线
1. `requirements-elicitation-engine`：生成需求草案、反问清单、风格档案
2. `style-scope-guard`（按需）：当任务涉及样式边界约束时，锁定“只改哪部分样式”的边界并输出范围锁
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
- 全流程必过技能链（固定9项）：
  - `requirements-elicitation-engine`
  - `ui-codegen-master`
  - `ui-selector-playbook`
  - `ui-aesthetic-coach`
  - `ui-aesthetic-generator`
  - `ui-generation-workflow-runner`
  - `ui-acceptance-auditor`
  - `ui-self-reviewer`
  - `ui-agent-workspace`
- 对话可见性（强制）：执行 `$ui` 全流程时，必须在对话中按阶段展示“Phase 名称 -> 使用技能列表 -> 阶段状态/关键产物”，不得只在结尾笼统汇总。
- 别名解析（强制）：当用户输入 `$ui` 时，无论技能列表是否存在 `ui` 同名条目，都必须按 `$ui-fullflow-orchestrator` 处理；禁止回退为“同名技能不存在”逻辑。
- 显式触发锁定（强制）：当用户明确输入 `$ui` 或 `$ui-fullflow-orchestrator` 时，禁止降级或改路由到 `$ui-codegen-master` 或任何单技能流程。
- 缺参例外规则（强制）：显式触发且参数不完整时，只允许追问补全并等待，不允许降级执行。
- 参数补全交互（对话模式）：当用户仅提供 `$ui "<brief>"` 且缺少 `framework` 或 `project-type` 时，必须先追问并等待用户补充，不得直接执行流水线。
- 追问项固定为两项：`目标前端技术栈`、`项目类型标签`。
- 参数校验失败（脚本模式）：仅在直接运行 `run_fullflow_pipeline.sh` 且缺少必填参数时，才立即失败并提示。
- `style-scope-guard` 非强制流程：仅当提供 `style_target` 或 `scope_file` 时，才要求 `style.scope.lock.json` 成功锁定；否则按可选模式继续执行。
- `run_phase4_refactor.sh` 默认执行四类重构检测：文件行数、渲染逻辑行数、重复模式次数、props透传层级（阈值可通过 pipeline 参数覆盖）。
- 统一配置：默认从 `.rui-config.yaml` 读取阈值与验收级别（JSON兼容YAML格式），命令行显式参数优先级更高。
- `run_phase5_acceptance.sh` 现在会自动探测并尝试执行 `lint/typecheck/test/a11y/lighthouse` 脚本（存在则执行，不存在则标记 skipped）。
- 质量门禁校验器：`quality-gate-validator/scripts/validate_gates.py` 会生成/刷新 `gate-validation-report.json`。
- 样式联动校验：`style-scope-guard/scripts/validate_scope_change.py` 输出 `style.scope.validation.json`，可用 `install_precommit_hook.sh` 安装预提交校验。
- 当 `icon-mode=auto|on` 且命中图标需求时，必须产出 `icon.manifest.json`。
- `requirements.summary.json` 的 `completeness_score < 70` 时，在报告中标记需求完备度风险。
- 需输出量化评分卡（`self-eval.scorecard.json`）与优化计划（`optimization.plan.md`），作为迭代入口。
- 若脚本结果与文档经验冲突，先保留脚本结果，再在报告中写出人工修正理由。

### 对话追问模板（缺 framework/project-type）

1. 目标前端技术栈是什么？（如 `react` / `vue` / `angular` / `svelte`）
2. 项目类型标签是什么？（如 `saas-modern` / `dashboard` / `marketing-site` / `admin-console`）

## 输出约定

1. pipeline 执行结果（成功/失败）
2. 产物目录和报告路径
3. 推荐库 + 推荐方向
4. 阶段状态摘要（五阶段）
5. 阶段技能清单（逐阶段列出，格式：`Phase X: skill-a, skill-b`）
6. 必过技能通过状态（固定9项，每项标注 passed/pending）
7. 下一步应执行的技能链
