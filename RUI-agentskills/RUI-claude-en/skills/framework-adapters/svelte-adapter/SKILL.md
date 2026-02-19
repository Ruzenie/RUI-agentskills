---
name: svelte-adapter
description: Svelte 项目适配器，提供模板、stores 与框架特定约束。
---

# Svelte Adapter

## 适用场景
- `framework=svelte`
- 需要输出 Svelte 组件与 stores 模板

## 输入
- `framework`: `svelte`
- `out-dir`: 产物目录

## 输出
- `framework.adapter.manifest.json`
- `framework-adapter/templates/*`
- `framework-adapter/stores/*`

## 目录约定
- `templates/`: `.svelte` 模板
- `stores/`: 状态存储模板

## 使用方式
- 由 `skills/framework-adapters/scripts/select_adapter.py` 自动选择并落地
- 该能力由 `ui-fullflow-orchestrator` 在 Phase2 自动调用
