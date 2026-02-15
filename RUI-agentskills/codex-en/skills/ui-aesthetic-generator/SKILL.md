---
name: ui-aesthetic-generator
description: Implements the aesthetic standards, style presets, and acceptance checks from ui-aesthetic-skill.md as a generation-oriented skill for page/component visual production.
---

# UI Aesthetic Generator

Goal: directly generate executable visual specifications from aesthetic standards, not just provide critique.

## SSOT

- `../../ui-aesthetic-skill.md`

## Core Capabilities

1. Aesthetic standards application
- Visual hierarchy, color system, typography system, spacing system, radius, and shadows.

2. Style preset selection
- Match style presets to scenarios with rationale and risk notes.

3. Component aesthetic specification
- Standardized visual definitions for base components such as buttons, cards, and inputs.

4. Generation-acceptance loop
- Execute aesthetic checklist and output repair recommendations.

## Execution Flow

1. Input parsing: product type, brand tone, and target audience.
2. Style strategy: define visual direction and token range.
3. Component specification: define visual rules for core components.
4. Quality review: output aesthetic score and optimization items.

## Output Contract

1. Style direction and design rationale
2. Token suggestions (color/typography/spacing/radius/shadow)
3. Key component visual specification
4. Aesthetic risks and repair checklist

## Collaboration

- Different from `ui-aesthetic-coach`:
  - `ui-aesthetic-coach` focuses on diagnosis and improvement
  - this skill focuses on generation and standard implementation
- Works with `ui-generation-workflow-runner` in Step 2 implementation.
