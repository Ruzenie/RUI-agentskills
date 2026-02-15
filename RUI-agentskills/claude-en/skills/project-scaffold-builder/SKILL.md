---
name: project-scaffold-builder
description: Converts project-scaffold.md into an implementation workflow for project initialization and configuration, including scaffolding, toolchain, quality gates, and template generation.
---

# Project Scaffold Builder

Goal: quickly build a consistent, maintainable, and releasable frontend project foundation.

## SSOT

- `../../project-scaffold.md`

## Capability Scope

1. Stack initialization
- Framework, styling solution, build tooling, and testing tooling.

2. Configuration setup
- TypeScript, ESLint, Prettier, Tailwind, and Vite.

3. Template structure generation
- Directory tree, core entries, and shared utility layers.

4. Engineering quality gates
- Husky, lint-staged, commit conventions, and CI baseline.

## Execution Flow

1. Read project goals and constraints (team size, release cadence, deployment environment).
2. Generate the minimum viable scaffold.
3. Complete quality tooling and commit workflow.
4. Output initialization checklist.

## Output Contract

1. Initialization summary
2. Created/updated file list
3. Environment and command notes
4. First-phase development recommendations

## Collaboration

- Run this skill first for new projects.
- Then hand over to `ui-codegen-master` for concrete page/module implementation.
