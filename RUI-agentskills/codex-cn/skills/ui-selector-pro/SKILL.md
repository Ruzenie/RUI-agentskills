---
name: ui-selector-pro
description: 系统化完成 UI 组件库选型、评估和对比。优先复用 app 中的真实数据与评分逻辑，输出可落地的技术决策建议与风险说明。
---

# UI Selector Pro

目标：把仓库里的文档方法论 + `app/src/data/uiLibraries.ts` 的真实数据整合成可重复执行的选型能力。

## 何时使用

- 用户需要推荐 UI 组件库 / CSS 框架 / Headless 方案。
- 用户需要多方案量化评估（可访问性、性能、可定制性、DX、生态、企业就绪）。
- 用户需要迁移建议、对比表、POC 评估框架。

## 数据与实现来源（SSOT）

1. 数据：`app/src/data/uiLibraries.ts`
   - 若该文件不存在，自动回退 `data/uiLibraries.seed.json`
2. 推荐逻辑参考：`app/src/components/RecommendationPanel.tsx`
3. 评估逻辑参考：`app/src/components/EvaluationPanel.tsx`
4. 流程与模板补充：
- `../../ui-selector-skill.md`
- `../../ui-evaluation-flow.md`
- `../../ui-selector-cheatsheet.md`
- `../../ui-selector-prompts.md`
- `../../UI-Design-AI-Skill.md`

## 工作流

1. 澄清输入
- 最少需要：`framework` + `projectType`。
- 可选：`priority[]`、`teamSize`、`designStyle`、迁移背景。

2. 先做确定性计算
- 必须优先运行脚本，得到可复现基础结果：

```bash
node skills/ui-selector-pro/scripts/ui_library_engine.mjs recommend \
  --framework react \
  --project-type saas-modern \
  --priority performance \
  --priority accessibility \
  --team-size medium \
  --design-style modern \
  --format json
```

```bash
node skills/ui-selector-pro/scripts/ui_library_engine.mjs evaluate \
  --libraries shadcn-ui,mantine,chakra-ui \
  --format json
```

3. 再做上下文修正
- 结合团队经验、迁移成本、历史代码约束做人工修正。
- 明确“算法结果”和“基于上下文的调整”分别是什么。

4. 生成决策输出
- Top 3 推荐（含理由与风险）
- 维度评分摘要
- 首选 + 备选 + 不选原因
- 实施建议（POC 范围、迁移分批、回滚点）

## 输出约定

按以下顺序输出：

1. 输入假设与约束
2. 推荐结果（Top 3）
3. 维度评估摘要
4. 风险与迁移建议
5. 最终决策建议

## 规则

- 如果用户只给了模糊需求，先追问 `framework/projectType`。
- 如果用户指定库名，优先走 `evaluate` + `compare`。
- 任何结论都要区分：
- 脚本确定性结果
- 结合上下文的人为判断
- 当文档描述和 `app` 数据冲突时，以 `app/src/data/uiLibraries.ts` 为准。

## 协作关系

- 需要 ADR、评审会材料、迁移路线图时，联动 `$ui-selector-playbook`。
- 完成选型后，将结果交给 `$ui-codegen-master` 进入代码落地阶段。
