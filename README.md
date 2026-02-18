<div align="center">

# 🎨 RUI Agent Skills

**Production-Ready UI Engineering Skills for AI Agents**


<p>
  <a href="https://github.com/yourusername/RUI-agentskills"><img src="https://img.shields.io/badge/Release-v1.0.0-2563eb?style=flat-square&logo=github" alt="Release"></a>
  <a href="./README_CN.md"><img src="https://img.shields.io/badge/中文文档-Available-16a34a?style=flat-square" alt="中文文档"></a>
  <a href="./LICENSE"><img src="https://img.shields.io/badge/License-MIT-f59e0b?style=flat-square" alt="License"></a>
</p>

<p>
  <img src="https://img.shields.io/badge/Bundles-4-2563eb?style=for-the-badge&logo=package" alt="Bundles">
  <img src="https://img.shields.io/badge/Skills-19-16a34a?style=for-the-badge&logo=stackblitz" alt="Skills">
  <img src="https://img.shields.io/badge/Platforms-Codex%20%7C%20Claude-f59e0b?style=for-the-badge&logo=openai" alt="Platforms">
</p>

<p><strong>🌍 <a href="./README_CN.md">简体中文</a> | English</strong></p>

</div>

---

## 📋 Table of Contents

- [✨ Features](#-features)
- [🚀 Quick Start](#-quick-start)
- [🧭 Command Reference](#-command-reference)
- [📦 Available Bundles](#-available-bundles)
- [🔧 Skill Catalog](#-skill-catalog)
- [💡 Usage Examples](#-usage-examples)
- [📁 Project Structure](#-project-structure)
- [🔌 Integration Guide](#-integration-guide)
- [🛠️ Maintenance](#️-maintenance)

---

## ✨ Features

<div align="center">

| Feature | Description |
|---------|-------------|
| 🎯 **Zero-Config Setup** | 4 ready-to-use bundles for immediate deployment |
| 🔗 **Full-Flow Orchestration** | 19 collaborative skills working in seamless pipeline |
| 🔒 **Style Scope Guard** | Prevent accidental business logic changes during UI edits |
| 🌐 **Bilingual Support** | Native Chinese and English workflows |
| 📊 **Quality Gates** | Built-in acceptance criteria and self-review mechanisms |
| 🎨 **Design Token System** | Standardized aesthetic guidelines and component architecture |

</div>

### Why RUI Agent Skills?

<table>
<tr>
<th width="25%">Scenario</th>
<th width="35%">Without RUI</th>
<th width="40%">With RUI Skills</th>
</tr>
<tr>
<td>📋 Vague Requirements</td>
<td>Start coding → Rework → Missed deadlines</td>
<td><code>requirements-elicitation-engine</code> → Clear PRD → Right first time</td>
</tr>
<tr>
<td>🎨 Style Changes</td>
<td>Edit CSS → Break logic → Debug hours</td>
<td><code>style-scope-guard</code> → Locked boundaries → Safe changes</td>
</tr>
<tr>
<td>🔄 Multi-Skill Tasks</td>
<td>Context lost → Inconsistent artifacts</td>
<td><code>ui-fullflow-orchestrator</code> → Unified pipeline → Consistent output</td>
</tr>
<tr>
<td>✅ Quality Check</td>
<td>Subjective review → Missed issues</td>
<td><code>ui-acceptance-auditor</code> → Scorecard → Measurable quality</td>
</tr>
</table>

---

## 🚀 Quick Start

### Option 1: Project-Local Installation (Recommended)

```bash
# 1. Choose your bundle
cd RUI-agentskills/codex-en   # or codex-cn / claude-en / claude-cn

# 2. Copy skills to your project
cp -R skills/ /path/to/your/project/

# 3. Merge entry file into your project's rules
cat AGENTS.md >> /path/to/your/project/AGENTS.md  # For Codex
# OR
cat CLAUDE.md >> /path/to/your/project/CLAUDE.md   # For Claude
```

### Option 2: Global Installation (Skills Only)

```bash
# Install to Codex global skills
mkdir -p ~/.codex/skills
cp -R RUI-agentskills/codex-en/skills/* ~/.codex/skills/

# Then copy entry file to each project
cp RUI-agentskills/codex-en/AGENTS.md /path/to/your/project/AGENTS.md
```

After installation, follow the steps below to start in chat with `$ui`.

### After Installation: Start with `$ui` in chat (Recommended)

`$ui` is an alias of `$ui-fullflow-orchestrator`, which triggers the full UI workflow (requirements → design → implementation → acceptance).

```text
1) Complete Option 1 or Option 2 first (skills loaded + AGENTS.md/CLAUDE.md merged).
2) In your project chat, run:
   $ui Build a SaaS analytics dashboard with responsive layout and chart modules
3) If only a brief is provided, the system will first ask two follow-up fields: `target frontend framework` and `project-type label`.
4) For explicit invocation, use:
   $ui-fullflow-orchestrator Build a SaaS analytics dashboard with responsive layout and chart modules
```

---

## 🧭 Command Reference

### Chat Commands

| Category | Command | Purpose |
|---|---|---|
| Fullflow alias | `$ui` | Alias of `$ui-fullflow-orchestrator`, starts end-to-end UI flow |
| Fullflow explicit | `$ui-fullflow-orchestrator` | Explicitly invoke the fullflow orchestrator |
| Skill targeting | `$<skill-name>` | Invoke any specific skill directly (full list below) |
| Full-authorization mode | `~auto` / `~helloauto` / `~fa` | Run continuously: analysis → design → implementation |
| Planning mode | `~plan` / `~design` | Run continuously: analysis → design |
| Execution mode | `~exec` / `~run` / `~execute` | Execute an existing plan package under `plan/` |
| Knowledge base mode | `~init` / `~wiki` | Initialize or rebuild the knowledge base |


Skill command purpose map:

| Command | Purpose |
|---|---|
| `$ui-fullflow-orchestrator` | End-to-end orchestrator that chains selection, aesthetics, generation, acceptance, and self-review. |
| `$requirements-elicitation-engine` | Requirement clarification with structured Q&A and PRD draft output. |
| `$ui-codegen-master` | Unified controller for UI code generation and delivery convergence. |
| `$ui-selector-pro` | UI library evaluation and recommendation engine. |
| `$ui-selector-playbook` | Selection workflow, review checklist, and ADR decision templates. |
| `$ui-aesthetic-coach` | Aesthetic diagnosis and visual improvement guidance. |
| `$ui-aesthetic-generator` | Converts aesthetic standards into executable tokens and generation constraints. |
| `$ui-generation-workflow-runner` | Runs UI generation in a structured four-step workflow. |
| `$style-scope-guard` | Locks style-edit boundaries to prevent out-of-scope changes. |
| `$svg-canvas-icon-engine` | Generates SVG/Canvas icon assets and manifests. |
| `$ui-component-extractor` | Detects and executes component extraction/refactoring opportunities. |
| `$frontend-standards-enforcer` | Enforces frontend code standards, structure, and performance constraints. |
| `$ui-acceptance-auditor` | Performs three-level acceptance auditing and pass/fail recommendation. |
| `$ui-self-reviewer` | Four-domain self-review: code, visual, interaction, and aesthetics. |
| `$project-scaffold-builder` | Initializes project scaffolding and engineering baseline configuration. |
| `$component-library-architect` | Designs component-library architecture, token system, and variants strategy. |
| `$app-workspace-guide` | Extracts runtime context and asset baseline from `app/` workspace docs. |
| `$ui-agent-workspace` | Manages UI collaboration workspace state, canvas, and modification logs. |
| `$skill-structure-governor` | Governs skill structure consistency across language and platform bundles. |

### Script Commands

```bash
# Fullflow pipeline
bash skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh --brief "SaaS analytics dashboard" --framework react --project-type saas-modern

# Style scope lock
python3 skills/style-scope-guard/scripts/build_style_scope_lock.py --brief "Update hero" --target "Hero"

# Requirements elicitation
python3 skills/requirements-elicitation-engine/scripts/generate_requirements_brief.py --brief "Build a product landing page" --out-dir ./requirements --json

# Design token generation
python3 skills/ui-aesthetic-coach/scripts/generate_design_tokens.py --direction "Data Clarity" --density comfortable --format both

# Bundle export
python3 skills/skill-structure-governor/scripts/export_skill_bundles.py --out-dir RUI-agentskills --clean

# Structure validation
python3 skills/skill-structure-governor/scripts/validate_structure.py

# Bilingual index generation
python3 skills/skill-structure-governor/scripts/render_bilingual_index.py
```

---

## 📦 Available Bundles

<div align="center">

| Bundle | Platform | Language | Best For |
|--------|----------|----------|----------|
| `codex-en` | OpenAI Codex |  English | Codex users, English workflows |
| `codex-cn` | OpenAI Codex |  Chinese | Codex users, Chinese workflows |
| `claude-en` | Anthropic Claude | English | Claude users, English workflows |
| `claude-cn` | Anthropic Claude |  Chinese | Claude users, Chinese workflows |

</div>

### Bundle Contents

Each bundle includes:

```
📦 {bundle}/
├── 📄 AGENTS.md / CLAUDE.md     # Platform entry point
├── 📂 skills/
│   ├── 🔧 19 Skill implementations
│   ├── 📋 contracts/            # Inter-skill agreements
│   ├── 🎨 references/           # Design systems & standards
│   ├── 🌍 variants/EN|CN/       # Language indexes
│   └── 📜 platforms/            # Platform-specific templates
└── 📊 manifest.json             # Bundle metadata
```

---

## 🔧 Skill Catalog

### 🎯 Core Orchestration Layer

| Skill | Description | Key Capability |
|-------|-------------|----------------|
| **`ui-fullflow-orchestrator`** | Master orchestrator for the complete UI pipeline | End-to-end workflow from requirements to delivery |
| **`requirements-elicitation-engine`** | Structured requirement clarification | Converts vague ideas into actionable PRDs |
| **`ui-codegen-master`** | Unified implementation controller | Consolidates selection, design, generation, and quality |

### 🎨 Aesthetic & Design Layer

| Skill | Description | Key Capability |
|-------|-------------|----------------|
| **`ui-aesthetic-coach`** | Visual design advisor | Critique, direction, and token generation |
| **`ui-aesthetic-generator`** | Design system generator | Converts standards into implementation constraints |
| **`svg-canvas-icon-engine`** | Icon system builder | Generates manifests, specs, and reusable assets |

### 🔨 Implementation Layer

| Skill | Description | Key Capability |
|-------|-------------|----------------|
| **`ui-generation-workflow-runner`** | Code generation executor | Four-step implementation workflow |
| **`style-scope-guard`** | Change boundary protector | Prevents out-of-scope modifications |
| **`ui-component-extractor`** | Component architect | Automated extraction and refactoring |
| **`frontend-standards-enforcer`** | Quality gatekeeper | Structure, types, performance enforcement |

### ✅ Quality Assurance Layer

| Skill | Description | Key Capability |
|-------|-------------|----------------|
| **`ui-acceptance-auditor`** | Multi-dimension reviewer | Acceptance criteria verification |
| **`ui-self-reviewer`** | Pre-delivery checker | Code, visual, interaction, aesthetic review |

### 🏗️ Architecture & Foundation Layer

| Skill | Description | Key Capability |
|-------|-------------|----------------|
| **`project-scaffold-builder`** | Project initializer | Scaffolding, tooling, quality gates |
| **`component-library-architect`** | Design system creator | Token systems, component architecture |
| **`app-workspace-guide`** | Workspace analyzer | Baseline detection, asset inventory |
| **`ui-agent-workspace`** | Collaborative environment | Workspace state, canvas, change logging |

### 📚 Decision Support Layer

| Skill | Description | Key Capability |
|-------|-------------|----------------|
| **`ui-selector-pro`** | Library recommender | Deterministic UI library selection |
| **`ui-selector-playbook`** | Selection guide | ADR patterns, review strategies |

### 🔧 Governance Layer

| Skill | Description | Key Capability |
|-------|-------------|----------------|
| **`skill-structure-governor`** | Structure validator | Bilingual/multi-platform consistency |

---

## 💡 Usage Examples

### 🎬 Full-Flow Pipeline

The examples below run directly via the fullflow pipeline script.

**Full Command (Advanced):**
```bash
bash skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh \
  --brief "SaaS analytics dashboard" \
  --style-target "dashboard header, metric cards, charts" \
  --framework react \
  --project-type saas-modern \
  --priority performance \
  --priority accessibility \
  --density comfortable
```

**Output:**
- `flow.input.json` - Pipeline configuration
- `requirements.summary.json` - Clarified requirements
- `style-profile.yaml` - Design tokens
- `selector.recommend.json` - Library recommendations
- `tokens.json/css` - Implementation-ready tokens
- `fullflow.report.md` - Complete execution report

### 🔒 Style Scope Lock

Lock modification boundaries before making style changes:

```bash
python3 skills/style-scope-guard/scripts/build_style_scope_lock.py \
  --brief "Update hero section with glassmorphism effect" \
  --target "Hero section only" \
  --allowed-file "src/styles/hero.css" \
  --allowed-file "src/components/Hero.tsx" \
  --json-out ./style.scope.lock.json \
  --md-out ./style.scope.checklist.md
```

**Prevents:** Accidental changes to business logic, API calls, routing

### 📋 Requirements Elicitation

Transform vague requirements into actionable specifications:

```bash
python3 skills/requirements-elicitation-engine/scripts/generate_requirements_brief.py \
  --brief "Build an e-commerce product page" \
  --out-dir ./requirements \
  --json
```

**Output:**
- `requirements.summary.json` - Structured requirements
- `requirements.prd.md` - Product requirements document
- `requirements.questions.md` - Clarification Q&A

### 🎨 Design Token Generation

Generate consistent design tokens from aesthetic direction:

```bash
python3 skills/ui-aesthetic-coach/scripts/generate_design_tokens.py \
  --direction "Data Clarity" \
  --density comfortable \
  --brand-color "#3b82f6" \
  --format both \
  --json-out ./tokens.json \
  --css-out ./tokens.css
```

---

## 📁 Project Structure

```
RUI-agentskills/
├── 📦 Bundle Distributions
│   ├── codex-cn/              # Codex Chinese bundle
│   │   ├── AGENTS.md
│   │   └── skills/
│   ├── codex-en/              # Codex English bundle
│   │   ├── AGENTS.md
│   │   └── skills/
│   ├── claude-cn/             # Claude Chinese bundle
│   │   ├── CLAUDE.md
│   │   └── skills/
│   └── claude-en/             # Claude English bundle
│       ├── CLAUDE.md
│       └── skills/
│
├── 📂 Skill Implementations (per bundle)
│   └── skills/
│       ├── ui-fullflow-orchestrator/
│       │   ├── SKILL.md
│       │   ├── scripts/
│       │   └── references/
│       ├── ui-codegen-master/
│       ├── style-scope-guard/
│       ├── ... (16 more skills)
│       │
│       ├── 📋 contracts/         # Inter-skill agreements
│       │   ├── fullflow-handoff.md
│       │   ├── quality-gates.md
│       │   └── reasoning-visibility.md
│       │
│       ├── 📚 references/        # Design standards
│       │   ├── AI_UI_Skill_Design_Document.md
│       │   ├── ui-aesthetic-skill.md
│       │   ├── frontend-code-standards.md
│       │   └── ...
│       │
│       └── 🌍 variants/          # Language indexes
│           ├── CN/SKILLS.md
│           └── EN/SKILLS.md
│
├── 📄 Documentation
│   ├── README.md
│   ├── README_CN.md
│   └── bundle.manifest.json
│
└── 🔧 This README
```

---

## 🔌 Integration Guide

### For Codex Users

1. **Copy skills**
   ```bash
   cp -R RUI-agentskills/codex-en/skills/* ~/.codex/skills/
   ```

2. **Add to project**
   ```bash
   cp RUI-agentskills/codex-en/AGENTS.md /your/project/AGENTS.md
   ```

3. **Use in prompts**
   ```
   I need to build a landing page. Let's start with $ui-fullflow-orchestrator.
   ```

### For Claude Users

1. **Copy skills**
   ```bash
   cp -R RUI-agentskills/claude-en/skills/* /your/project/skills/
   ```

2. **Merge entry file**
   ```bash
   cat RUI-agentskills/claude-en/CLAUDE.md >> /your/project/CLAUDE.md
   ```

3. **Use in conversation**
   ```
   Please use $ui-aesthetic-coach to review my current design direction.
   ```

---

## 🛠️ Maintenance

### Export/Update Bundles

```bash
# Re-export all bundles with latest changes
python3 skills/skill-structure-governor/scripts/export_skill_bundles.py \
  --out-dir RUI-agentskills \
  --clean
```

### Validate Structure

```bash
# Check bilingual/multi-platform consistency
python3 skills/skill-structure-governor/scripts/validate_structure.py
```

### Render Bilingual Index

```bash
# Generate language-specific skill indexes
python3 skills/skill-structure-governor/scripts/render_bilingual_index.py
```

---

<div align="center">

**[⬆ Back to Top](#-rui-agent-skills)**

</div>
