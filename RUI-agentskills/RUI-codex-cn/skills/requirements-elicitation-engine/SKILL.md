---
name: requirements-elicitation-engine
description: 基于结构化反问机制补全模糊需求，生成PRD草案、待确认问题清单和风格档案。
---

# Requirements Elicitation Engine

目标：把“模糊需求”变成“可执行需求输入”，作为全流程的第一步。

## SSOT

- `../references/requirement-elicitation-skill.md`
- `../contracts/quality-gates.md`

## 何时使用

- 用户需求较短或信息缺失。
- 新项目初始化，需要生成 PRD 草案。
- 长周期协作，需要沉淀风格与质量偏好。

## 八维反问覆盖

- 项目基础信息
- 技术栈
- 设计风格
- 功能范围
- 质量与约束
- 响应式与适配
- 内容管理
- 集成与部署

## 可执行脚本

```bash
python3 skills/requirements-elicitation-engine/scripts/generate_requirements_brief.py \
  --brief "做一个SaaS数据看板" \
  --out-dir /tmp/req-artifacts \
  --json
```

输出产物：
- `requirements.prd.md`
- `requirements.questions.md`
- `style-profile.yaml`
- `requirements.summary.json` 中包含 `completeness_score`、`missing_dimensions` 等覆盖信息

## 规则

1. 先补信息再选型：需求清晰度不足时，不直接进入代码实现。
2. 问题优先级：优先补项目目标、技术栈、设计风格、功能范围、质量约束。
3. 输出必须结构化：可直接进入后续 `ui-selector-pro` / `ui-codegen-master`。
4. 建议阈值：`completeness_score < 70` 时，优先补齐 `requirements.questions.md` 再进入实现阶段。
5. 交互负担控制：默认最多输出 5 条反问，避免一次性问题过载。

## 协作关系

- 与 `ui-fullflow-orchestrator` 联用：作为 Phase 1 的标准入口。
- 与 `ui-selector-playbook` 联用：补全评审会前置信息。
