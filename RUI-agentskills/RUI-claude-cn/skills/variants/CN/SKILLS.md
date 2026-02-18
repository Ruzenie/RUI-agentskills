# Skills 索引（中文）

本文件由双语清单自动生成。

## 核心编排层

1. `ui-fullflow-orchestrator`
- 全流程编排：串联需求、选型、审美、实现、验收与自评，输出统一流水线产物。
2. `requirements-elicitation-engine`
- 需求反问引擎：通过结构化追问补全模糊需求，生成 PRD、问题清单与风格档案。
3. `ui-codegen-master`
- UI 总控：整合选型、审美、生成、重构、验收与自评，收敛端到端交付。

## 选型决策层

4. `ui-selector-pro`
- 组件库选型引擎：执行 UI 组件库推荐、评估与对比，给出可落地决策。
5. `ui-selector-playbook`
- 选型策略手册：沉淀选型流程、ADR 和评审策略，支持团队化决策。

## 审美策略层

6. `ui-aesthetic-coach`
- 审美教练：提供视觉诊断、风格方向和设计令牌建议。
7. `ui-aesthetic-generator`
- 审美规范生成器：将审美规范转化为可执行的生成约束与视觉规则。

## 研发执行层

8. `ui-generation-workflow-runner`
- 生成流程执行器：按结构规划→组件实现→优化→验收四步法推进实现。
9. `style-scope-guard`
- 样式边界守卫：先锁定用户指定样式范围，再允许修改，越界即阻断。
10. `svg-canvas-icon-engine`
- 图标系统引擎：生成图标清单、规范与可复用 SVG/Canvas 资源。
11. `ui-component-extractor`
- 组件抽离器：识别拆分时机并执行组件抽离与回归验证。
12. `frontend-standards-enforcer`
- 前端规范门禁：检查结构、命名、类型、性能和一致性，给出修复路径。
13. `ui-acceptance-auditor`
- 验收审计器：按多维标准执行验收并输出发布建议。
14. `ui-self-reviewer`
- 自评审查器：从代码、视觉、交互、审美四个维度执行交付前自评。

## 架构与基建层

15. `project-scaffold-builder`
- 脚手架构建器：完成项目初始化、工具链配置与质量门禁落地。
16. `component-library-architect`
- 组件库架构师：设计组件库层次、令牌系统、变体策略与发布流程。
17. `app-workspace-guide`
- 工作区基线识别：识别 app 工作区技术基线、组件资产和目录约束。
18. `ui-agent-workspace`
- UI 工作空间协作：将 Workspace、Canvas 与 UI 修改日志协议整合为可执行协作流程，保障设计到代码的可追溯交付。

## 结构治理层

19. `skill-structure-governor`
- 技能结构治理：校验双语入口与多平台包装结构完整性，保障分发一致性。

校验命令：`python3 skills/skill-structure-governor/scripts/validate_structure.py`
分发命令：`python3 skills/skill-structure-governor/scripts/export_skill_bundles.py`
