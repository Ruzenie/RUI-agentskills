---
name: ui-codegen-master
description: 端到端 UI 生成与代码优化主技能。整合审美、代码规范、组件抽离、验收、自评和技术栈推荐能力，输出可直接落地的前端实现。
---

# UI Codegen Master

目标：把仓库里分散的 UI 文档规范和 `app/` 的真实实现经验整合为一个可执行工作流。

## 何时使用

- 从零生成页面/模块（Landing/Dashboard/Form 等）。
- 优化现有前端代码（结构、性能、可维护性、类型安全）。
- 做组件抽离、目录重构、设计令牌统一。
- 需要“生成 + 验收 + 自评 + 迭代”闭环。

## 依赖能力

1. 选型能力：`$ui-selector-pro` + `$ui-selector-playbook`
2. 审美能力：`$ui-aesthetic-coach` + `$ui-aesthetic-generator`
3. 生成能力：`$ui-generation-workflow-runner`
4. 重构能力：`$ui-component-extractor`
5. 规范能力：`$frontend-standards-enforcer`
6. 质量能力：`$ui-acceptance-auditor` + `$ui-self-reviewer`
7. 基建能力（新项目时）：`$project-scaffold-builder`
8. 组件库建设（设计系统时）：`$component-library-architect`
9. 工作区基线识别：`$app-workspace-guide`
10. 全流程编排：`$ui-fullflow-orchestrator`
11. 需求完善入口：`$requirements-elicitation-engine`
12. 样式边界守卫：`$style-scope-guard`
13. 图标系统引擎：`$svg-canvas-icon-engine`
14. 结构治理：`$skill-structure-governor`（发布前校验双语/多平台包装结构）

如用户目标包含视觉升级、选型或架构问题，先调用对应子技能，再回到本技能做代码落地与收敛。

## 全流程入口（推荐）

如果用户要求“打通全流程”或“一键跑完整链路”，优先使用：

```bash
bash skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh \
  --brief "<brief>" \
  --framework react \
  --project-type saas-modern \
  --priority performance \
  --priority accessibility \
  --density comfortable
```

该命令会自动生成选型、审美、令牌和总报告，再由本技能承接代码实施与质量收敛。

## 知识来源（按需读取）

- 元规范：`../references/AI_UI_Skill_Design_Document.md`
- 元规范：`../references/AI前端开发技能规范.md`
- 主流程：`../references/ui-codegen-skill.md`
- 生成流程：`../references/ui-generation-workflow.md`
- 抽离规则：`../references/component-extraction-rules.md`
- 代码规范：`../references/frontend-code-standards.md`
- 组件库设计：`../references/component-library-guide.md`
- 脚手架模板：`../references/project-scaffold.md`
- 验收标准：`../references/ui-acceptance-criteria.md`
- 自评机制：`../references/ui-self-evaluation.md`
- 审美规范：`../references/ui-aesthetic-skill.md`
- 全流程契约：`../contracts/fullflow-handoff.md`
- 质量门禁：`../contracts/quality-gates.md`
- 思维可见化：`../contracts/reasoning-visibility.md`

`app/` 参考实现（用于落地和复用判断）：
- `../references/app/src/App.tsx`
- `../references/app/src/components/README.md`
- `../references/app/src/data/uiLibraries.ts`

## 执行工作流

1. 需求解析
- 首次接手 `app` 任务时先调用 `$app-workspace-guide`，读取当前技术栈与组件资产基线。
- 识别页面类型、业务场景、目标用户、品牌调性、技术约束。
- 若技术栈未明确，先调用 `$ui-selector-pro`，评审场景下补充 `$ui-selector-playbook`。
- 若任务属于“样式修改”，必须先调用 `$style-scope-guard` 锁定改动区域和可改文件。
- 若需求涉及图标/可视化图形，先调用 `$svg-canvas-icon-engine` 生成图标基线产物。

2. 设计策略
- 使用 `$ui-aesthetic-coach` 做诊断，使用 `$ui-aesthetic-generator` 固化生成规范。
- 必要时运行确定性脚本：

```bash
python3 skills/ui-aesthetic-coach/scripts/score_ui_brief.py --text "<brief>" --json
python3 skills/ui-aesthetic-coach/scripts/generate_design_tokens.py --direction "Data Clarity" --density comfortable --format both
```

3. 代码生成与组织
- 通过 `$ui-generation-workflow-runner` 执行四步生成法。
- 通过 `$frontend-standards-enforcer` 落实结构、命名、TS、性能规范。
- 优先复用 `app/src/components/ui/` 和已有业务组件模式，避免重复造轮子。

4. 组件抽离与重构
- 通过 `$ui-component-extractor` 执行抽离阈值和重构规则：
- 文件 > 300 行
- 重复 JSX 模式 >= 3
- 嵌套层级 > 5
- 条件分支复杂
- 业务逻辑需提取 Hook

5. 验收与自评
- 通过 `$ui-acceptance-auditor` 进行三级验收（基础合规/质量标准/卓越体验）。
- 通过 `$ui-self-reviewer` 输出问题清单和优化循环建议。

6. 交付输出
- 最少包含：
- 可运行代码
- 关键设计/工程决策
- 验收结果与风险点
- 后续优化清单
- 若使用全流程编排，优先消费 `self-eval.scorecard.json` 与 `optimization.plan.md` 作为迭代入口。

## 输出约定

响应顺序固定：

1. 方案摘要（目标、约束、技术栈）
2. 实现结果（文件级改动）
3. 质量结果（验收 + 自评）
4. 风险与后续动作

## 规则

- 文档与代码冲突时，以当前代码行为为准。
- 避免只给建议不落地；默认直接产出可运行改动。
- 当用户要求“风格独特”时，拒绝模板化安全答案，必须给出明确视觉方向和令牌策略。
- 若 scope lock 未通过，禁止进入代码修改阶段。
