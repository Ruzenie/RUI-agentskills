---
name: project-scaffold-builder
description: 将 project-scaffold.md 变成项目初始化与配置落地流程，负责脚手架、工具链、质量门禁和模板文件生成。
---

# Project Scaffold Builder

目标：快速搭建一致、可维护、可发布的前端项目基座。

## SSOT

- `../references/project-scaffold.md`

## 能力范围

1. 技术栈初始化
- Framework、样式方案、构建工具、测试工具。

2. 配置文件落地
- TypeScript、ESLint、Prettier、Tailwind、Vite。

3. 模板结构生成
- 目录树、核心入口、共享工具层。

4. 工程质量门禁
- Husky、lint-staged、提交规范、CI 基线。

## 执行流程

1. 读取项目目标与约束（团队规模、上线节奏、部署环境）。
2. 生成最小可用脚手架。
3. 补齐质量工具与提交流程。
4. 输出初始化检查清单。

## 输出约定

1. 初始化结果摘要
2. 新建/更新文件清单
3. 环境与命令说明
4. 后续第一阶段开发建议

## 协作关系

- 新项目起步时先执行本 skill。
- 完成后交给 `ui-codegen-master` 承接具体页面开发。
