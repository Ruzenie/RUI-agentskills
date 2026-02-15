---
name: style-scope-guard
description: Locks the user-specified style scope before any change and strictly blocks edits outside the target code area.
---

# Style Scope Guard

Goal: define exactly which style area can be changed before implementation; block execution when scope is not locked.

## SSOT

- `../contracts/fullflow-handoff.md`
- `../contracts/quality-gates.md`
- `../ui-fullflow-orchestrator/SKILL.md`

## When To Use

- When users request style/UI/visual modifications.
- As a mandatory pre-check before code editing.
- In multi-person collaboration to prevent accidental edits to business logic or non-target modules.

## Core Constraints

1. Style target must be explicit
- At least one target area must be defined (for example: Header, Hero, sidebar, button system).
- If target is unclear, stop and ask the user.

2. Editable files must be locked
- Prefer user-provided allowlist of editable files.
- If not provided, suggest candidate files and mark them as pending confirmation.

3. Out-of-scope changes are forbidden
- Do not change business logic, API calls, routing, or state structure.
- Do not modify modules unrelated to the target style scope.

## Executable Script

```bash
python3 skills/style-scope-guard/scripts/build_style_scope_lock.py \
  --brief "Convert the login page top navigation to glassmorphism, keep all else unchanged" \
  --target "Login page top navigation" \
  --allowed-file "src/pages/login.css" \
  --allowed-file "src/components/LoginHeader.tsx" \
  --json-out /tmp/style.scope.lock.json \
  --md-out /tmp/style.scope.checklist.md
```

## Output Artifacts

- `style.scope.lock.json`: machine-readable change-boundary lock
- `style.scope.checklist.md`: human-readable execution checklist

## Output Contract

1. Scope lock status (`locked` / `unlocked`)
2. Target style area and allowed file list
3. Forbidden change list
4. Open items and next-step questions

## Collaboration

- `ui-fullflow-orchestrator`: mandatory execution after Phase 1 and before implementation.
- `ui-generation-workflow-runner`: validate `style.scope.lock.json` before entering Step 2.
- `frontend-standards-enforcer`: re-check out-of-scope edits in submitted changes.
