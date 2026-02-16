---
name: ui-agent-workspace
description: 将 UI Agent Workspace 的画布设计、工作区状态与修改日志协议转成可执行协作技能，支撑 Markdown-first UI 研发闭环。
---

# UI Agent Workspace

目标：在编码前后建立 `workspace + canvas + modification log` 的统一协作基线，让 UI 变更可视化、可追溯、可回滚。

## SSOT

- `references/workspace-capability-map.md`
- `references/01-core-concept.md`
- `references/02-workspace-manager.md`
- `references/03-ui-modification-log.md`
- `references/04-canvas-system.md`
- `references/05-markdown-graphics.md`
- `references/06-component-library.md`
- `../contracts/fullflow-handoff.md`
- `../contracts/quality-gates.md`

## 能力范围

1. Workspace 管理
- 标准目录、config/state/index/session 结构、上下文切换。

2. Canvas 设计
- 页面/组件/布局画布结构，ASCII + Mermaid + 规格表混合表达。

3. UI 修改日志协议
- `add/remove/modify/refactor/fix/update` 类型化记录，支持 `batch/rollback/experimental` 场景。

4. Markdown 图形规范
- 组件、布局、状态、标注与前后对比的统一绘制规范。

5. 组件示例模板
- `button/input/card/modal/table` 等模板化骨架与变体定义。

6. 追溯链路
- 建立 `canvas -> code -> logs -> session` 的可追溯关系。

## 何时使用

- 任务涉及 UI 结构设计、样式重构或多轮视觉迭代时。
- 需要把需求、设计图和代码变更形成统一审计轨迹时。
- 团队协作需要可复盘的 UI 资产时。

## 标准输出

1. `canvas/...` 设计稿与规格。
2. `.workspace/config.json`、`.workspace/state.json`、`.workspace/index.json`。
3. `logs/CHANGELOG.md` 结构化 UI 变更记录。
4. `.workspace/sessions/session_xxx.json` 会话轨迹。

## 执行流程

1. 检查并初始化 workspace 目录骨架（如缺失）。
2. 依据需求更新 `canvas/pages` 或 `canvas/components` 设计稿。
3. 将关键规格同步到实现文件，并保持规格-代码一致性。
4. 写入一条标准化 UI 修改日志并绑定修改 ID。
5. 更新 `.workspace/state.json` 与 `index.json` 映射关系。
6. 输出“已变更文件 + 待验证项”给下游技能。

## 协作关系

- `ui-codegen-master`: 在实现前调用，补齐项目级 UI 协作上下文。
- `ui-generation-workflow-runner`: 按画布规格推进实现，并在收尾阶段回写日志与状态。
- `ui-component-extractor`: 组件抽离前读取画布和日志，避免偏离原始设计意图。
- `ui-self-reviewer`: 基于画布 + 日志做交付前一致性复核。
