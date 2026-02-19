---
name: vue-adapter
description: Vue 项目适配器，提供模板、composables 与框架特定约束。
---

# Vue Adapter

## 适用场景
- `framework=vue`
- 需要输出 Vue SFC 与 composables 模板

## 输入
- `framework`: `vue`
- `out-dir`: 产物目录

## 输出
- `framework.adapter.manifest.json`
- `framework-adapter/templates/*`
- `framework-adapter/composables/*`

## 目录约定
- `templates/`: `.vue` 模板
- `composables/`: 组合式逻辑模板

## 使用方式
- 由 `skills/framework-adapters/scripts/select_adapter.py` 自动选择并落地
- 该能力由 `ui-fullflow-orchestrator` 在 Phase2 自动调用
