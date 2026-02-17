# AI前端开发技能规范

---
title: AI前端开发技能规范
version: 1.0.0
author: RUI Team
date: 2024-01-15
category: development-guidelines
tags: [frontend, ai, skills, standards]
---

## 目录

1. [概述](#概述)
2. [技能文档Frontmatter规范](#技能文档frontmatter规范)
3. [SSOT引用规范](#ssot引用规范)
4. [脚本调用规范](#脚本调用规范)
5. [输出约定格式](#输出约定格式)
6. [多语言/多平台结构规范](#多语言多平台结构规范)
7. [渐进式披露设计原则](#渐进式披露设计原则)
8. [附录：完整模板示例](#附录完整模板示例)

---

## 概述

本文档定义了AI前端开发技能的标准化写作规范，旨在确保所有技能文档的一致性、可维护性和可扩展性。遵循这些规范可以：

- 提高技能文档的可读性和可理解性
- 确保跨平台、跨语言的一致性
- 简化技能维护和版本管理
- 支持自动化处理和验证

### 适用范围

- AI前端开发技能文档
- 技术规范文档
- 开发指南和最佳实践
- 代码示例和模板

---

## 技能文档Frontmatter规范

### 2.1 Frontmatter标准模板

每个技能文档必须以YAML格式的frontmatter开头，包含以下必需字段：

```yaml
---
title: "技能标题"
version: "1.0.0"
author: "作者名"
date: "2024-01-15"
category: "技能分类"
tags: ["标签1", "标签2", "标签3"]
description: "技能的简要描述"
---
```

### 2.2 字段详细说明

| 字段名 | 类型 | 必需 | 说明 |
|--------|------|------|------|
| `title` | string | 是 | 技能标题，简洁明了 |
| `version` | string | 是 | 语义化版本号，格式：主.次.修 |
| `author` | string | 是 | 作者或维护者名称 |
| `date` | string | 是 | 创建或更新日期，ISO 8601格式 |
| `category` | string | 是 | 技能分类，见下方分类列表 |
| `tags` | array | 是 | 关键词标签，3-5个为宜 |
| `description` | string | 否 | 技能的简要描述，100字以内 |
| `deprecated` | boolean | 否 | 是否已弃用 |
| `replaces` | string | 否 | 替代此技能的文档路径 |

### 2.3 技能分类列表

```yaml
categories:
  - frontend-framework    # 前端框架
  - ui-components         # UI组件
  - state-management      # 状态管理
  - styling               # 样式处理
  - build-tools           # 构建工具
  - testing               # 测试
  - performance           # 性能优化
  - accessibility         # 无障碍
  - security              # 安全
  - best-practices        # 最佳实践
```

### 2.4 扩展Frontmatter示例

```yaml
---
title: "React Hooks最佳实践"
version: "2.1.0"
author: "RUI Team"
date: "2024-01-15"
category: "frontend-framework"
tags: ["react", "hooks", "javascript", "best-practices"]
description: "React Hooks的使用规范和最佳实践指南"
prerequisites:
  - "React基础知识"
  - "ES6+语法"
difficulty: "intermediate"  # beginner, intermediate, advanced
time_estimate: "30分钟"
related_skills:
  - "/skills/react-components.md"
  - "/skills/state-management.md"
---
```

---

## SSOT引用规范

### 3.1 SSOT原则

**单一事实来源（Single Source of Truth）** 是确保文档一致性的核心原则。所有重复信息必须通过引用指向原始来源。

### 3.2 SSOT引用格式

#### 3.2.1 基本引用格式

```markdown
<!-- 引用其他文档 -->
参见 [组件设计规范](ssot://design/component-guidelines)

<!-- 引用代码片段 -->
代码示例来自 [基础模板](ssot://templates/base-component#setup-section)

<!-- 引用配置 -->
配置项定义见 [eslint-config](ssot://config/eslint#rules)
```

#### 3.2.2 引用路径规范

```
ssot://{category}/{document-name}[#{section-id}]
```

| 组成部分 | 说明 | 示例 |
|----------|------|------|
| `ssot://` | 协议前缀，表示SSOT引用 | - |
| `{category}` | 文档分类 | `design`, `config`, `templates` |
| `{document-name}` | 文档标识名 | `component-guidelines` |
| `{section-id}` | 可选，锚点ID | `setup-section` |

### 3.3 引用类型定义

```yaml
# SSOT引用类型配置
ssot_types:
  design:          # 设计规范
    path: "/design/"
    description: "UI/UX设计规范"
  
  config:          # 配置文件
    path: "/config/"
    description: "项目配置文件"
  
  templates:       # 代码模板
    path: "/templates/"
    description: "可复用代码模板"
  
  standards:       # 标准规范
    path: "/standards/"
    description: "技术标准文档"
  
  examples:        # 示例代码
    path: "/examples/"
    description: "完整示例项目"
```

### 3.4 SSOT引用示例

```markdown
## 组件开发规范

### 基础结构

组件必须遵循 [基础组件模板](ssot://templates/base-component) 中定义的结构。

### 样式规范

颜色使用参见 [设计系统-色彩](ssot://design/color-system)，
具体色值定义在 [主题配置](ssot://config/theme#colors)。

### ESLint配置

项目使用 [标准ESLint配置](ssot://config/eslint)，
规则覆盖见 [规则覆盖说明](ssot://config/eslint#rule-overrides)。
```

### 3.5 验证SSOT引用

使用以下脚本验证文档中的SSOT引用：

```bash
# 验证所有SSOT引用
node scripts/validate-ssot.js --check-all

# 验证指定文档
node scripts/validate-ssot.js --file path/to/document.md

# 生成SSOT引用报告
node scripts/validate-ssot.js --report
```

---

## 脚本调用规范

### 4.1 三种调用方式

#### 方式一：直接命令调用

适用于简单的、一次性的脚本执行。

```markdown
运行以下命令初始化项目：

```bash
npx create-react-app my-app --template typescript
```

安装依赖：

```bash
npm install @rui/core @rui/hooks
```
```

#### 方式二：配置化脚本调用

适用于需要参数配置的复杂脚本。

```markdown
### 使用配置运行脚本

创建 `ui.config.js`：

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

运行脚本：

```bash
npm run build
npm run dev
```
```

#### 方式三：程序化API调用

适用于需要在代码中集成脚本功能。

```markdown
### 程序化调用

```javascript
const { RUIScripts } = require('@rui/scripts');

const scripts = new RUIScripts({
  configPath: './ui.config.js'
});

// 异步执行脚本
async function runBuild() {
  try {
    const result = await scripts.run('build', {
      verbose: true,
      watch: false
    });
    console.log('构建成功:', result.output);
  } catch (error) {
    console.error('构建失败:', error.message);
  }
}

runBuild();
```
```

### 4.2 脚本调用规范表

| 调用方式 | 适用场景 | 优点 | 缺点 |
|----------|----------|------|------|
| 直接命令 | 简单任务、快速执行 | 简单直观 | 难以复用、参数受限 |
| 配置化 | 复杂任务、团队协作 | 可配置、可版本控制 | 需要配置文件 |
| 程序化 | 集成开发、自动化 | 灵活性高、可编程 | 学习成本较高 |

### 4.3 脚本参数规范

```yaml
# 脚本参数定义规范
script_parameters:
  name:
    type: string
    required: true
    description: "参数名称"
  
  type:
    type: string
    required: true
    enum: [string, number, boolean, array, object]
    description: "参数数据类型"
  
  required:
    type: boolean
    default: false
    description: "是否必需"
  
  default:
    type: any
    description: "默认值"
  
  description:
    type: string
    required: true
    description: "参数说明"
  
  validation:
    type: object
    description: "验证规则"
```

### 4.4 完整脚本示例

```javascript
#!/usr/bin/env node

/**
 * @ui-script generate-component
 * @description 生成标准化组件模板
 * @version 1.0.0
 */

const fs = require('fs');
const path = require('path');

// 参数定义
const PARAMS = {
  name: {
    type: 'string',
    required: true,
    description: '组件名称（PascalCase）'
  },
  type: {
    type: 'string',
    required: false,
    default: 'functional',
    enum: ['functional', 'class'],
    description: '组件类型'
  },
  withStyles: {
    type: 'boolean',
    required: false,
    default: true,
    description: '是否生成样式文件'
  },
  withTests: {
    type: 'boolean',
    required: false,
    default: true,
    description: '是否生成测试文件'
  },
  outputDir: {
    type: 'string',
    required: false,
    default: './src/components',
    description: '输出目录'
  }
};

// 主函数
async function generateComponent(params) {
  const { name, type, withStyles, withTests, outputDir } = params;
  
  // 验证组件名称
  if (!/^[A-Z][a-zA-Z0-9]*$/.test(name)) {
    throw new Error('组件名称必须符合PascalCase规范');
  }
  
  const componentDir = path.join(outputDir, name);
  
  // 创建目录
  if (!fs.existsSync(componentDir)) {
    fs.mkdirSync(componentDir, { recursive: true });
  }
  
  // 生成组件文件
  const componentContent = generateComponentFile(name, type);
  fs.writeFileSync(
    path.join(componentDir, `${name}.tsx`),
    componentContent
  );
  
  // 生成样式文件
  if (withStyles) {
    const stylesContent = generateStylesFile(name);
    fs.writeFileSync(
      path.join(componentDir, `${name}.module.css`),
      stylesContent
    );
  }
  
  // 生成测试文件
  if (withTests) {
    const testContent = generateTestFile(name);
    fs.writeFileSync(
      path.join(componentDir, `${name}.test.tsx`),
      testContent
    );
  }
  
  // 生成索引文件
  const indexContent = `export { default } from './${name}';
export * from './${name}';
`;
  fs.writeFileSync(
    path.join(componentDir, 'index.ts'),
    indexContent
  );
  
  console.log(`✅ 组件 ${name} 生成成功！`);
  console.log(`📁 位置: ${componentDir}`);
}

// 生成组件文件内容
function generateComponentFile(name, type) {
  if (type === 'functional') {
    return `import React from 'react';
import styles from './${name}.module.css';

export interface ${name}Props {
  /** 组件类名 */
  className?: string;
  /** 子元素 */
  children?: React.ReactNode;
}

/**
 * ${name} 组件
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
  
  // Class组件模板
  return `import React, { Component } from 'react';
import styles from './${name}.module.css';

export interface ${name}Props {
  className?: string;
  children?: React.ReactNode;
}

export interface ${name}State {
  // 状态定义
}

/**
 * ${name} 组件
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

// 生成样式文件内容
function generateStylesFile(name) {
  return `/* ${name} 组件样式 */

.container {
  /* 基础样式 */
}
`;
}

// 生成测试文件内容
function generateTestFile(name) {
  return `import React from 'react';
import { render, screen } from '@testing-library/react';
import { ${name} } from './${name}';

describe('${name}', () => {
  it('应该正确渲染', () => {
    render(<${name}>测试内容</${name}>);
    expect(screen.getByText('测试内容')).toBeInTheDocument();
  });
});
`;
}

// CLI入口
if (require.main === module) {
  const args = process.argv.slice(2);
  const params = {};
  
  // 解析参数
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg.startsWith('--')) {
      const key = arg.slice(2);
      const value = args[i + 1];
      
      // 类型转换
      if (value === 'true') params[key] = true;
      else if (value === 'false') params[key] = false;
      else if (!isNaN(Number(value))) params[key] = Number(value);
      else params[key] = value;
      
      i++;
    }
  }
  
  // 验证必需参数
  if (!params.name) {
    console.error('错误: 必须提供 --name 参数');
    process.exit(1);
  }
  
  generateComponent(params).catch(error => {
    console.error('生成失败:', error.message);
    process.exit(1);
  });
}

module.exports = { generateComponent, PARAMS };
```

---

## 输出约定格式

### 5.1 Markdown输出格式

#### 5.1.1 标准结构

```markdown
# 文档标题

---
frontmatter内容
---

## 目录

1. [章节一](#章节一)
2. [章节二](#章节二)

---

## 章节一

### 子章节

内容...

---

## 章节二

内容...

---

## 附录

附加信息...
```

#### 5.1.2 Markdown格式规范

| 元素 | 规范 | 示例 |
|------|------|------|
| 标题 | `#` 到 `######`，一级标题仅一个 | `## 二级标题` |
| 代码块 | 指定语言，带语法高亮 | ```javascript |
| 表格 | 表头必须，对齐可选 | 见上方示例 |
| 列表 | 有序/无序混用需一致 | `-` 或 `1.` |
| 引用 | 使用 `>`，可嵌套 | `> 引用内容` |
| 链接 | 相对路径优先 | `[文本](./path)` |
| 图片 | 带alt文本 | `![alt](./path)` |

### 5.2 JSON输出格式

#### 5.2.1 标准JSON结构

```json
{
  "schema": "https://rui.dev/schemas/skill-output/v1",
  "metadata": {
    "title": "输出标题",
    "version": "1.0.0",
    "generatedAt": "2024-01-15T10:30:00Z",
    "generator": "rui-cli@2.1.0"
  },
  "data": {
    // 实际数据内容
  },
  "errors": [],
  "warnings": []
}
```

#### 5.2.2 JSON Schema定义

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
      "description": "实际输出数据"
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

#### 5.2.3 JSON输出示例

```json
{
  "schema": "https://rui.dev/schemas/skill-output/v1",
  "metadata": {
    "title": "组件分析报告",
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
      "message": "Button组件测试覆盖率低于90%"
    }
  ]
}
```

### 5.3 YAML输出格式

#### 5.3.1 标准YAML结构

```yaml
schema: https://rui.dev/schemas/skill-config/v1

metadata:
  title: 配置标题
  version: 1.0.0
  createdAt: 2024-01-15T10:30:00Z

config:
  # 配置内容

environments:
  development:
    # 开发环境配置
  production:
    # 生产环境配置
```

#### 5.3.2 YAML配置示例

```yaml
schema: https://rui.dev/schemas/component-config/v1

metadata:
  title: Button组件配置
  version: 2.1.0
  author: RUI Team

component:
  name: Button
  displayName: 按钮
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
      description: 按钮样式变体
    
    - name: size
      type: string
      default: medium
      enum:
        - small
        - medium
        - large
      description: 按钮尺寸
    
    - name: disabled
      type: boolean
      default: false
      description: 是否禁用
    
    - name: onClick
      type: function
      description: 点击事件处理函数
  
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

### 5.4 输出格式选择指南

| 场景 | 推荐格式 | 原因 |
|------|----------|------|
| 文档、说明 | Markdown | 可读性强，支持丰富格式 |
| API响应、数据交换 | JSON | 标准化，易于解析 |
| 配置文件 | YAML | 简洁，支持注释 |
| 复杂结构化数据 | JSON/YAML | 支持嵌套和验证 |

---

## 多语言/多平台结构规范

### 6.1 目录结构

```
RUI-agentskills/
├── claude/                    # Claude AI平台
│   ├── en/                   # 英文内容
│   │   ├── skills/          # 技能文档
│   │   ├── templates/       # 代码模板
│   │   ├── examples/        # 示例项目
│   │   └── standards/       # 标准规范
│   └── cn/                  # 中文内容
│       ├── skills/
│       ├── templates/
│       ├── examples/
│       └── standards/
│
├── codex/                     # Codex AI平台
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
├── shared/                    # 共享资源
│   ├── assets/              # 图片、图标等
│   ├── schemas/             # JSON Schema定义
│   ├── configs/             # 共享配置
│   └── translations/        # 翻译文件
│
└── scripts/                   # 自动化脚本
    ├── validate.js          # 验证脚本
    ├── sync.js              # 同步脚本
    └── generate.js          # 生成脚本
```

### 6.2 平台特定规范

#### 6.2.1 Claude平台规范

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
  - 使用XML标签组织复杂内容
  - 支持artifacts功能
  - 遵循Claude特定的提示词规范
```

#### 6.2.2 Codex平台规范

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
  - 代码块需指定完整文件路径
  - 支持行内编辑建议
  - 遵循OpenAI Codex格式
```

### 6.3 内容同步机制

```javascript
// scripts/sync.js
/**
 * 多平台内容同步脚本
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
   * 同步内容到所有目标平台
   */
  async syncAll() {
    const sourceFiles = this.getSourceFiles();
    
    for (const file of sourceFiles) {
      await this.syncFile(file);
    }
  }

  /**
   * 同步单个文件
   */
  async syncFile(sourcePath) {
    const content = fs.readFileSync(sourcePath, 'utf-8');
    const relativePath = path.relative(this.sourceDir, sourcePath);
    
    for (const [platform, targetDir] of Object.entries(this.targetDirs)) {
      // 适配平台特定格式
      const adaptedContent = this.adaptForPlatform(content, platform);
      
      // 应用翻译
      const translatedContent = this.applyTranslation(
        adaptedContent, 
        this.translations[platform]
      );
      
      // 写入目标文件
      const targetPath = path.join(targetDir, relativePath);
      this.ensureDir(path.dirname(targetPath));
      fs.writeFileSync(targetPath, translatedContent);
      
      console.log(`✅ 已同步: ${sourcePath} -> ${targetPath}`);
    }
  }

  /**
   * 适配平台特定格式
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
   * 适配Claude格式
   */
  adaptForClaude(content) {
    // 转换代码块为artifact格式
    return content.replace(
      /```(\w+)\n([\s\S]*?)```/g,
      (match, lang, code) => {
        return `<artifact type="${lang}">\n${code}</artifact>`;
      }
    );
  }

  /**
   * 适配Codex格式
   */
  adaptForCodex(content) {
    // 添加文件路径注释
    return content.replace(
      /```(\w+)\n/g,
      (match, lang) => {
        return `\`\`\`${lang}:path/to/file.ext\n`;
      }
    );
  }

  /**
   * 应用翻译
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

// CLI入口
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

### 6.4 多语言文件命名规范

| 语言 | 代码 | 文件命名示例 |
|------|------|--------------|
| 简体中文 | cn | `document.cn.md` |
| 繁体中文 | tw | `document.tw.md` |
| 英文 | en | `document.en.md` |
| 日文 | ja | `document.ja.md` |
| 韩文 | ko | `document.ko.md` |

---

## 渐进式披露设计原则

### 7.1 渐进式披露概述

渐进式披露（Progressive Disclosure）是一种信息架构策略，通过分层展示信息，帮助用户逐步理解复杂概念，避免认知过载。

### 7.2 五个披露层次

```
┌─────────────────────────────────────────────────────────────┐
│                    渐进式披露金字塔                          │
├─────────────────────────────────────────────────────────────┤
│  第5层: 专家参考 (Expert Reference)                          │
│  └─ 完整API文档、源码、高级配置                               │
├─────────────────────────────────────────────────────────────┤
│  第4层: 深度指南 (Deep Dive)                                 │
│  └─ 详细教程、最佳实践、架构设计                              │
├─────────────────────────────────────────────────────────────┤
│  第3层: 完整示例 (Complete Example)                          │
│  └─ 可运行的完整代码、项目模板                                │
├─────────────────────────────────────────────────────────────┤
│  第2层: 快速开始 (Quick Start)                               │
│  └─ 核心概念、基本用法、最小示例                              │
├─────────────────────────────────────────────────────────────┤
│  第1层: 概览 (Overview)                                      │
│  └─ 简介、特性列表、适用场景                                  │
└─────────────────────────────────────────────────────────────┘
```

### 7.3 各层次详细说明

#### 第1层：概览（Overview）

**目标**：让用户快速了解这是什么、是否适合自己

**内容**：
- 一句话描述
- 核心特性列表
- 适用场景
- 快速预览

**实现方法**：

```markdown
# React Hooks 技能

> 一句话描述：掌握React Hooks的现代开发方式

## 核心特性

- ✨ 函数式组件状态管理
- 🔄 副作用处理
- 🎯 自定义Hook复用逻辑
- ⚡ 性能优化

## 适用场景

- 新项目使用React 16.8+
- 类组件迁移到函数组件
- 需要复用状态逻辑

## 快速预览

```jsx
function Counter() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(c => c + 1)}>{count}</button>;
}
```
```

#### 第2层：快速开始（Quick Start）

**目标**：让用户在5分钟内上手

**内容**：
- 环境准备
- 安装步骤
- 第一个示例
- 核心概念简介

**实现方法**：

```markdown
## 快速开始

### 环境准备

- Node.js 14+
- React 16.8+

### 安装

```bash
npm install @rui/react-hooks
```

### 第一个Hook

```jsx
import { useState } from 'react';

function Example() {
  // 声明状态变量
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>点击了 {count} 次</p>
      <button onClick={() => setCount(count + 1)}>
        点击我
      </button>
    </div>
  );
}
```

### 核心概念

<details>
<summary>useState - 状态管理</summary>

`useState` 让你在函数组件中添加状态。

```jsx
const [state, setState] = useState(initialValue);
```

- `state`: 当前状态值
- `setState`: 更新状态的函数
- `initialValue`: 初始值

</details>
```

#### 第3层：完整示例（Complete Example）

**目标**：提供可运行的完整代码

**内容**：
- 完整功能实现
- 多种使用场景
- 错误处理
- 测试用例

**实现方法**：

```markdown
## 完整示例

### Todo应用

一个完整的Todo应用，展示多个Hooks的组合使用。

```jsx
// TodoApp.jsx
import React, { useState, useEffect, useCallback } from 'react';

function TodoApp() {
  const [todos, setTodos] = useState([]);
  const [inputValue, setInputValue] = useState('');
  const [filter, setFilter] = useState('all');

  // 从本地存储加载
  useEffect(() => {
    const saved = localStorage.getItem('todos');
    if (saved) {
      setTodos(JSON.parse(saved));
    }
  }, []);

  // 保存到本地存储
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
          placeholder="添加新任务..."
        />
        <button onClick={addTodo}>添加</button>
      </div>

      <div className="filter-section">
        <button onClick={() => setFilter('all')}>全部</button>
        <button onClick={() => setFilter('active')}>进行中</button>
        <button onClick={() => setFilter('completed')}>已完成</button>
      </div>

      <ul className="todo-list">
        {filteredTodos.map(todo => (
          <li key={todo.id} className={todo.completed ? 'completed' : ''}>
            <span onClick={() => toggleTodo(todo.id)}>
              {todo.text}
            </span>
            <button onClick={() => deleteTodo(todo.id)}>删除</button>
          </li>
        ))}
      </ul>

      <div className="stats">
        总计: {todos.length} | 
        已完成: {todos.filter(t => t.completed).length} | 
        待办: {todos.filter(t => !t.completed).length}
      </div>
    </div>
  );
}

export default TodoApp;
```

### 测试用例

```jsx
// TodoApp.test.jsx
import { render, screen, fireEvent } from '@testing-library/react';
import TodoApp from './TodoApp';

describe('TodoApp', () => {
  it('应该能添加任务', () => {
    render(<TodoApp />);
    
    const input = screen.getByPlaceholderText('添加新任务...');
    const button = screen.getByText('添加');
    
    fireEvent.change(input, { target: { value: '测试任务' } });
    fireEvent.click(button);
    
    expect(screen.getByText('测试任务')).toBeInTheDocument();
  });

  it('应该能切换任务状态', () => {
    render(<TodoApp />);
    
    // 添加任务
    const input = screen.getByPlaceholderText('添加新任务...');
    fireEvent.change(input, { target: { value: '测试任务' } });
    fireEvent.click(screen.getByText('添加'));
    
    // 切换状态
    fireEvent.click(screen.getByText('测试任务'));
    
    expect(screen.getByText('已完成: 1')).toBeInTheDocument();
  });
});
```
```

#### 第4层：深度指南（Deep Dive）

**目标**：深入理解原理和最佳实践

**内容**：
- 工作原理详解
- 性能优化技巧
- 常见陷阱
- 设计模式

**实现方法**：

```markdown
## 深度指南

### useEffect工作原理

<details>
<summary>点击查看详细解释</summary>

`useEffect` 在每次渲染后执行，通过依赖数组控制执行时机：

```
渲染阶段 -> 提交阶段 -> 执行effect
```

#### 执行时机对比

| 场景 | 执行时机 |
|------|----------|
| 无依赖数组 | 每次渲染后 |
| 空数组 `[]` | 仅挂载和卸载 |
| 有依赖 `[a, b]` | 依赖变化时 |

#### 清理函数

```jsx
useEffect(() => {
  const subscription = props.source.subscribe();
  
  // 返回清理函数
  return () => {
    subscription.unsubscribe();
  };
}, [props.source]);
```

</details>

### 性能优化

#### 1. 使用useMemo缓存计算

```jsx
const expensiveValue = useMemo(() => {
  return data.filter(item => item.active)
    .map(item => processItem(item))
    .reduce((sum, item) => sum + item.value, 0);
}, [data]);
```

#### 2. 使用useCallback稳定函数引用

```jsx
const handleClick = useCallback(() => {
  doSomething(a, b);
}, [a, b]);
```

### 常见陷阱

<details>
<summary>陷阱1：闭包陷阱</summary>

```jsx
// ❌ 错误：使用旧的状态值
function Counter() {
  const [count, setCount] = useState(0);
  
  useEffect(() => {
    const timer = setInterval(() => {
      console.log(count); // 始终是0
      setCount(count + 1); // 始终是1
    }, 1000);
    return () => clearInterval(timer);
  }, []); // 依赖数组为空
  
  return <div>{count}</div>;
}

// ✅ 正确：使用函数式更新
function Counter() {
  const [count, setCount] = useState(0);
  
  useEffect(() => {
    const timer = setInterval(() => {
      setCount(c => c + 1); // 使用最新值
    }, 1000);
    return () => clearInterval(timer);
  }, []);
  
  return <div>{count}</div>;
}
```

</details>

### 自定义Hook设计模式

#### 模式1：数据获取Hook

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

#### 第5层：专家参考（Expert Reference）

**目标**：提供完整的参考信息

**内容**：
- 完整API文档
- 源码分析
- 高级配置选项
- 贡献指南

**实现方法**：

```markdown
## 专家参考

### 完整API

#### useState

```typescript
function useState<S>(
  initialState: S | (() => S)
): [S, Dispatch<SetStateAction<S>>];
```

**类型参数**

| 参数 | 说明 |
|------|------|
| `S` | 状态类型 |

**参数**

| 参数 | 类型 | 说明 |
|------|------|------|
| `initialState` | `S \| (() => S)` | 初始状态值或工厂函数 |

**返回值**

| 索引 | 类型 | 说明 |
|------|------|------|
| `[0]` | `S` | 当前状态值 |
| `[1]` | `Dispatch<SetStateAction<S>>` | 状态更新函数 |

### 源码解析

<details>
<summary>useState实现原理</summary>

React内部使用链表结构存储Hook状态：

```javascript
// 简化版实现
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

### 高级配置

```javascript
// react.config.js
module.exports = {
  hooks: {
    // 启用严格模式检查
    strictMode: true,
    
    // 自定义Hook前缀
    prefix: 'use',
    
    // 性能监控
    profiling: {
      enabled: process.env.NODE_ENV === 'development',
      threshold: 16 // 毫秒
    },
    
    // 实验性功能
    experimental: {
      useId: true,
      useTransition: true,
      useDeferredValue: true
    }
  }
};
```

### 贡献指南

1. Fork仓库
2. 创建功能分支
3. 提交更改
4. 创建Pull Request

详见 [CONTRIBUTING.md](./CONTRIBUTING.md)
```

### 7.4 渐进式披露实现技巧

#### 使用折叠面板

```markdown
<details>
<summary>点击展开详细内容</summary>

这里是详细内容...

</details>
```

#### 使用标签页

```markdown
<!-- 使用HTML实现标签页 -->
<div class="tabs">
  <input type="radio" name="tab" id="tab1" checked>
  <label for="tab1">基础用法</label>
  <div class="tab-content">
    基础用法内容...
  </div>
  
  <input type="radio" name="tab" id="tab2">
  <label for="tab2">高级用法</label>
  <div class="tab-content">
    高级用法内容...
  </div>
</div>
```

#### 使用步骤指示器

```markdown
## 学习路径

1. ✅ [概览](#概览) - 了解基本概念
2. ⏳ [快速开始](#快速开始) - 动手实践
3. 🔒 [完整示例](#完整示例) - 深入理解
4. 🔒 [深度指南](#深度指南) - 掌握原理
5. 🔒 [专家参考](#专家参考) - 成为专家
```

---

## 附录：完整模板示例

### A.1 技能文档完整模板

```markdown
---
title: "技能标题"
version: "1.0.0"
author: "作者名"
date: "2024-01-15"
category: "技能分类"
tags: ["标签1", "标签2", "标签3"]
description: "技能的简要描述"
prerequisites:
  - "前置技能1"
  - "前置技能2"
difficulty: "beginner"
time_estimate: "30分钟"
---

# 技能标题

> 一句话描述技能的核心价值

## 目录

1. [概览](#概览)
2. [快速开始](#快速开始)
3. [完整示例](#完整示例)
4. [深度指南](#深度指南)
5. [专家参考](#专家参考)

---

## 概览

### 核心特性

- ✨ 特性1
- 🎯 特性2
- ⚡ 特性3

### 适用场景

- 场景1
- 场景2

### 快速预览

```代码示例```

---

## 快速开始

### 环境准备

### 安装

### 第一个示例

### 核心概念

---

## 完整示例

### 示例1：基础用法

### 示例2：进阶用法

### 测试用例

---

## 深度指南

### 工作原理

### 最佳实践

### 常见陷阱

---

## 专家参考

### 完整API

### 源码解析

### 高级配置

---

## 参考链接

- [相关文档](ssot://path/to/doc)
- [示例代码](ssot://examples/sample)

---

*最后更新: 2024-01-15*
```

### A.2 SSOT引用模板

```markdown
## 引用规范

### 设计规范
- [色彩系统](ssot://design/color-system)
- [排版规范](ssot://design/typography)
- [间距系统](ssot://design/spacing)

### 组件模板
- [基础组件](ssot://templates/base-component)
- [表单组件](ssot://templates/form-component)
- [列表组件](ssot://templates/list-component)

### 配置文件
- [ESLint配置](ssot://config/eslint)
- [Prettier配置](ssot://config/prettier)
- [TypeScript配置](ssot://config/typescript)
```

### A.3 脚本调用模板

```markdown
## 脚本使用

### 方式一：命令行

```bash
npx ui-script-name --param1 value1 --param2 value2
```

### 方式二：配置文件

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

### 方式三：程序化

```javascript
const { ScriptName } = require('@rui/scripts');

const script = new ScriptName({
  param1: 'value1',
  param2: 'value2'
});

await script.run();
```
```

### A.4 输出格式模板

```markdown
## 输出格式

### Markdown格式

```markdown
标准Markdown内容
```

### JSON格式

```json
{
  "schema": "https://rui.dev/schemas/v1",
  "metadata": {
    "title": "示例输出",
    "version": "1.0.0"
  },
  "data": {}
}
```

### YAML格式

```yaml
schema: https://rui.dev/schemas/v1
metadata:
  title: 示例输出
  version: 1.0.0
data: {}
```
```

---

## 版本历史

| 版本 | 日期 | 说明 |
|------|------|------|
| 1.0.0 | 2024-01-15 | 初始版本 |

---

*文档遵循 [RUI技能规范](ssot://standards/skill-guidelines) v1.0.0*
