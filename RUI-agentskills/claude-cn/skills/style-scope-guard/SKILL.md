---
name: style-scope-guard
description: 在任何改动前锁定“用户指定的样式范围”，并强制禁止触碰非目标代码区域。
---

# Style Scope Guard

目标：先明确“改哪里的样式”，再允许进入实现；未锁定范围时直接阻断执行。

## SSOT

- `../contracts/fullflow-handoff.md`
- `../contracts/quality-gates.md`
- `../ui-fullflow-orchestrator/SKILL.md`

## 何时使用

- 用户提出“改样式/改 UI/改视觉”类需求时。
- 进入代码修改前，作为强制前置门禁。
- 多人协作场景下，防止误改业务逻辑或非目标模块。

## 核心约束

1. 必须明确样式目标
- 至少明确一个目标区域（如：Header、Hero、侧边栏、按钮系统）。
- 目标不明确时，停止执行并回问用户。

2. 必须锁定可改文件
- 优先由用户明确允许改动文件清单。
- 如未提供，至少给出建议文件列表并标注待确认。

3. 严禁越界改动
- 禁止修改业务逻辑、接口调用、路由与状态结构。
- 禁止修改与目标样式无关模块。

## 可执行脚本

```bash
python3 skills/style-scope-guard/scripts/build_style_scope_lock.py \
  --brief "把登录页顶部导航改成玻璃拟态，其他不动" \
  --target "登录页顶部导航" \
  --allowed-file "src/pages/login.css" \
  --allowed-file "src/components/LoginHeader.tsx" \
  --json-out /tmp/style.scope.lock.json \
  --md-out /tmp/style.scope.checklist.md
```

## 输出产物

- `style.scope.lock.json`：机器可读的改动边界锁
- `style.scope.checklist.md`：人可读的执行清单

## 输出约定

1. scope 是否锁定（locked/unlocked）
2. 目标样式区域与允许文件清单
3. 禁止改动项列表
4. 未确认项与下一步提问

## 协作关系

- `ui-fullflow-orchestrator`：在 Phase 1 之后、实现前强制执行。
- `ui-generation-workflow-runner`：进入 Step 2 前校验 `style.scope.lock.json`。
- `frontend-standards-enforcer`：对提交结果做“越界改动”复核。
