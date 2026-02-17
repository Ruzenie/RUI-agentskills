---
name: app-workspace-guide
description: 将 app/README.md 与 app/info.md 转为项目运行上下文技能，提供技术栈、组件清单和目录约束基线。
---

# App Workspace Guide

目标：在进入 UI 开发前快速建立当前 `app/` 工作区的真实环境认知。

## SSOT

- `../references/app-workspace-context.md`
- `../references/app-workspace-context.md`

## 能力范围

1. 环境基线识别
- Node、Vite、Tailwind、shadcn 状态。

2. 目录与入口约束
- `src/App.tsx`、`src/index.css`、`src/components/ui/*` 等路径约束。

3. 组件资产盘点
- 已安装组件和可复用能力。

## 输出约定

1. 环境摘要
2. 可复用组件摘要
3. 开发前风险提示

## 协作关系

- `ui-codegen-master` 在首次接手任务时应先读取本 skill，避免与当前 app 基线冲突。
