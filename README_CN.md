<div align="center">

# 🎨 RUI 智能体技能库

**面向 AI 智能体的生产级 UI 研发技能系统**

<p>
  <a href="https://github.com/yourusername/RUI-agentskills"><img src="https://img.shields.io/badge/Release-v1.0.0-2563eb?style=flat-square&logo=github" alt="Release"></a>
  <a href="./README.md"><img src="https://img.shields.io/badge/English%20Docs-Available-16a34a?style=flat-square" alt="英文文档"></a>
  <a href="./LICENSE"><img src="https://img.shields.io/badge/License-MIT-f59e0b?style=flat-square" alt="License"></a>
</p>

<p>
  <img src="https://img.shields.io/badge/分发包-4套-2563eb?style=for-the-badge&logo=package" alt="Bundles">
  <img src="https://img.shields.io/badge/技能-19个-16a34a?style=for-the-badge&logo=stackblitz" alt="Skills">
  <img src="https://img.shields.io/badge/平台-Codex%20%7C%20Claude-f59e0b?style=for-the-badge&logo=openai" alt="Platforms">
</p>

<p><strong>🌍 简体中文 | <a href="./README.md">English</a></strong></p>

</div>

---

## 📋 目录

- [✨ 核心特性](#-核心特性)
- [🚀 快速开始](#-快速开始)
- [📦 分发包说明](#-分发包说明)
- [🔧 技能全景图](#-技能全景图)
- [💡 使用示例](#-使用示例)
- [📁 项目结构](#-项目结构)
- [🔌 接入指南](#-接入指南)
- [🛠️ 维护更新](#️-维护更新)

---

## ✨ 核心特性

<div align="center">

| 特性 | 说明 |
|---------|-------------|
| 🎯 **零配置开箱即用** | 4 套完整分发包，复制即用 |
| 🔗 **全流程编排** | 19 个技能无缝协作，完整流水线 |
| 🔒 **样式边界守卫** | 防止样式改动时误触业务逻辑 |
| 🌐 **双语原生支持** | 中文与英文工作流无缝切换 |
| 📊 **质量门禁体系** | 内置验收标准与自评机制 |
| 🎨 **设计令牌系统** | 标准化审美规范与组件架构 |

</div>

### 为什么选择 RUI 智能体技能库？

<table>
<tr>
<th width="25%">场景</th>
<th width="35%">传统方式</th>
<th width="40%">使用 RUI 技能库</th>
</tr>
<tr>
<td>📋 需求模糊</td>
<td>直接开写 → 返工 → 延期</td>
<td><code>requirements-elicitation-engine</code> → 明确 PRD → 一次做对</td>
</tr>
<tr>
<td>🎨 样式调整</td>
<td>改 CSS → 破坏逻辑 → 调试数小时</td>
<td><code>style-scope-guard</code> → 锁定边界 → 安全修改</td>
</tr>
<tr>
<td>🔄 多技能协作</td>
<td>上下文丢失 → 产物不一致</td>
<td><code>ui-fullflow-orchestrator</code> → 统一流水线 → 一致输出</td>
</tr>
<tr>
<td>✅ 质量验收</td>
<td>主观评审 → 遗漏问题</td>
<td><code>ui-acceptance-auditor</code> → 评分卡 → 可量化质量</td>
</tr>
</table>

---

## 🚀 快速开始

### 方式一：项目本地接入（推荐）

```bash
# 1. 选择适合你的分发包
cd RUI-agentskills/codex-cn   # 或 codex-en / claude-cn / claude-en

# 2. 复制技能到项目目录
cp -R skills/ /path/to/your/project/

# 3. 合并入口文件到项目规则
cat AGENTS.md >> /path/to/your/project/AGENTS.md  # Codex 用户
# 或
cat CLAUDE.md >> /path/to/your/project/CLAUDE.md   # Claude 用户
```

### 方式二：全局安装（仅技能）

```bash
# 安装到 Codex 全局技能目录
mkdir -p ~/.codex/skills
cp -R RUI-agentskills/codex-cn/skills/* ~/.codex/skills/

# 然后将入口文件复制到每个项目
cp RUI-agentskills/codex-cn/AGENTS.md /path/to/your/project/AGENTS.md
```

安装完成后，请按下方步骤在对话中使用 `$ui` 启动流程。

### 安装完成后：在对话中用 `$ui` 启动（推荐）

`$ui` 是 `$ui-fullflow-orchestrator` 的别名，会触发完整 UI 流程（需求澄清 → 方案设计 → 代码实现 → 质量验收）。

```text
1) 先完成方式一或方式二（技能已加载，并已合并 AGENTS.md/CLAUDE.md）。
2) 在项目对话中输入：
   $ui 创建一个 SaaS 数据分析仪表盘，支持响应式布局和图表模块
3) 如需显式点名，可使用：
   $ui-fullflow-orchestrator 创建一个 SaaS 数据分析仪表盘，支持响应式布局和图表模块
```

---

## 📦 分发包说明

<div align="center">

| 分发包 | 平台 | 语言 | 适用场景 |
|--------|----------|----------|----------|
| `codex-cn` | OpenAI Codex |  中文 | Codex 用户，中文工作流 |
| `codex-en` | OpenAI Codex | 英文 | Codex 用户，英文工作流 |
| `claude-cn` | Anthropic Claude |  中文 | Claude 用户，中文工作流 |
| `claude-en` | Anthropic Claude | 英文 | Claude 用户，英文工作流 |

</div>

### 分发包内容

每套分发包包含：

```
📦 {bundle}/
├── 📄 AGENTS.md / CLAUDE.md     # 平台入口文件
├── 📂 skills/
│   ├── 🔧 19 个技能实现
│   ├── 📋 contracts/            # 技能间协作契约
│   ├── 🎨 references/           # 设计规范与标准
│   ├── 🌍 variants/EN|CN/       # 语言索引
│   └── 📜 platforms/            # 平台专用模板
└── 📊 manifest.json             # 分发包元数据
```

---

## 🔧 技能全景图

### 🎯 核心编排层

| 技能 | 说明 | 核心能力 |
|-------|-------------|----------------|
| **`ui-fullflow-orchestrator`** | 全流程总编排 | 从需求到交付的端到端工作流 |
| **`requirements-elicitation-engine`** | 需求澄清引擎 | 将模糊想法转化为可执行 PRD |
| **`ui-codegen-master`** | 代码生成总控 | 统筹选型、设计、生成与质量收敛 |

### 🎨 审美设计层

| 技能 | 说明 | 核心能力 |
|-------|-------------|----------------|
| **`ui-aesthetic-coach`** | 视觉设计顾问 | 诊断、方向建议与令牌生成 |
| **`ui-aesthetic-generator`** | 设计系统生成器 | 将规范转化为实现约束 |
| **`svg-canvas-icon-engine`** | 图标系统引擎 | 生成清单、规范与可复用资源 |

### 🔨 研发执行层

| 技能 | 说明 | 核心能力 |
|-------|-------------|----------------|
| **`ui-generation-workflow-runner`** | 代码生成执行器 | 四步实现工作流 |
| **`style-scope-guard`** | 改动边界守卫 | 防止越界修改 |
| **`ui-component-extractor`** | 组件架构师 | 自动化抽离与重构 |
| **`frontend-standards-enforcer`** | 质量守门员 | 结构、类型、性能规范检查 |

### ✅ 质量保障层

| 技能 | 说明 | 核心能力 |
|-------|-------------|----------------|
| **`ui-acceptance-auditor`** | 多维度评审 | 验收标准验证 |
| **`ui-self-reviewer`** | 交付前自检 | 代码、视觉、交互、审美四维检查 |

### 🏗️ 架构基建层

| 技能 | 说明 | 核心能力 |
|-------|-------------|----------------|
| **`project-scaffold-builder`** | 项目初始化器 | 脚手架、工具链、质量门禁 |
| **`component-library-architect`** | 设计系统创建 | 令牌系统、组件架构 |
| **`app-workspace-guide`** | 工作区分析器 | 基线检测、资产盘点 |
| **`ui-agent-workspace`** | 协作环境 | 工作区状态、画布、变更日志 |

### 📚 决策支持层

| 技能 | 说明 | 核心能力 |
|-------|-------------|----------------|
| **`ui-selector-pro`** | 库推荐器 | 确定性 UI 库选型 |
| **`ui-selector-playbook`** | 选型指南 | ADR 模式、评审策略 |

### 🔧 治理层

| 技能 | 说明 | 核心能力 |
|-------|-------------|----------------|
| **`skill-structure-governor`** | 结构验证器 | 双语/多平台一致性校验 |

---

## 💡 使用示例

### 🎬 一键全流程

以下示例直接通过 fullflow pipeline 脚本运行。

**完整命令（高级）：**
```bash
bash skills/ui-fullflow-orchestrator/scripts/run_fullflow_pipeline.sh \
  --brief "数据可视化 SaaS 分析仪表盘" \
  --style-target "仪表盘头部、指标卡片、图表区域" \
  --framework react \
  --project-type saas-modern \
  --priority performance \
  --priority accessibility \
  --density comfortable
```

**输出产物：**
- `flow.input.json` - 流水线配置
- `requirements.summary.json` - 澄清后的需求
- `style-profile.yaml` - 设计令牌
- `selector.recommend.json` - 库推荐
- `tokens.json/css` - 可直接使用的令牌
- `fullflow.report.md` - 完整执行报告

### 🔒 样式边界锁

样式改动前锁定修改范围：

```bash
python3 skills/style-scope-guard/scripts/build_style_scope_lock.py \
  --brief "更新首屏玻璃拟态效果" \
  --target "仅 Hero 区域" \
  --allowed-file "src/styles/hero.css" \
  --allowed-file "src/components/Hero.tsx" \
  --json-out ./style.scope.lock.json \
  --md-out ./style.scope.checklist.md
```

**防止：** 误改业务逻辑、API 调用、路由配置

### 📋 需求澄清

将模糊需求转化为可执行规范：

```bash
python3 skills/requirements-elicitation-engine/scripts/generate_requirements_brief.py \
  --brief "构建电商商品详情页" \
  --out-dir ./requirements \
  --json
```

**输出产物：**
- `requirements.summary.json` - 结构化需求
- `requirements.prd.md` - 产品需求文档
- `requirements.questions.md` - 澄清问答

### 🎨 设计令牌生成

从审美方向生成一致的设计令牌：

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

## 📁 项目结构

```
RUI-agentskills/
├── 📦 分发包
│   ├── codex-cn/              # Codex 中文包
│   │   ├── AGENTS.md
│   │   └── skills/
│   ├── codex-en/              # Codex 英文包
│   │   ├── AGENTS.md
│   │   └── skills/
│   ├── claude-cn/             # Claude 中文包
│   │   ├── CLAUDE.md
│   │   └── skills/
│   └── claude-en/             # Claude 英文包
│       ├── CLAUDE.md
│       └── skills/
│
├── 📂 技能实现（每套分发包）
│   └── skills/
│       ├── ui-fullflow-orchestrator/
│       │   ├── SKILL.md
│       │   ├── scripts/
│       │   └── references/
│       ├── ui-codegen-master/
│       ├── style-scope-guard/
│       ├── ... (共 19 个技能)
│       │
│       ├── 📋 contracts/         # 技能间协作契约
│       │   ├── fullflow-handoff.md
│       │   ├── quality-gates.md
│       │   └── reasoning-visibility.md
│       │
│       ├── 📚 references/        # 设计规范
│       │   ├── AI_UI_Skill_Design_Document.md
│       │   ├── ui-aesthetic-skill.md
│       │   ├── frontend-code-standards.md
│       │   └── ...
│       │
│       └── 🌍 variants/          # 语言索引
│           ├── CN/SKILLS.md
│           └── EN/SKILLS.md
│
├── 📄 文档
│   ├── README.md
│   ├── README_CN.md
│   └── bundle.manifest.json
│
└── 🔧 本说明文档
```

---

## 🔌 接入指南

### Codex 用户

1. **复制技能**
   ```bash
   cp -R RUI-agentskills/codex-cn/skills/* ~/.codex/skills/
   ```

2. **添加到项目**
   ```bash
   cp RUI-agentskills/codex-cn/AGENTS.md /your/project/AGENTS.md
   ```

3. **对话中使用**
   ```
   我要做一个落地页，先用 $ui-fullflow-orchestrator 规划一下。
   ```

### Claude 用户

1. **复制技能**
   ```bash
   cp -R RUI-agentskills/claude-cn/skills/* /your/project/skills/
   ```

2. **合并入口文件**
   ```bash
   cat RUI-agentskills/claude-cn/CLAUDE.md >> /your/project/CLAUDE.md
   ```

3. **对话中使用**
   ```
   请使用 $ui-aesthetic-coach 评审我当前的设计方向。
   ```

---

## 🛠️ 维护更新

### 导出/更新分发包

```bash
# 重新导出所有分发包（包含最新更改）
python3 skills/skill-structure-governor/scripts/export_skill_bundles.py \
  --out-dir RUI-agentskills \
  --clean
```

### 验证结构

```bash
# 检查双语/多平台一致性
python3 skills/skill-structure-governor/scripts/validate_structure.py
```

### 生成双语索引

```bash
# 生成本地化技能索引
python3 skills/skill-structure-governor/scripts/render_bilingual_index.py
```

---

<div align="center">

**[⬆ 回到顶部](#-rui-智能体技能库)**

</div>
