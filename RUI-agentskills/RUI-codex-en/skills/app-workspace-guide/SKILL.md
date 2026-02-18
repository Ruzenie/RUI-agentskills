---
name: app-workspace-guide
description: Converts app/README.md and app/info.md into an executable workspace-context skill, including stack baseline, component inventory, and directory constraints.
---

# App Workspace Guide

Goal: build an accurate understanding of the current `app/` workspace before UI development starts.

## SSOT

- `../references/app-workspace-context.md`
- `../references/app-workspace-context.md`

## Capability Scope

1. Environment baseline detection
- Detect Node, Vite, Tailwind, and shadcn status.

2. Directory and entry constraints
- Enforce path constraints such as `src/App.tsx`, `src/index.css`, and `src/components/ui/*`.

3. Component asset inventory
- Identify installed components and reusable capabilities.

## Output Contract

1. Environment summary
2. Reusable component summary
3. Pre-development risk notes

## Collaboration

- `ui-codegen-master` should read this skill first when taking over a new task, to avoid conflicts with the current app baseline.
