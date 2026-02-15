# RUI-agentskills

**A production-oriented UI skills system for Codex / Claude.**

<p align="center">
  <a href="./README_CN.md"><img src="https://img.shields.io/badge/简体中文-blue?style=for-the-badge" alt="简体中文"></a>
  <a href="./README.md"><img src="https://img.shields.io/badge/English-blue?style=for-the-badge" alt="English"></a>
</p>

![Bundles](https://img.shields.io/badge/bundles-4-2563eb)
![Skills](https://img.shields.io/badge/skills-18-16a34a)
![Platforms](https://img.shields.io/badge/platform-codex%20%7C%20claude-f59e0b)

## Project Overview

This repository provides a complete packaging and distribution setup for UI engineering skills,
covering requirement clarification, style-scope control, implementation, standards enforcement,
acceptance, and self-review.

The objective is not suggestion-only assistance, but stable progression to **runnable implementation + verifiable delivery**.

Highlights:

1. 4 ready-to-use bundles (Codex / Claude × CN / EN)
2. 18 collaborative skills with fullflow orchestration
3. Style-scope lock to reduce accidental business-logic edits
4. Support for global installation to `~/.codex/skills`

## Why Use This Bundle Set

| Scenario | Typical issue | How this skills set handles it |
|---|---|---|
| Incomplete requirements | Early coding causes rework | Run `requirements-elicitation-engine` before implementation |
| Style-only changes | Accidental business-logic edits | Enforce `style-scope-guard` before coding |
| Multi-skill collaboration | Context breaks and artifact drift | Use `ui-fullflow-orchestrator` with unified contracts |
| Quality closure | Inconsistent standards and weak replayability | Acceptance + self-review + scorecard loop |

## 30-Second Start

1. Choose a bundle: `RUI-agentskills/codex-en` (or `codex-cn` / `claude-*`)
2. Copy `skills/` to your target location (project-local or `~/.codex/skills`)
3. Merge entry file: `AGENTS.md` or `CLAUDE.md`
4. Invoke directly: `$ui-fullflow-orchestrator` / `$ui-codegen-master`

---

## 1. Exported Bundles in This Folder

Four ready-to-use bundles are exported under `RUI-agentskills/`:

1. `RUI-agentskills/codex-cn`
2. `RUI-agentskills/codex-en`
3. `RUI-agentskills/claude-cn`
4. `RUI-agentskills/claude-en`

Manifest:

- `RUI-agentskills/bundle.manifest.json`

## 2. What Each Bundle Contains

Each bundle includes:

1. Platform entry file  
- Codex bundles: `AGENTS.md`  
- Claude bundles: `CLAUDE.md`

2. Skill implementation directory  
- `skills/` (18 skills)

3. Variant/platform/contracts metadata  
- `skills/variants/*`  
- `skills/platforms/*`  
- `skills/contracts/*`

## 3. Which Bundle to Choose

1. Using Codex: choose `codex-cn` or `codex-en`
2. Using Claude: choose `claude-cn` or `claude-en`
3. Chinese workflow: use `*-cn`
4. English-only workflow: use `*-en`

## 4. How To Integrate Into Your Project

1. Merge the target bundle's entry file into your project-level rules file  
- Codex: merge `AGENTS.md`  
- Claude: merge `CLAUDE.md`

2. Copy the bundle's `skills/` directory to your project root

3. Call skills directly in prompt, for example:
- `$ui-codegen-master`
- `$ui-fullflow-orchestrator`
- `$style-scope-guard`

## 4.1 Install Into Global Codex Skills (Recommended)

For cross-project usage, install skills into `~/.codex/skills`:

```bash
mkdir -p ~/.codex/skills
cp -R /home/ruzenie/ai/ruiskills/RUI-agentskills/codex-en/skills/* ~/.codex/skills/
```

Then place the entry rules file into your target project:

```bash
cp /home/ruzenie/ai/ruiskills/RUI-agentskills/codex-en/AGENTS.md <your-project-path>/AGENTS.md
```

For Chinese installation, replace `codex-en` with `codex-cn`.

## 5. Common Skill Commands

1. Fullflow orchestration

```bash
bash skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh \
  --brief "SaaS dashboard with strong readability and CTA" \
  --style-target "dashboard header and core cards" \
  --scope-file "src/pages/dashboard.css" \
  --framework react \
  --project-type saas-modern \
  --priority performance \
  --priority accessibility
```

2. Style-scope lock (recommended before style edits)

```bash
python3 skills/style-scope-guard/scripts/build_style_scope_lock.py \
  --brief "Only update hero section glass style" \
  --target "Hero section" \
  --allowed-file "src/styles/hero.css" \
  --json-out /tmp/style.scope.lock.json \
  --md-out /tmp/style.scope.checklist.md
```

3. Requirements elicitation

```bash
python3 skills/requirements-elicitation-engine/scripts/generate_requirements_brief.py \
  --brief "Build a SaaS analytics dashboard" \
  --out-dir /tmp/req-artifacts \
  --json
```

## 6. Maintain and Re-Export

Re-export all bundles from this repository:

```bash
python3 skills/skill-structure-governor/scripts/export_skill_bundles.py \
  --out-dir RUI-agentskills \
  --clean
```

Validate structure:

```bash
python3 skills/skill-structure-governor/scripts/validate_structure.py
```
