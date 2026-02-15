# Skills Integration Map

**一套可直接挂载到 Codex / Claude 的 UI 研发技能系统。**

![Skills](https://img.shields.io/badge/skills-18-2563eb)
![Pipeline](https://img.shields.io/badge/fullflow-5_phase-16a34a)
![Focus](https://img.shields.io/badge/focus-implementation%20%26%20verification-f59e0b)

## 为什么用这套 Skills

很多技能集合能“给建议”，但难以稳定推进到可交付代码。  
这套 Skills 把需求澄清、样式边界、实现、验收、自评串成统一链路。

| 场景 | 常见问题 | 这套 Skills 的处理方式 |
|---|---|---|
| 需求不完整 | 直接开写导致返工 | 先执行 `requirements-elicitation-engine` 补齐输入 |
| 样式改动 | 容易误改业务逻辑 | `style-scope-guard` 先锁定改动范围 |
| 多技能协作 | 前后文断裂、产物不一致 | `ui-fullflow-orchestrator` 统一编排与产物约定 |
| 质量验收 | 标准不一致、难复盘 | 验收 + 自评 + 量化评分卡闭环 |

## 30 秒上手

1. 一键全流程：`ui-fullflow-orchestrator`
2. 样式任务先锁边界：`style-scope-guard`
3. 最终收敛交付：`ui-codegen-master`

---

## 技能地图

## 核心编排层

1. `ui-codegen-master`
- 端到端总控：选型、风格、生成、重构、验收、自评。

2. `ui-fullflow-orchestrator`
- 全流程自动编排与产物聚合（含可执行 pipeline 脚本）。
- 入口脚本：`skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh`

3. `requirements-elicitation-engine`
- 需求反问、PRD草案、风格档案生成。
- 脚本：`skills/requirements-elicitation-engine/scripts/generate_requirements_brief.py`

## 选型决策层

4. `ui-selector-pro`
- 确定性计算引擎（推荐/评估/对比）。
- 脚本：`skills/ui-selector-pro/scripts/ui_library_engine.mjs`。

5. `ui-selector-playbook`
- 评审会流程、ADR、迁移与 POC 策略化输出。

## 审美策略层

6. `ui-aesthetic-coach`
- 诊断与方向建议。
- 脚本：`score_ui_brief.py` / `generate_design_tokens.py`。

7. `ui-aesthetic-generator`
- 生成导向审美规范（令牌+组件视觉规范）。

## 研发执行层

8. `ui-generation-workflow-runner`
- 执行四步生成法。

9. `style-scope-guard`
- 样式改动边界锁定，未明确目标区域时阻断执行。
- 脚本：`skills/style-scope-guard/scripts/build_style_scope_lock.py`

10. `svg-canvas-icon-engine`
- SVG/Canvas 图标系统生成，产出 icon manifest/spec/sprite。
- 脚本：`skills/svg-canvas-icon-engine/scripts/generate_icon_assets.py`

11. `ui-component-extractor`
- 组件抽离与重构规则执行。

12. `frontend-standards-enforcer`
- 代码规范与工程约束检查。

13. `ui-acceptance-auditor`
- 三级验收打分与发布建议。

14. `ui-self-reviewer`
- 代码/视觉/交互/审美四段自审。

## 架构与基建层

15. `project-scaffold-builder`
- 项目脚手架、工具链与门禁初始化。

16. `component-library-architect`
- 组件库架构、令牌系统、发布流程。

17. `app-workspace-guide`
- `app/` 工作区环境与组件资产基线识别。

## 结构治理层

18. `skill-structure-governor`
- 双语入口与多平台包装模板治理（结构校验，不迁移业务功能）。
- 脚本：`skills/skill-structure-governor/scripts/validate_structure.py`

## 文档到技能映射

- `ui-codegen-skill.md` -> `ui-codegen-master`
- `Kimi_Agent_UI组件库AI技能/requirement-elicitation-skill.md` -> `requirements-elicitation-engine`
- `ui-generation-workflow.md` -> `ui-generation-workflow-runner`
- `component-extraction-rules.md` -> `ui-component-extractor`
- `frontend-code-standards.md` -> `frontend-standards-enforcer`
- `ui-acceptance-criteria.md` -> `ui-acceptance-auditor`
- `ui-self-evaluation.md` -> `ui-self-reviewer`
- `project-scaffold.md` -> `project-scaffold-builder`
- `component-library-guide.md` -> `component-library-architect`
- `ui-selector-skill.md` -> `ui-selector-pro`
- `ui-evaluation-flow.md` -> `ui-selector-playbook`
- `ui-selector-cheatsheet.md` -> `ui-selector-playbook`
- `ui-selector-prompts.md` -> `ui-selector-playbook`
- `UI-Design-AI-Skill.md` -> `ui-selector-playbook`
- `ui-aesthetic-skill.md` -> `ui-aesthetic-generator`
- `svg-canvas-icon-skill.md` -> `svg-canvas-icon-engine`
- `svg-canvas-cheatsheet.md` -> `svg-canvas-icon-engine`
- `icon-library.html` -> `svg-canvas-icon-engine`
- `app/README.md` -> `app-workspace-guide`
- `app/info.md` -> `app-workspace-guide`
- `AI_UI_Skill_Design_Document.md` -> `ui-fullflow-orchestrator` / `ui-acceptance-auditor` / `ui-self-reviewer` / `ui-codegen-master`
- `AI前端开发技能规范.md` -> `ui-fullflow-orchestrator` / `frontend-standards-enforcer` / `ui-self-reviewer` / `ui-codegen-master`
- `mimoskills.md` -> `ui-fullflow-orchestrator` / `requirements-elicitation-engine` / `ui-codegen-master`
- `skills/contracts/fullflow-handoff.md` -> `ui-fullflow-orchestrator`
- `skills/contracts/quality-gates.md` -> `ui-fullflow-orchestrator` / `ui-acceptance-auditor` / `ui-self-reviewer`
- `skills/contracts/reasoning-visibility.md` -> `ui-fullflow-orchestrator` / `ui-codegen-master`
- 用户新增约束“仅改指定样式区域” -> `style-scope-guard`

## 推荐协作顺序

1. 一键编排：`ui-fullflow-orchestrator`
2. 需求完善：`requirements-elicitation-engine`
3. 样式边界锁定：`style-scope-guard`
4. 选型：`ui-selector-pro` + `ui-selector-playbook`
5. 风格：`ui-aesthetic-coach` + `ui-aesthetic-generator`
6. 图标系统（按需）：`svg-canvas-icon-engine`
7. 环境基线：`app-workspace-guide`
8. 生成：`ui-generation-workflow-runner`
9. 重构与规范：`ui-component-extractor` + `frontend-standards-enforcer`
10. 质量闭环：`ui-acceptance-auditor` + `ui-self-reviewer`
11. 总控收敛：`ui-codegen-master`

发布与分发前可追加结构校验：`skill-structure-governor`

一键导出四套分发包：
```bash
python3 skills/skill-structure-governor/scripts/export_skill_bundles.py
```

新项目场景可在第 0 步先执行 `project-scaffold-builder`；设计系统场景可并行引入 `component-library-architect`。

## 一键全流程命令

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

默认会额外生成：
- `stage.status.json`（五阶段状态）
- `quality.gates.md`（门禁检查清单）
- `self-eval.scorecard.json`（量化门槛评分卡）
- `optimization.plan.md`（迭代优化优先级清单）
- `decision.trace.md`（用户可见的决策过程摘要）
- `style.scope.lock.json`（样式改动范围锁）
- `icon.manifest.json`（按需生成的图标清单）

说明：
- `decision.trace.md` 遵循 `skills/contracts/reasoning-visibility.md`，只展示可审计决策摘要，不暴露私有推理细节。

## 双语与平台结构（新增）

- 双语入口：
  - `skills/variants/CN/SKILLS.md`
  - `skills/variants/EN/SKILLS.md`
- 双语清单（字段级对齐）：
  - `skills/variants/skills.bilingual.json`
  - 生成命令：`python3 skills/skill-structure-governor/scripts/render_bilingual_index.py`
- 平台包装模板：
  - `skills/platforms/codex/AGENTS.template.md`
  - `skills/platforms/codex/AGENTS.template.en.md`
  - `skills/platforms/claude/CLAUDE.template.md`
  - `skills/platforms/claude/CLAUDE.template.en.md`
- 结构对比与说明：
  - `skills/structure/skills-structure-notes.md`
