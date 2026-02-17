# AI Frontend Development Skill Guidelines

---
title: AI Frontend Development Skill Guidelines
version: 1.0.0
author: RUI Team
date: 2024-01-15
category: development-guidelines
tags: [frontend, ai, skills, standards]
---

## Table of Contents

1. [Overview](#overview)
2. [Skill Document Frontmatter Standards](#skill-document-frontmatter-standards)
3. [SSOT Reference Standards](#ssot-reference-standards)
4. [Script Invocation Standards](#script-invocation-standards)
5. [Output Format Standards](#output-format-standards)
6. [Multi-language/Multi-platform Structure Standards](#multi-languagemulti-platform-structure-standards)
7. [Progressive Disclosure Design Principles](#progressive-disclosure-design-principles)
8. [Appendix: Complete Template Examples](#appendix-complete-template-examples)

---

## Overview

This document defines the standardized writing guidelines for AI frontend development skills, aiming to ensure consistency, maintainability, and extensibility across all skill documents. Following these guidelines can:

- Improve readability and comprehensibility of skill documents
- Ensure consistency across platforms and languages
- Simplify skill maintenance and version management
- Support automated processing and validation

### Scope of Application

- AI frontend development skill documents
- Technical specification documents
- Development guides and best practices
- Code examples and templates

---

## Skill Document Frontmatter Standards

### 2.1 Frontmatter Standard Template

Each skill document must begin with YAML format frontmatter containing the following required fields:

```yaml
---
title: "Skill Title"
version: "1.0.0"
author: "Author Name"
date: "2024-01-15"
category: "Skill Category"
tags: ["tag1", "tag2", "tag3"]
description: "Brief description of the skill"
---
```

### 2.2 Field Detailed Description

| Field Name | Type | Required | Description |
|------------|------|----------|-------------|
| `title` | string | Yes | Skill title, concise and clear |
| `version` | string | Yes | Semantic version, format: major.minor.patch |
| `author` | string | Yes | Author or maintainer name |
| `date` | string | Yes | Creation or update date, ISO 8601 format |
| `category` | string | Yes | Skill category, see category list below |
| `tags` | array | Yes | Keyword tags, 3-5 recommended |
| `description` | string | No | Brief description of the skill, within 100 characters |
| `deprecated` | boolean | No | Whether deprecated |
| `replaces` | string | No | Document path that replaces this skill |

### 2.3 Skill Category List

```yaml
categories:
  - frontend-framework    # Frontend Framework
  - ui-components         # UI Components
  - state-management      # State Management
  - styling               # Styling
  - build-tools           # Build Tools
  - testing               # Testing
  - performance           # Performance Optimization
  - accessibility         # Accessibility
  - security              # Security
  - best-practices        # Best Practices
```

### 2.4 Extended Frontmatter Example

```yaml
---
title: "React Hooks Best Practices"
version: "2.1.0"
author: "RUI Team"
date: "2024-01-15"
category: "frontend-framework"
tags: ["react", "hooks", "javascript", "best-practices"]
description: "Guidelines and best practices for using React Hooks"
prerequisites:
  - "React Fundamentals"
  - "ES6+ Syntax"
difficulty: "intermediate"  # beginner, intermediate, advanced
time_estimate: "30 minutes"
related_skills:
  - "/skills/react-components.md"
  - "/skills/state-management.md"
---
```

---

## SSOT Reference Standards

### 3.1 SSOT Principles

**Single Source of Truth (SSOT)** is the core principle for ensuring document consistency. All repeated information must reference the original source.

### 3.2 SSOT Reference Format

#### 3.2.1 Basic Reference Format

```markdown
<!-- Reference other documents -->
See [Component Design Guidelines](ssot://design/component-guidelines)

<!-- Reference code snippets -->
Code example from [Base Template](ssot://templates/base-component#setup-section)

<!-- Reference configuration -->
Configuration items defined in [eslint-config](ssot://config/eslint#rules)
```

#### 3.2.2 Reference Path Specification

```
ssot://{category}/{document-name}[#{section-id}]
```

| Component | Description | Example |
|-----------|-------------|---------|
| `ssot://` | Protocol prefix indicating SSOT reference | - |
| `{category}` | Document category | `design`, `config`, `templates` |
| `{document-name}` | Document identifier | `component-guidelines` |
| `{section-id}` | Optional, anchor ID | `setup-section` |

### 3.3 Reference Type Definitions

```yaml
# SSOT reference type configuration
ssot_types:
  design:          # Design specifications
    path: "/design/"
    description: "UI/UX Design Guidelines"
  
  config:          # Configuration files
    path: "/config/"
    description: "Project Configuration Files"
  
  templates:       # Code templates
    path: "/templates/"
    description: "Reusable Code Templates"
  
  standards:       # Standard specifications
    path: "/standards/"
    description: "Technical Standard Documents"
  
  examples:        # Example code
    path: "/examples/"
    description: "Complete Example Projects"
```

### 3.4 SSOT Reference Examples

```markdown
## Component Development Standards

### Basic Structure

Components must follow the structure defined in [Base Component Template](ssot://templates/base-component).

### Style Standards

For color usage, see [Design System - Colors](ssot://design/color-system),
for specific color values, see [Theme Configuration](ssot://config/theme#colors).

### ESLint Configuration

The project uses [Standard ESLint Configuration](ssot://config/eslint),
for rule overrides, see [Rule Override Instructions](ssot://config/eslint#rule-overrides).
```

### 3.5 Validating SSOT References

Use the following scripts to validate SSOT references in documents:

```bash
# Validate all SSOT references
node scripts/validate-ssot.js --check-all

# Validate specific document
node scripts/validate-ssot.js --file path/to/document.md

# Generate SSOT reference report
node scripts/validate-ssot.js --report
```

---

## Script Invocation Standards

### 4.1 Three Invocation Methods

#### Method 1: Direct Command Invocation

Suitable for simple, one-time script execution.

```markdown
Run the following command to initialize the project:

```bash
npx create-react-app my-app --template typescript
```

Install dependencies:

```bash
npm install @rui/core @rui/hooks
```
```

#### Method 2: Configuration-based Script Invocation

Suitable for complex scripts requiring parameter configuration.

```markdown
### Running Scripts with Configuration

Create `ui.config.js`:

```javascript
module.exports = {
  scripts: {
    build: {
      command: 'webpack',
      args: ['--mode', 'production'],
      env: {
        NODE_ENV: 'production'
      }
    },
    dev: {
      command: 'webpack-dev-server',
      args: ['--mode', 'development'],
      env: {
        NODE_ENV: 'development'
      }
    }
  }
};
```

Run scripts:

```bash
npm run build
npm run dev
```
```

#### Method 3: Programmatic API Invocation

Suitable for integrating script functionality into code.

```markdown
### Programmatic Invocation

```javascript
const { RUIScripts } = require('@rui/scripts');

const scripts = new RUIScripts({
  configPath: './ui.config.js'
});

// Execute script asynchronously
async function runBuild() {
  try {
    const result = await scripts.run('build', {
      verbose: true,
      watch: false
    });
    console.log('Build successful:', result.output);
  } catch (error) {
    console.error('Build failed:', error.message);
  }
}

runBuild();
```
```

### 4.2 Script Invocation Method Comparison

| Invocation Method | Applicable Scenario | Advantages | Disadvantages |
|-------------------|---------------------|------------|---------------|
| Direct Command | Simple tasks, quick execution | Simple and intuitive | Hard to reuse, limited parameters |
| Configuration | Complex tasks, team collaboration | Configurable, version controllable | Requires configuration file |
| Programmatic | Integrated development, automation | High flexibility, programmable | Higher learning curve |

### 4.3 Script Parameter Standards

```yaml
# Script parameter definition specification
script_parameters:
  name:
    type: string
    required: true
    description: "Parameter name"
  
  type:
    type: string
    required: true
    enum: [string, number, boolean, array, object]
    description: "Parameter data type"
  
  required:
    type: boolean
    default: false
    description: "Whether required"
  
  default:
    type: any
    description: "Default value"
  
  description:
    type: string
    required: true
    description: "Parameter description"
  
  validation:
    type: object
    description: "Validation rules"
```

### 4.4 Complete Script Example

```javascript
#!/usr/bin/env node

/**
 * @ui-script generate-component
 * @description Generate standardized component templates
 * @version 1.0.0
 */

const fs = require('fs');
const path = require('path');

// Parameter definitions
const PARAMS = {
  name: {
    type: 'string',
    required: true,
    description: 'Component name (PascalCase)'
  },
  type: {
    type: 'string',
    required: false,
    default: 'functional',
    enum: ['functional', 'class'],
    description: 'Component type'
  },
  withStyles: {
    type: 'boolean',
    required: false,
    default: true,
    description: 'Whether to generate style files'
  },
  withTests: {
    type: 'boolean',
    required: false,
    default: true,
    description: 'Whether to generate test files'
  },
  outputDir: {
    type: 'string',
    required: false,
    default: './src/components',
    description: 'Output directory'
  }
};

// Main function
async function generateComponent(params) {
  const { name, type, withStyles, withTests, outputDir } = params;
  
  // Validate component name
  if (!/^[A-Z][a-zA-Z0-9]*$/.test(name)) {
    throw new Error('Component name must follow PascalCase convention');
  }
  
  const componentDir = path.join(outputDir, name);
  
  // Create directory
  if (!fs.existsSync(componentDir)) {
    fs.mkdirSync(componentDir, { recursive: true });
  }
  
  // Generate component file
  const componentContent = generateComponentFile(name, type);
  fs.writeFileSync(
    path.join(componentDir, `${name}.tsx`),
    componentContent
  );
  
  // Generate style file
  if (withStyles) {
    const stylesContent = generateStylesFile(name);
    fs.writeFileSync(
      path.join(componentDir, `${name}.module.css`),
      stylesContent
    );
  }
  
  // Generate test file
  if (withTests) {
    const testContent = generateTestFile(name);
    fs.writeFileSync(
      path.join(componentDir, `${name}.test.tsx`),
      testContent
    );
  }
  
  // Generate index file
  const indexContent = `export { default } from './${name}';
export * from './${name}';
`;
  fs.writeFileSync(
    path.join(componentDir, 'index.ts'),
    indexContent
  );
  
  console.log(`✅ Component ${name} generated successfully!`);
  console.log(`📁 Location: ${componentDir}`);
}

// Generate component file content
function generateComponentFile(name, type) {
  if (type === 'functional') {
    return `import React from 'react';
import styles from './${name}.module.css';

export interface ${name}Props {
  /** Component class name */
  className?: string;
  /** Child elements */
  children?: React.ReactNode;
}

/**
 * ${name} Component
 */
export const ${name}: React.FC<${name}Props> = ({ 
  className,
  children 
}) => {
  return (
    <div className={\`\${styles.container} \${className || ''}\`}>
      {children}
    </div>
  );
};

export default ${name};
`;
  }
  
  // Class component template
  return `import React, { Component } from 'react';
import styles from './${name}.module.css';

export interface ${name}Props {
  className?: string;
  children?: React.ReactNode;
}

export interface ${name}State {
  // State definitions
}

/**
 * ${name} Component
 */
export class ${name} extends Component<${name}Props, ${name}State> {
  state: ${name}State = {};

  render() {
    const { className, children } = this.props;
    
    return (
      <div className={\`\${styles.container} \${className || ''}\`}>
        {children}
      </div>
    );
  }
}

export default ${name};
`;
}

// Generate style file content
function generateStylesFile(name) {
  return `/* ${name} Component Styles */

.container {
  /* Base styles */
}
`;
}

// Generate test file content
function generateTestFile(name) {
  return `import React from 'react';
import { render, screen } from '@testing-library/react';
import { ${name} } from './${name}';

describe('${name}', () => {
  it('should render correctly', () => {
    render(<${name}>Test content</${name}>);
    expect(screen.getByText('Test content')).toBeInTheDocument();
  });
});
`;
}

// CLI entry
if (require.main === module) {
  const args = process.argv.slice(2);
  const params = {};
  
  // Parse arguments
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg.startsWith('--')) {
      const key = arg.slice(2);
      const value = args[i + 1];
      
      // Type conversion
      if (value === 'true') params[key] = true;
      else if (value === 'false') params[key] = false;
      else if (!isNaN(Number(value))) params[key] = Number(value);
      else params[key] = value;
      
      i++;
    }
  }
  
  // Validate required parameters
  if (!params.name) {
    console.error('Error: --name parameter is required');
    process.exit(1);
  }
  
  generateComponent(params).catch(error => {
    console.error('Generation failed:', error.message);
    process.exit(1);
  });
}

module.exports = { generateComponent, PARAMS };
```

---

## Output Format Standards

### 5.1 Markdown Output Format

#### 5.1.1 Standard Structure

```markdown
# Document Title

---
frontmatter content
---

## Table of Contents

1. [Chapter 1](#chapter-1)
2. [Chapter 2](#chapter-2)

---

## Chapter 1

### Subchapter

Content...

---

## Chapter 2

Content...

---

## Appendix

Additional information...
```

#### 5.1.2 Markdown Format Standards

| Element | Standard | Example |
|---------|----------|---------|
| Headings | `#` to `######`, only one level 1 | `## Level 2 Heading` |
| Code blocks | Specify language with syntax highlighting | ```javascript |
| Tables | Headers required, alignment optional | See examples above |
| Lists | Consistent ordered/unordered mixing | `-` or `1.` |
| Blockquotes | Use `>`, can be nested | `> Quote content` |
| Links | Relative paths preferred | `[Text](./path)` |
| Images | With alt text | `![alt](./path)` |

### 5.2 JSON Output Format

#### 5.2.1 Standard JSON Structure

```json
{
  "schema": "https://rui.dev/schemas/skill-output/v1",
  "metadata": {
    "title": "Output Title",
    "version": "1.0.0",
    "generatedAt": "2024-01-15T10:30:00Z",
    "generator": "rui-cli@2.1.0"
  },
  "data": {
    // Actual data content
  },
  "errors": [],
  "warnings": []
}
```

#### 5.2.2 JSON Schema Definition

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://rui.dev/schemas/skill-output/v1",
  "title": "Skill Output Schema",
  "type": "object",
  "required": ["schema", "metadata", "data"],
  "properties": {
    "schema": {
      "type": "string",
      "format": "uri",
      "description": "Schema URL"
    },
    "metadata": {
      "type": "object",
      "required": ["title", "version", "generatedAt"],
      "properties": {
        "title": { "type": "string" },
        "version": { "type": "string" },
        "generatedAt": { "type": "string", "format": "date-time" },
        "generator": { "type": "string" }
      }
    },
    "data": {
      "type": "object",
      "description": "Actual output data"
    },
    "errors": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "code": { "type": "string" },
          "message": { "type": "string" },
          "details": { "type": "object" }
        }
      }
    },
    "warnings": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "code": { "type": "string" },
          "message": { "type": "string" }
        }
      }
    }
  }
}
```

#### 5.2.3 JSON Output Example

```json
{
  "schema": "https://rui.dev/schemas/skill-output/v1",
  "metadata": {
    "title": "Component Analysis Report",
    "version": "1.0.0",
    "generatedAt": "2024-01-15T10:30:00Z",
    "generator": "rui-analyzer@1.2.0"
  },
  "data": {
    "components": [
      {
        "name": "Button",
        "type": "functional",
        "props": [
          { "name": "variant", "type": "string", "required": false },
          { "name": "onClick", "type": "function", "required": false }
        ],
        "complexity": {
          "cyclomatic": 3,
          "cognitive": 2
        },
        "testCoverage": 85.5
      }
    ],
    "summary": {
      "totalComponents": 1,
      "averageComplexity": 2.5,
      "averageCoverage": 85.5
    }
  },
  "errors": [],
  "warnings": [
    {
      "code": "LOW_COVERAGE",
      "message": "Button component test coverage is below 90%"
    }
  ]
}
```

### 5.3 YAML Output Format

#### 5.3.1 Standard YAML Structure

```yaml
schema: https://rui.dev/schemas/skill-config/v1

metadata:
  title: Configuration Title
  version: 1.0.0
  createdAt: 2024-01-15T10:30:00Z

config:
  # Configuration content

environments:
  development:
    # Development environment configuration
  production:
    # Production environment configuration
```

#### 5.3.2 YAML Configuration Example

```yaml
schema: https://rui.dev/schemas/component-config/v1

metadata:
  title: Button Component Configuration
  version: 2.1.0
  author: RUI Team

component:
  name: Button
  displayName: Button
  category: basic
  
  props:
    - name: variant
      type: string
      default: primary
      enum:
        - primary
        - secondary
        - outline
        - ghost
      description: Button style variant
    
    - name: size
      type: string
      default: medium
      enum:
        - small
        - medium
        - large
      description: Button size
    
    - name: disabled
      type: boolean
      default: false
      description: Whether disabled
    
    - name: onClick
      type: function
      description: Click event handler
  
  styles:
    base:
      padding: "8px 16px"
      borderRadius: "4px"
      cursor: pointer
    
    variants:
      primary:
        backgroundColor: "#1890ff"
        color: "#ffffff"
      
      secondary:
        backgroundColor: "#f0f0f0"
        color: "#333333"
    
    sizes:
      small:
        padding: "4px 8px"
        fontSize: "12px"
      
      medium:
        padding: "8px 16px"
        fontSize: "14px"
      
      large:
        padding: "12px 24px"
        fontSize: "16px"
  
  accessibility:
    role: button
    keyboard:
      - key: Enter
        action: activate
      - key: Space
        action: activate
    aria:
      - property: aria-disabled
        value: "${disabled}"
```

### 5.4 Output Format Selection Guide

| Scenario | Recommended Format | Reason |
|----------|-------------------|--------|
| Documentation, instructions | Markdown | High readability, rich formatting support |
| API responses, data exchange | JSON | Standardized, easy to parse |
| Configuration files | YAML | Concise, supports comments |
| Complex structured data | JSON/YAML | Supports nesting and validation |

---

## Multi-language/Multi-platform Structure Standards

### 6.1 Directory Structure

```
RUI-agentskills/
├── claude/                    # Claude AI Platform
│   ├── en/                   # English Content
│   │   ├── skills/          # Skill Documents
│   │   ├── templates/       # Code Templates
│   │   ├── examples/        # Example Projects
│   │   └── standards/       # Standard Specifications
│   └── cn/                  # Chinese Content
│       ├── skills/
│       ├── templates/
│       ├── examples/
│       └── standards/
│
├── codex/                     # Codex AI Platform
│   ├── en/
│   │   ├── skills/
│   │   ├── templates/
│   │   ├── examples/
│   │   └── standards/
│   └── cn/
│       ├── skills/
│       ├── templates/
│       ├── examples/
│       └── standards/
│
├── shared/                    # Shared Resources
│   ├── assets/              # Images, Icons, etc.
│   ├── schemas/             # JSON Schema Definitions
│   ├── configs/             # Shared Configuration
│   └── translations/        # Translation Files
│
└── scripts/                   # Automation Scripts
    ├── validate.js          # Validation Script
    ├── sync.js              # Sync Script
    └── generate.js          # Generation Script
```

### 6.2 Platform-specific Standards

#### 6.2.1 Claude Platform Standards

```yaml
# claude/platform-config.yaml
platform: claude
version: "1.0"

features:
  - extended_context
  - tool_use
  - vision

format:
  max_tokens: 4096
  preferred_format: markdown
  
special_requirements:
  - Use XML tags to organize complex content
  - Support artifacts feature
  - Follow Claude-specific prompt conventions
```

#### 6.2.2 Codex Platform Standards

```yaml
# codex/platform-config.yaml
platform: codex
version: "1.0"

features:
  - code_generation
  - inline_suggestions
  
format:
  max_tokens: 2048
  preferred_format: code_blocks
  
special_requirements:
  - Code blocks must specify full file paths
  - Support inline edit suggestions
  - Follow OpenAI Codex format
```

### 6.3 Content Synchronization Mechanism

```javascript
// scripts/sync.js
/**
 * Multi-platform content synchronization script
 */

const fs = require('fs');
const path = require('path');
const glob = require('glob');

class ContentSync {
  constructor(config) {
    this.sourceDir = config.sourceDir;
    this.targetDirs = config.targetDirs;
    this.translations = config.translations || {};
  }

  /**
   * Sync content to all target platforms
   */
  async syncAll() {
    const sourceFiles = this.getSourceFiles();
    
    for (const file of sourceFiles) {
      await this.syncFile(file);
    }
  }

  /**
   * Sync a single file
   */
  async syncFile(sourcePath) {
    const content = fs.readFileSync(sourcePath, 'utf-8');
    const relativePath = path.relative(this.sourceDir, sourcePath);
    
    for (const [platform, targetDir] of Object.entries(this.targetDirs)) {
      // Adapt to platform-specific format
      const adaptedContent = this.adaptForPlatform(content, platform);
      
      // Apply translation
      const translatedContent = this.applyTranslation(
        adaptedContent, 
        this.translations[platform]
      );
      
      // Write to target file
      const targetPath = path.join(targetDir, relativePath);
      this.ensureDir(path.dirname(targetPath));
      fs.writeFileSync(targetPath, translatedContent);
      
      console.log(`✅ Synced: ${sourcePath} -> ${targetPath}`);
    }
  }

  /**
   * Adapt to platform-specific format
   */
  adaptForPlatform(content, platform) {
    switch (platform) {
      case 'claude':
        return this.adaptForClaude(content);
      case 'codex':
        return this.adaptForCodex(content);
      default:
        return content;
    }
  }

  /**
   * Adapt to Claude format
   */
  adaptForClaude(content) {
    // Convert code blocks to artifact format
    return content.replace(
      /```(\w+)\n([\s\S]*?)```/g,
      (match, lang, code) => {
        return `<artifact type="${lang}">\n${code}</artifact>`;
      }
    );
  }

  /**
   * Adapt to Codex format
   */
  adaptForCodex(content) {
    // Add file path comments
    return content.replace(
      /```(\w+)\n/g,
      (match, lang) => {
        return `\`\`\`${lang}:path/to/file.ext\n`;
      }
    );
  }

  /**
   * Apply translation
   */
  applyTranslation(content, translations) {
    if (!translations) return content;
    
    let translated = content;
    for (const [key, value] of Object.entries(translations)) {
      translated = translated.replace(
        new RegExp(key, 'g'),
        value
      );
    }
    return translated;
  }

  getSourceFiles() {
    return glob.sync('**/*.md', { cwd: this.sourceDir, absolute: true });
  }

  ensureDir(dir) {
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
  }
}

// CLI entry
if (require.main === module) {
  const sync = new ContentSync({
    sourceDir: './claude/en',
    targetDirs: {
      'claude-cn': './claude/cn',
      'codex-en': './codex/en',
      'codex-cn': './codex/cn'
    },
    translations: {
      'claude-cn': {
        'Introduction': '简介',
        'Getting Started': '开始使用'
      },
      'codex-cn': {
        'Introduction': '简介',
        'Getting Started': '开始使用'
      }
    }
  });

  sync.syncAll().catch(console.error);
}

module.exports = ContentSync;
```

### 6.4 Multi-language File Naming Standards

| Language | Code | File Naming Example |
|----------|------|---------------------|
| Simplified Chinese | cn | `document.cn.md` |
| Traditional Chinese | tw | `document.tw.md` |
| English | en | `document.en.md` |
| Japanese | ja | `document.ja.md` |
| Korean | ko | `document.ko.md` |

---

## Progressive Disclosure Design Principles

### 7.1 Progressive Disclosure Overview

Progressive Disclosure is an information architecture strategy that helps users gradually understand complex concepts through layered presentation of information, avoiding cognitive overload.

### 7.2 Five Disclosure Levels

```
┌─────────────────────────────────────────────────────────────┐
│                    Progressive Disclosure Pyramid            │
├─────────────────────────────────────────────────────────────┤
│  Level 5: Expert Reference                                   │
│  └─ Complete API documentation, source code, advanced config │
├─────────────────────────────────────────────────────────────┤
│  Level 4: Deep Dive                                          │
│  └─ Detailed tutorials, best practices, architecture design  │
├─────────────────────────────────────────────────────────────┤
│  Level 3: Complete Example                                   │
│  └─ Runnable complete code, project templates                │
├─────────────────────────────────────────────────────────────┤
│  Level 2: Quick Start                                        │
│  └─ Core concepts, basic usage, minimal examples             │
├─────────────────────────────────────────────────────────────┤
│  Level 1: Overview                                           │
│  └─ Introduction, feature list, applicable scenarios         │
└─────────────────────────────────────────────────────────────┘
```

### 7.3 Detailed Explanation of Each Level

#### Level 1: Overview

**Goal**: Let users quickly understand what this is and if it's suitable for them

**Content**:
- One-sentence description
- Core feature list
- Applicable scenarios
- Quick preview

**Implementation**:

```markdown
# React Hooks Skill

> One-sentence description: Master modern React development with Hooks

## Core Features

- ✨ Functional component state management
- 🔄 Side effect handling
- 🎯 Custom Hook logic reuse
- ⚡ Performance optimization

## Applicable Scenarios

- New projects using React 16.8+
- Migrating class components to function components
- Need to reuse state logic

## Quick Preview

```jsx
function Counter() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(c => c + 1)}>{count}</button>;
}
```
```

#### Level 2: Quick Start

**Goal**: Get users started within 5 minutes

**Content**:
- Environment preparation
- Installation steps
- First example
- Core concepts introduction

**Implementation**:

```markdown
## Quick Start

### Environment Preparation

- Node.js 14+
- React 16.8+

### Installation

```bash
npm install @rui/react-hooks
```

### First Hook

```jsx
import { useState } from 'react';

function Example() {
  // Declare state variable
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>Clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
    </div>
  );
}
```

### Core Concepts

<details>
<summary>useState - State Management</summary>

`useState` lets you add state to function components.

```jsx
const [state, setState] = useState(initialValue);
```

- `state`: Current state value
- `setState`: Function to update state
- `initialValue`: Initial value

</details>
```

#### Level 3: Complete Example

**Goal**: Provide runnable complete code

**Content**:
- Complete feature implementation
- Multiple usage scenarios
- Error handling
- Test cases

**Implementation**:

```markdown
## Complete Example

### Todo App

A complete Todo app demonstrating the combination of multiple Hooks.

```jsx
// TodoApp.jsx
import React, { useState, useEffect, useCallback } from 'react';

function TodoApp() {
  const [todos, setTodos] = useState([]);
  const [inputValue, setInputValue] = useState('');
  const [filter, setFilter] = useState('all');

  // Load from local storage
  useEffect(() => {
    const saved = localStorage.getItem('todos');
    if (saved) {
      setTodos(JSON.parse(saved));
    }
  }, []);

  // Save to local storage
  useEffect(() => {
    localStorage.setItem('todos', JSON.stringify(todos));
  }, [todos]);

  const addTodo = useCallback(() => {
    if (inputValue.trim()) {
      setTodos([...todos, {
        id: Date.now(),
        text: inputValue,
        completed: false
      }]);
      setInputValue('');
    }
  }, [inputValue, todos]);

  const toggleTodo = useCallback((id) => {
    setTodos(todos.map(todo =>
      todo.id === id ? { ...todo, completed: !todo.completed } : todo
    ));
  }, [todos]);

  const deleteTodo = useCallback((id) => {
    setTodos(todos.filter(todo => todo.id !== id));
  }, [todos]);

  const filteredTodos = todos.filter(todo => {
    if (filter === 'active') return !todo.completed;
    if (filter === 'completed') return todo.completed;
    return true;
  });

  return (
    <div className="todo-app">
      <h1>Todo List</h1>
      
      <div className="input-section">
        <input
          value={inputValue}
          onChange={(e) => setInputValue(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && addTodo()}
          placeholder="Add new task..."
        />
        <button onClick={addTodo}>Add</button>
      </div>

      <div className="filter-section">
        <button onClick={() => setFilter('all')}>All</button>
        <button onClick={() => setFilter('active')}>Active</button>
        <button onClick={() => setFilter('completed')}>Completed</button>
      </div>

      <ul className="todo-list">
        {filteredTodos.map(todo => (
          <li key={todo.id} className={todo.completed ? 'completed' : ''}>
            <span onClick={() => toggleTodo(todo.id)}>
              {todo.text}
            </span>
            <button onClick={() => deleteTodo(todo.id)}>Delete</button>
          </li>
        ))}
      </ul>

      <div className="stats">
        Total: {todos.length} | 
        Completed: {todos.filter(t => t.completed).length} | 
        Pending: {todos.filter(t => !t.completed).length}
      </div>
    </div>
  );
}

export default TodoApp;
```

### Test Cases

```jsx
// TodoApp.test.jsx
import { render, screen, fireEvent } from '@testing-library/react';
import TodoApp from './TodoApp';

describe('TodoApp', () => {
  it('should add tasks', () => {
    render(<TodoApp />);
    
    const input = screen.getByPlaceholderText('Add new task...');
    const button = screen.getByText('Add');
    
    fireEvent.change(input, { target: { value: 'Test task' } });
    fireEvent.click(button);
    
    expect(screen.getByText('Test task')).toBeInTheDocument();
  });

  it('should toggle task status', () => {
    render(<TodoApp />);
    
    // Add task
    const input = screen.getByPlaceholderText('Add new task...');
    fireEvent.change(input, { target: { value: 'Test task' } });
    fireEvent.click(screen.getByText('Add'));
    
    // Toggle status
    fireEvent.click(screen.getByText('Test task'));
    
    expect(screen.getByText('Completed: 1')).toBeInTheDocument();
  });
});
```
```

#### Level 4: Deep Dive

**Goal**: Deep understanding of principles and best practices

**Content**:
- Detailed explanation of how it works
- Performance optimization tips
- Common pitfalls
- Design patterns

**Implementation**:

```markdown
## Deep Dive

### How useEffect Works

<details>
<summary>Click to view detailed explanation</summary>

`useEffect` executes after each render, controlling execution timing through the dependency array:

```
Render phase -> Commit phase -> Execute effect
```

#### Execution Timing Comparison

| Scenario | Execution Timing |
|----------|------------------|
| No dependency array | After every render |
| Empty array `[]` | Only on mount and unmount |
| With dependencies `[a, b]` | When dependencies change |

#### Cleanup Function

```jsx
useEffect(() => {
  const subscription = props.source.subscribe();
  
  // Return cleanup function
  return () => {
    subscription.unsubscribe();
  };
}, [props.source]);
```

</details>

### Performance Optimization

#### 1. Cache Computations with useMemo

```jsx
const expensiveValue = useMemo(() => {
  return data.filter(item => item.active)
    .map(item => processItem(item))
    .reduce((sum, item) => sum + item.value, 0);
}, [data]);
```

#### 2. Stabilize Function References with useCallback

```jsx
const handleClick = useCallback(() => {
  doSomething(a, b);
}, [a, b]);
```

### Common Pitfalls

<details>
<summary>Pitfall 1: Closure Trap</summary>

```jsx
// ❌ Wrong: Using old state value
function Counter() {
  const [count, setCount] = useState(0);
  
  useEffect(() => {
    const timer = setInterval(() => {
      console.log(count); // Always 0
      setCount(count + 1); // Always 1
    }, 1000);
    return () => clearInterval(timer);
  }, []); // Empty dependency array
  
  return <div>{count}</div>;
}

// ✅ Correct: Use functional update
function Counter() {
  const [count, setCount] = useState(0);
  
  useEffect(() => {
    const timer = setInterval(() => {
      setCount(c => c + 1); // Use latest value
    }, 1000);
    return () => clearInterval(timer);
  }, []);
  
  return <div>{count}</div>;
}
```

</details>

### Custom Hook Design Patterns

#### Pattern 1: Data Fetching Hook

```jsx
function useData(url) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    let cancelled = false;
    
    async function fetchData() {
      try {
        setLoading(true);
        const response = await fetch(url);
        const result = await response.json();
        
        if (!cancelled) {
          setData(result);
          setError(null);
        }
      } catch (err) {
        if (!cancelled) {
          setError(err);
        }
      } finally {
        if (!cancelled) {
          setLoading(false);
        }
      }
    }
    
    fetchData();
    
    return () => {
      cancelled = true;
    };
  }, [url]);

  return { data, loading, error };
}
```
```

#### Level 5: Expert Reference

**Goal**: Provide complete reference information

**Content**:
- Complete API documentation
- Source code analysis
- Advanced configuration options
- Contribution guidelines

**Implementation**:

```markdown
## Expert Reference

### Complete API

#### useState

```typescript
function useState<S>(
  initialState: S | (() => S)
): [S, Dispatch<SetStateAction<S>>];
```

**Type Parameters**

| Parameter | Description |
|-----------|-------------|
| `S` | State type |

**Parameters**

| Parameter | Type | Description |
|-----------|------|-------------|
| `initialState` | `S \| (() => S)` | Initial state value or factory function |

**Return Value**

| Index | Type | Description |
|-------|------|-------------|
| `[0]` | `S` | Current state value |
| `[1]` | `Dispatch<SetStateAction<S>>` | State update function |

### Source Code Analysis

<details>
<summary>useState Implementation Principle</summary>

React internally uses a linked list structure to store Hook state:

```javascript
// Simplified implementation
function useState(initialState) {
  const hook = getCurrentHook();
  
  if (!hook.state) {
    hook.state = typeof initialState === 'function' 
      ? initialState() 
      : initialState;
  }
  
  const setState = (action) => {
    hook.state = typeof action === 'function'
      ? action(hook.state)
      : action;
    scheduleUpdate();
  };
  
  return [hook.state, setState];
}
```

</details>

### Advanced Configuration

```javascript
// react.config.js
module.exports = {
  hooks: {
    // Enable strict mode checking
    strictMode: true,
    
    // Custom Hook prefix
    prefix: 'use',
    
    // Performance monitoring
    profiling: {
      enabled: process.env.NODE_ENV === 'development',
      threshold: 16 // milliseconds
    },
    
    // Experimental features
    experimental: {
      useId: true,
      useTransition: true,
      useDeferredValue: true
    }
  }
};
```

### Contribution Guidelines

1. Fork the repository
2. Create a feature branch
3. Submit changes
4. Create a Pull Request

See [CONTRIBUTING.md](./CONTRIBUTING.md) for details
```

### 7.4 Progressive Disclosure Implementation Tips

#### Using Collapsible Panels

```markdown
<details>
<summary>Click to expand detailed content</summary>

Detailed content here...

</details>
```

#### Using Tabs

```markdown
<!-- Using HTML to implement tabs -->
<div class="tabs">
  <input type="radio" name="tab" id="tab1" checked>
  <label for="tab1">Basic Usage</label>
  <div class="tab-content">
    Basic usage content...
  </div>
  
  <input type="radio" name="tab" id="tab2">
  <label for="tab2">Advanced Usage</label>
  <div class="tab-content">
    Advanced usage content...
  </div>
</div>
```

#### Using Step Indicators

```markdown
## Learning Path

1. ✅ [Overview](#overview) - Understand basic concepts
2. ⏳ [Quick Start](#quick-start) - Hands-on practice
3. 🔒 [Complete Example](#complete-example) - Deep understanding
4. 🔒 [Deep Dive](#deep-dive) - Master principles
5. 🔒 [Expert Reference](#expert-reference) - Become an expert
```

---

## Appendix: Complete Template Examples

### A.1 Complete Skill Document Template

```markdown
---
title: "Skill Title"
version: "1.0.0"
author: "Author Name"
date: "2024-01-15"
category: "Skill Category"
tags: ["tag1", "tag2", "tag3"]
description: "Brief description of the skill"
prerequisites:
  - "Prerequisite skill 1"
  - "Prerequisite skill 2"
difficulty: "beginner"
time_estimate: "30 minutes"
---

# Skill Title

> One-sentence description of the skill's core value

## Table of Contents

1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [Complete Example](#complete-example)
4. [Deep Dive](#deep-dive)
5. [Expert Reference](#expert-reference)

---

## Overview

### Core Features

- ✨ Feature 1
- 🎯 Feature 2
- ⚡ Feature 3

### Applicable Scenarios

- Scenario 1
- Scenario 2

### Quick Preview

```Code example```

---

## Quick Start

### Environment Preparation

### Installation

### First Example

### Core Concepts

---

## Complete Example

### Example 1: Basic Usage

### Example 2: Advanced Usage

### Test Cases

---

## Deep Dive

### How It Works

### Best Practices

### Common Pitfalls

---

## Expert Reference

### Complete API

### Source Code Analysis

### Advanced Configuration

---

## Reference Links

- [Related Documentation](ssot://path/to/doc)
- [Example Code](ssot://examples/sample)

---

*Last updated: 2024-01-15*
```

### A.2 SSOT Reference Template

```markdown
## Reference Standards

### Design Standards
- [Color System](ssot://design/color-system)
- [Typography Standards](ssot://design/typography)
- [Spacing System](ssot://design/spacing)

### Component Templates
- [Base Component](ssot://templates/base-component)
- [Form Component](ssot://templates/form-component)
- [List Component](ssot://templates/list-component)

### Configuration Files
- [ESLint Configuration](ssot://config/eslint)
- [Prettier Configuration](ssot://config/prettier)
- [TypeScript Configuration](ssot://config/typescript)
```

### A.3 Script Invocation Template

```markdown
## Script Usage

### Method 1: Command Line

```bash
npx ui-script-name --param1 value1 --param2 value2
```

### Method 2: Configuration File

```javascript
// ui.config.js
module.exports = {
  scripts: {
    scriptName: {
      param1: 'value1',
      param2: 'value2'
    }
  }
};
```

### Method 3: Programmatic

```javascript
const { ScriptName } = require('@rui/scripts');

const script = new ScriptName({
  param1: 'value1',
  param2: 'value2'
});

await script.run();
```
```

### A.4 Output Format Template

```markdown
## Output Formats

### Markdown Format

```markdown
Standard Markdown content
```

### JSON Format

```json
{
  "schema": "https://rui.dev/schemas/v1",
  "metadata": {
    "title": "Example Output",
    "version": "1.0.0"
  },
  "data": {}
}
```

### YAML Format

```yaml
schema: https://rui.dev/schemas/v1
metadata:
  title: Example Output
  version: 1.0.0
data: {}
```
```

---

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.0.0 | 2024-01-15 | Initial version |

---

*Document follows [RUI Skill Standards](ssot://standards/skill-guidelines) v1.0.0*
