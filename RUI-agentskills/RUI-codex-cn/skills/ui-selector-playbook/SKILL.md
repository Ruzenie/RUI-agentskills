---
name: ui-selector-playbook
description: 将 UI 选型相关方法文档（流程、速查表、提示词、ADR模板）整合为策略型 skill，支持评审会和决策记录场景。
---

# UI Selector Playbook

目标：提供“可讨论、可审计”的选型流程与文档模板，补足纯算法推荐以外的决策环节。

## SSOT

- `../references/ui-selector-skill.md`
- `../references/ui-evaluation-flow.md`
- `../references/ui-selector-cheatsheet.md`
- `../references/ui-selector-prompts.md`
- `../references/AI_UI_Skill_Design_Document.md`

## 适用场景

- 团队评审会、技术委员会、架构评审。
- 需要 ADR、迁移评估、POC 计划、风险登记。

## 执行流程

1. 需求澄清
- 框架、项目类型、约束、优先级、时间线。

2. 候选筛选
- 用速查表快速缩小到 3-5 个候选。

3. 深度评估
- 按 6 维度评分并形成评估矩阵。

4. POC 与决策
- 输出 POC 范围、验收门槛和 ADR 草案。

## 技术栈快速矩阵（默认建议）

- React: `shadcn/ui`（首选），备选 `Chakra UI` / `Mantine`
- Vue 3: `Element Plus`（首选），备选 `Naive UI` / `Vuetify`
- Next.js: `Radix UI + Tailwind CSS` 或 `shadcn/ui`
- Svelte: `Bits UI` / `Skeleton`
- Vanilla HTML/CSS: `DaisyUI`，备选 `Bootstrap 5` / `Bulma`

## 输出约定

1. 候选短名单与淘汰理由
2. 评估矩阵（维度+权重+得分）
3. 决策建议（首选/备选）
4. ADR 模板化结论与迁移路线

## 协作关系

- 和 `ui-selector-pro` 联用：
  - `ui-selector-pro` 负责确定性计算
  - 本 skill 负责会议化决策与文档化沉淀
