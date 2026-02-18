# UI 自评估规范

> **文档版本**: 1.0  
> **适用范围**: Claude Code UI 生成任务  
> **最后更新**: 2024

---

## 概述

本文档定义了 Claude Code 在生成 UI 代码后的自评估流程，确保输出质量符合生产标准。自评估采用**四步自审法**，结合**加权评分模型**，最终输出结构化的评估报告。

---

## 一、四步自审流程

### 1.1 代码自审（Code Review）

代码自审关注技术实现的正确性和规范性。

#### 1.1.1 语法检查

| 检查项 | 检查内容 | 通过标准 |
|--------|----------|----------|
| HTML 语法 | 标签闭合、属性引号、嵌套层级 | 无语法错误，W3C 验证通过 |
| CSS 语法 | 选择器、属性值、分号闭合 | 无语法错误，可正常解析 |
| JavaScript 语法 | ES6+ 语法、括号匹配、分号 | ESLint 无报错 |
| TypeScript 类型 | 类型定义、接口、泛型 | `tsc --noEmit` 通过 |

#### 1.1.2 类型检查

```typescript
// 类型自审示例清单
interface TypeCheckList {
  // 1. 组件 Props 类型是否完整定义
  propsTypesDefined: boolean;
  
  // 2. 事件处理函数参数类型是否正确
  eventHandlerTypes: boolean;
  
  // 3. 状态管理类型是否明确
  stateTypes: boolean;
  
  // 4. API 响应数据类型是否定义
  apiResponseTypes: boolean;
  
  // 5. 第三方库类型声明是否存在
  thirdPartyTypes: boolean;
}
```

#### 1.1.3 结构检查

| 检查维度 | 具体要求 |
|----------|----------|
| 组件拆分 | 单一职责原则，组件粒度适中 |
| 文件组织 | 按功能/类型分层，目录结构清晰 |
| 依赖管理 | 无循环依赖，外部依赖最小化 |
| 代码复用 | 公共逻辑提取为 hooks/工具函数 |
| 模块边界 | 接口清晰，内部实现封装良好 |

#### 1.1.4 命名规范

```
命名规则检查清单:
├── 组件名: PascalCase (如: UserProfile)
├── 变量名: camelCase (如: userName)
├── 常量名: UPPER_SNAKE_CASE (如: MAX_RETRY_COUNT)
├── 布尔变量: 使用 is/has/should 前缀 (如: isLoading)
├── 事件处理: handle + 动作 (如: handleSubmit)
├── 样式类名: kebab-case (如: user-profile)
├── 文件命名: 与导出组件名一致
└── 测试文件: [name].test.ts 或 [name].spec.ts
```

---

### 1.2 视觉自审（Visual Review）

视觉自审确保界面符合设计规范和用户体验标准。

#### 1.2.1 层级检查

```
视觉层级检查框架:
├── 信息层级
│   ├── 主标题: H1，最大字号，最高权重
│   ├── 副标题: H2-H3，次级字号
│   ├── 正文: body，标准字号
│   └── 辅助信息: caption/small，最小字号
├── 视觉权重
│   ├── 核心操作: 主色按钮，高对比度
│   ├── 次要操作: 次级按钮，中等对比度
│   ├── 辅助操作: 文字链接，低对比度
│   └── 禁用状态: 灰度，最低对比度
└── 空间层级
    ├── 模态层: z-index 最高 (1000+)
    ├── 浮层: z-index 高 (100-999)
    ├── 导航: z-index 中 (10-99)
    └── 内容: z-index 基础 (1-9)
```

#### 1.2.2 色彩检查

| 检查项 | 检查内容 | 标准 |
|--------|----------|------|
| 主色使用 | 品牌色应用一致性 | 主色占比 60%，用于核心元素 |
| 辅助色 | 功能色（成功/警告/错误/信息） | 符合 WCAG 对比度标准 |
| 中性色 | 灰阶层次 | 至少 8 级灰度（100-900） |
| 对比度 | 文字与背景对比 | WCAG AA 标准（4.5:1） |
| 暗色模式 | 颜色反转适配 | 所有颜色有对应的 dark 值 |

#### 1.2.3 排版检查

```css
/* 排版检查模板 */
.typography-check {
  /* 字体栈 */
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  
  /* 字号阶梯 */
  --text-xs: 0.75rem;    /* 12px */
  --text-sm: 0.875rem;   /* 14px */
  --text-base: 1rem;     /* 16px */
  --text-lg: 1.125rem;   /* 18px */
  --text-xl: 1.25rem;    /* 20px */
  --text-2xl: 1.5rem;    /* 24px */
  --text-3xl: 1.875rem;  /* 30px */
  
  /* 行高 */
  --leading-tight: 1.25;
  --leading-normal: 1.5;
  --leading-relaxed: 1.625;
  
  /* 字重 */
  --font-normal: 400;
  --font-medium: 500;
  --font-semibold: 600;
  --font-bold: 700;
}
```

#### 1.2.4 间距检查

```
间距系统检查 (8px 基准):
├── 基础单位: 4px
├── 常用间距:
│   ├── xs: 4px   (0.25rem)
│   ├── sm: 8px   (0.5rem)
│   ├── md: 16px  (1rem)
│   ├── lg: 24px  (1.5rem)
│   ├── xl: 32px  (2rem)
│   ├── 2xl: 48px (3rem)
│   └── 3xl: 64px (4rem)
├── 内边距检查:
│   ├── 按钮: 垂直 8-12px，水平 16-24px
│   ├── 卡片: 16-24px
│   └── 表单输入: 12-16px
└── 外边距检查:
    ├── 段落间距: 1.5em
    ├── 组件间距: 16-24px
    └── 区块间距: 48-64px
```

---

### 1.3 交互自审（Interaction Review）

交互自审确保用户操作的反馈及时、明确、流畅。

#### 1.3.1 状态检查

```typescript
// 组件状态完整清单
interface ComponentStates {
  // 默认状态
  default: {
    visible: true;
    interactive: true;
  };
  
  // 悬停状态
  hover: {
    cursor: 'pointer';
    background: 'lighten 5%';
    transform?: 'scale(1.02)';
  };
  
  // 聚焦状态
  focus: {
    outline: '2px solid primary';
    outlineOffset: '2px';
  };
  
  // 激活/按下状态
  active: {
    transform: 'scale(0.98)';
    background: 'darken 10%';
  };
  
  // 禁用状态
  disabled: {
    opacity: 0.5;
    cursor: 'not-allowed';
    pointerEvents: 'none';
  };
  
  // 加载状态
  loading: {
    spinner: true;
    text: '处理中...';
    disabled: true;
  };
  
  // 错误状态
  error: {
    borderColor: 'error';
    message: string;
    icon: 'error-icon';
  };
  
  // 成功状态
  success: {
    borderColor: 'success';
    message: string;
    icon: 'success-icon';
  };
}
```

#### 1.3.2 反馈检查

| 交互类型 | 反馈方式 | 响应时间 |
|----------|----------|----------|
| 点击按钮 | 视觉变化 + 可能的加载状态 | < 100ms |
| 表单提交 | 加载指示器 + 成功/错误提示 | < 300ms |
| 数据加载 | 骨架屏/加载动画 | 立即显示 |
| 操作成功 | Toast/Notification | 2-3 秒后自动消失 |
| 操作错误 | 错误提示 + 恢复建议 | 常驻直到处理 |
| 网络异常 | 离线提示 + 重试机制 | 立即显示 |

#### 1.3.3 动效检查

```css
/* 动效检查标准 */
.motion-check {
  /* 时长标准 */
  --duration-instant: 0ms;      /* 即时响应 */
  --duration-fast: 150ms;       /* 微交互 */
  --duration-normal: 300ms;     /* 标准过渡 */
  --duration-slow: 500ms;       /* 强调动画 */
  
  /* 缓动函数 */
  --ease-linear: linear;
  --ease-in: cubic-bezier(0.4, 0, 1, 1);
  --ease-out: cubic-bezier(0, 0, 0.2, 1);
  --ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);
  
  /* 性能要求 */
  will-change: transform, opacity;
  transform: translateZ(0); /* 启用 GPU 加速 */
}
```

**动效检查清单**:

- [ ] 所有过渡动画使用 `transform` 和 `opacity`
- [ ] 动画时长符合标准（150ms-500ms）
- [ ] 支持 `prefers-reduced-motion` 媒体查询
- [ ] 60fps 流畅运行，无卡顿
- [ ] 动画有明确的开始和结束状态

---

### 1.4 审美自审（Aesthetic Review）

审美自审评估设计的整体品质和品牌一致性。

#### 1.4.1 现代感检查

| 维度 | 现代设计特征 | 检查要点 |
|------|--------------|----------|
| 设计语言 | 简洁、扁平、适度圆角 | 避免过度装饰 |
| 阴影运用 | 微妙、有层次 | 使用 CSS 变量控制 |
| 留白处理 | 充足、有呼吸感 | 不拥挤、不空洞 |
| 图标风格 | 线性/填充统一 | 粗细、圆角一致 |
| 图片处理 | 高质量、适当滤镜 | 统一色调风格 |

#### 1.4.2 完成度检查

```
完成度评估维度 (满分 10 分):
├── 视觉完整性 (2.5分)
│   ├── 所有设计元素已实现
│   ├── 无占位符或临时内容
│   └── 边缘情况已处理
├── 交互完整性 (2.5分)
│   ├── 所有交互路径可访问
│   ├── 错误状态已处理
│   └── 空状态已设计
├── 响应式完整性 (2.5分)
│   ├── 移动端适配完成
│   ├── 平板适配完成
│   └── 断点切换平滑
└── 细节完善度 (2.5分)
    ├── 微交互到位
    ├── 加载状态完善
    └── 无障碍支持完整
```

#### 1.4.3 品牌调性检查

| 检查项 | 说明 | 示例 |
|--------|------|------|
| 品牌色应用 | 主色、辅助色使用正确 | Logo 色、强调色 |
| 品牌字体 | 使用品牌指定字体 | 标题字体、正文字体 |
| 品牌语气 | 文案风格一致 | 专业/友好/活泼 |
| 品牌元素 | Logo、图标使用规范 | 尺寸、位置、留白 |
| 整体感觉 | 与品牌定位匹配 | 高端/亲民/科技感 |

---

## 二、评分权重模型

### 2.1 权重分配

| 维度 | 权重 | 说明 |
|------|------|------|
| **完整性** | 30% | 功能实现完整度、边界情况处理 |
| **美学** | 25% | 视觉设计质量、品牌一致性 |
| **可维护性** | 25% | 代码结构、文档、测试覆盖 |
| **性能** | 20% | 加载速度、运行时性能、资源优化 |

### 2.2 计算公式

```
总评分计算公式:

总分 = (完整性得分 × 0.30) + 
       (美学得分 × 0.25) + 
       (可维护性得分 × 0.25) + 
       (性能得分 × 0.20)

其中各维度得分范围: 0-100

示例计算:
完整性: 85分 → 85 × 0.30 = 25.5
美学: 90分 → 90 × 0.25 = 22.5
可维护性: 80分 → 80 × 0.25 = 20.0
性能: 75分 → 75 × 0.20 = 15.0
─────────────────────────────────
总分: 83.0分 (良好)
```

### 2.3 各维度评分细则

#### 2.3.1 完整性评分 (30%)

| 子项 | 分值 | 评分标准 |
|------|------|----------|
| 功能完整 | 10分 | 所有需求功能已实现 |
| 边界处理 | 8分 | 空状态、错误状态、极限值处理 |
| 响应式适配 | 7分 | 多设备、多分辨率适配 |
| 兼容性 | 5分 | 主流浏览器兼容 |

#### 2.3.2 美学评分 (25%)

| 子项 | 分值 | 评分标准 |
|------|------|----------|
| 视觉设计 | 10分 | 布局、色彩、排版协调 |
| 品牌一致 | 7分 | 符合品牌调性 |
| 细节精致 | 5分 | 微交互、动效精细 |
| 现代感 | 3分 | 符合当前设计趋势 |

#### 2.3.3 可维护性评分 (25%)

| 子项 | 分值 | 评分标准 |
|------|------|----------|
| 代码结构 | 10分 | 组件化、模块化良好 |
| 命名规范 | 5分 | 命名清晰、一致 |
| 注释文档 | 5分 | 关键逻辑有注释 |
| 类型安全 | 5分 | TypeScript 类型完整 |

#### 2.3.4 性能评分 (20%)

| 子项 | 分值 | 评分标准 |
|------|------|----------|
| 加载性能 | 8分 | 首屏加载 < 3s |
| 运行时性能 | 6分 | 交互响应 < 100ms |
| 资源优化 | 4分 | 图片、代码压缩优化 |
| 可访问性 | 2分 | 支持键盘、屏幕阅读器 |

---

## 三、分档结论标准

### 3.1 评分等级划分

```
评分等级体系:

┌─────────────────────────────────────────────────────┐
│  优秀  │  >= 90分  │  ████████████████████ 90-100  │
├─────────────────────────────────────────────────────┤
│  良好  │  80-89分  │  ██████████████████░░ 80-89   │
├─────────────────────────────────────────────────────┤
│  合格  │  70-79分  │  ███████████████░░░░░ 70-79   │
├─────────────────────────────────────────────────────┤
│ 待改进 │  60-69分  │  █████████████░░░░░░░ 60-69   │
├─────────────────────────────────────────────────────┤
│ 不合格 │   < 60分  │  ██████████░░░░░░░░░░ <60     │
└─────────────────────────────────────────────────────┘
```

### 3.2 各等级详细标准

#### 3.2.1 优秀 (>= 90分)

| 维度 | 要求 |
|------|------|
| 代码质量 | 零警告，符合最佳实践 |
| 视觉设计 | 专业级，细节精致 |
| 交互体验 | 流畅自然，反馈及时 |
| 文档完整 | 包含使用说明和 API 文档 |
| 测试覆盖 | 核心功能有测试 |

**结论**: 可直接用于生产环境，可作为团队标杆

#### 3.2.2 良好 (80-89分)

| 维度 | 要求 |
|------|------|
| 代码质量 | 少量风格问题，无功能缺陷 |
| 视觉设计 | 整体协调，个别细节可优化 |
| 交互体验 | 基本流畅，部分动效可增强 |
| 文档完整 | 关键部分有注释 |
| 测试覆盖 | 主要路径已覆盖 |

**结论**: 可用于生产环境，建议小范围优化

#### 3.2.3 合格 (70-79分)

| 维度 | 要求 |
|------|------|
| 代码质量 | 有优化空间，功能正常 |
| 视觉设计 | 基本可用，需视觉走查 |
| 交互体验 | 核心功能可用，边缘情况待处理 |
| 文档完整 | 基础注释存在 |
| 测试覆盖 | 手动测试通过 |

**结论**: 需要优化后使用，建议进行代码审查

#### 3.2.4 待改进 (60-69分)

| 维度 | 要求 |
|------|------|
| 代码质量 | 有明显问题，需重构 |
| 视觉设计 | 与预期有差距 |
| 交互体验 | 部分功能不可用 |
| 文档完整 | 缺乏必要注释 |
| 测试覆盖 | 未进行系统测试 |

**结论**: 需要显著改进，建议重新设计或重构

#### 3.2.5 不合格 (< 60分)

| 维度 | 要求 |
|------|------|
| 代码质量 | 存在严重问题 |
| 视觉设计 | 不符合基本要求 |
| 交互体验 | 核心功能缺失 |
| 文档完整 | 无文档 |
| 测试覆盖 | 未测试 |

**结论**: 不可使用，需要重新开发

---

## 四、重构触发规则

### 4.1 触发场景

#### 场景一：评分触发

```
触发条件:
├── 总分 < 70分 (合格线以下)
│   └── 触发完整重构流程
├── 任一维度得分 < 50分
│   └── 触发该维度专项重构
└── 连续两次评估 < 80分
    └── 触发设计审查会议
```

#### 场景二：问题类型触发

| 问题级别 | 触发条件 | 处理方式 |
|----------|----------|----------|
| **致命** | 功能完全不可用 | 立即重构 |
| **严重** | 核心功能缺陷 | 24小时内重构 |
| **中等** | 影响用户体验 | 下次迭代修复 |
| **轻微** | 代码风格问题 | 可选优化 |

#### 场景三：阈值触发

```
专项重构触发阈值:

性能维度:
├── 首屏加载 > 5秒
├── 交互响应 > 500ms
├── 内存泄漏检测失败
└── Lighthouse 性能评分 < 60

可维护性维度:
├── 代码重复率 > 20%
├── 圈复杂度 > 15
├── 文件行数 > 500
└── 无类型定义覆盖率 < 80%

美学维度:
├── WCAG 对比度检查失败
├── 移动端适配问题 > 3处
└── 设计稿还原度 < 85%
```

### 4.2 重构流程

```
重构决策流程图:

开始评估
    │
    ▼
计算总分 ──< >= 70? >──┬── 是 ──> 检查各维度
    │                  │
    否                 ▼
    │           是否有维度 < 50?
    ▼                  │
完整重构 <── 是 ──────┴── 否 ──> 通过评估
    │
    ▼
生成重构计划
    │
    ├── 确定重构范围
    ├── 制定时间计划
    ├── 分配资源
    └── 设定验收标准
```

### 4.3 重构优先级

| 优先级 | 条件 | 处理时限 |
|--------|------|----------|
| P0 - 紧急 | 功能完全不可用 | 立即 |
| P1 - 高 | 核心功能受影响 | 24小时 |
| P2 - 中 | 用户体验受损 | 本周 |
| P3 - 低 | 优化建议 | 下次迭代 |

---

## 五、self-eval.scorecard.json 格式规范

### 5.1 完整格式定义

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "UI Self Evaluation Scorecard",
  "type": "object",
  "required": [
    "version",
    "timestamp",
    "component",
    "scores",
    "totalScore",
    "grade",
    "findings",
    "recommendations"
  ],
  "properties": {
    "version": {
      "type": "string",
      "description": "评分卡版本号",
      "example": "1.0.0"
    },
    "timestamp": {
      "type": "string",
      "format": "date-time",
      "description": "评估时间戳"
    },
    "component": {
      "type": "object",
      "required": ["name", "type", "path"],
      "properties": {
        "name": {
          "type": "string",
          "description": "组件名称"
        },
        "type": {
          "type": "string",
          "enum": ["page", "component", "layout", "template"],
          "description": "组件类型"
        },
        "path": {
          "type": "string",
          "description": "组件文件路径"
        },
        "description": {
          "type": "string",
          "description": "组件功能描述"
        }
      }
    },
    "scores": {
      "type": "object",
      "required": ["completeness", "aesthetics", "maintainability", "performance"],
      "properties": {
        "completeness": {
          "type": "object",
          "properties": {
            "score": {
              "type": "number",
              "minimum": 0,
              "maximum": 100
            },
            "weight": {
              "type": "number",
              "default": 0.30
            },
            "weightedScore": {
              "type": "number"
            },
            "breakdown": {
              "type": "object",
              "properties": {
                "functionality": { "type": "number" },
                "edgeCases": { "type": "number" },
                "responsive": { "type": "number" },
                "compatibility": { "type": "number" }
              }
            },
            "issues": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "item": { "type": "string" },
                  "severity": {
                    "type": "string",
                    "enum": ["critical", "major", "minor", "info"]
                  },
                  "description": { "type": "string" }
                }
              }
            }
          }
        },
        "aesthetics": {
          "type": "object",
          "properties": {
            "score": {
              "type": "number",
              "minimum": 0,
              "maximum": 100
            },
            "weight": {
              "type": "number",
              "default": 0.25
            },
            "weightedScore": {
              "type": "number"
            },
            "breakdown": {
              "type": "object",
              "properties": {
                "visualDesign": { "type": "number" },
                "brandConsistency": { "type": "number" },
                "details": { "type": "number" },
                "modernity": { "type": "number" }
              }
            },
            "issues": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "item": { "type": "string" },
                  "severity": {
                    "type": "string",
                    "enum": ["critical", "major", "minor", "info"]
                  },
                  "description": { "type": "string" }
                }
              }
            }
          }
        },
        "maintainability": {
          "type": "object",
          "properties": {
            "score": {
              "type": "number",
              "minimum": 0,
              "maximum": 100
            },
            "weight": {
              "type": "number",
              "default": 0.25
            },
            "weightedScore": {
              "type": "number"
            },
            "breakdown": {
              "type": "object",
              "properties": {
                "codeStructure": { "type": "number" },
                "naming": { "type": "number" },
                "documentation": { "type": "number" },
                "typeSafety": { "type": "number" }
              }
            },
            "issues": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "item": { "type": "string" },
                  "severity": {
                    "type": "string",
                    "enum": ["critical", "major", "minor", "info"]
                  },
                  "description": { "type": "string" }
                }
              }
            }
          }
        },
        "performance": {
          "type": "object",
          "properties": {
            "score": {
              "type": "number",
              "minimum": 0,
              "maximum": 100
            },
            "weight": {
              "type": "number",
              "default": 0.20
            },
            "weightedScore": {
              "type": "number"
            },
            "breakdown": {
              "type": "object",
              "properties": {
                "loadPerformance": { "type": "number" },
                "runtimePerformance": { "type": "number" },
                "resourceOptimization": { "type": "number" },
                "accessibility": { "type": "number" }
              }
            },
            "issues": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "item": { "type": "string" },
                  "severity": {
                    "type": "string",
                    "enum": ["critical", "major", "minor", "info"]
                  },
                  "description": { "type": "string" }
                }
              }
            }
          }
        }
      }
    },
    "totalScore": {
      "type": "number",
      "minimum": 0,
      "maximum": 100,
      "description": "加权总分"
    },
    "grade": {
      "type": "string",
      "enum": ["excellent", "good", "pass", "needs-improvement", "fail"],
      "description": "评分等级"
    },
    "findings": {
      "type": "array",
      "description": "发现的问题列表",
      "items": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string",
            "description": "问题唯一标识"
          },
          "category": {
            "type": "string",
            "enum": ["code", "visual", "interaction", "aesthetic"],
            "description": "问题类别"
          },
          "severity": {
            "type": "string",
            "enum": ["critical", "major", "minor", "info"],
            "description": "严重程度"
          },
          "title": {
            "type": "string",
            "description": "问题标题"
          },
          "description": {
            "type": "string",
            "description": "问题详细描述"
          },
          "location": {
            "type": "string",
            "description": "问题位置（文件路径/行号）"
          },
          "suggestion": {
            "type": "string",
            "description": "改进建议"
          }
        }
      }
    },
    "recommendations": {
      "type": "array",
      "description": "优化建议列表",
      "items": {
        "type": "object",
        "properties": {
          "priority": {
            "type": "string",
            "enum": ["high", "medium", "low"],
            "description": "优先级"
          },
          "category": {
            "type": "string",
            "enum": ["code", "visual", "interaction", "aesthetic", "performance"],
            "description": "建议类别"
          },
          "description": {
            "type": "string",
            "description": "建议描述"
          },
          "effort": {
            "type": "string",
            "enum": ["small", "medium", "large"],
            "description": "预计工作量"
          },
          "impact": {
            "type": "string",
            "enum": ["low", "medium", "high"],
            "description": "预期影响"
          }
        }
      }
    },
    "refactorRequired": {
      "type": "boolean",
      "description": "是否需要重构"
    },
    "refactorScope": {
      "type": "string",
      "enum": ["none", "partial", "full"],
      "description": "重构范围"
    },
    "reviewNotes": {
      "type": "string",
      "description": "评审备注"
    }
  }
}
```

### 5.2 示例评分卡

```json
{
  "version": "1.0.0",
  "timestamp": "2024-01-15T10:30:00Z",
  "component": {
    "name": "UserProfileCard",
    "type": "component",
    "path": "/src/components/UserProfileCard.tsx",
    "description": "用户资料展示卡片组件"
  },
  "scores": {
    "completeness": {
      "score": 85,
      "weight": 0.30,
      "weightedScore": 25.5,
      "breakdown": {
        "functionality": 90,
        "edgeCases": 80,
        "responsive": 85,
        "compatibility": 85
      },
      "issues": [
        {
          "item": "空头像处理",
          "severity": "minor",
          "description": "未提供头像时的默认展示可优化"
        }
      ]
    },
    "aesthetics": {
      "score": 90,
      "weight": 0.25,
      "weightedScore": 22.5,
      "breakdown": {
        "visualDesign": 92,
        "brandConsistency": 88,
        "details": 90,
        "modernity": 90
      },
      "issues": []
    },
    "maintainability": {
      "score": 80,
      "weight": 0.25,
      "weightedScore": 20.0,
      "breakdown": {
        "codeStructure": 85,
        "naming": 80,
        "documentation": 75,
        "typeSafety": 80
      },
      "issues": [
        {
          "item": "缺少 JSDoc 注释",
          "severity": "minor",
          "description": "主要接口缺少文档说明"
        }
      ]
    },
    "performance": {
      "score": 75,
      "weight": 0.20,
      "weightedScore": 15.0,
      "breakdown": {
        "loadPerformance": 80,
        "runtimePerformance": 75,
        "resourceOptimization": 70,
        "accessibility": 75
      },
      "issues": [
        {
          "item": "图片未懒加载",
          "severity": "major",
          "description": "头像图片应使用懒加载优化"
        }
      ]
    }
  },
  "totalScore": 83.0,
  "grade": "good",
  "findings": [
    {
      "id": "F001",
      "category": "visual",
      "severity": "minor",
      "title": "空状态展示",
      "description": "用户未上传头像时，默认占位符样式可优化",
      "location": "UserProfileCard.tsx:45",
      "suggestion": "使用品牌色首字母头像作为默认展示"
    },
    {
      "id": "F002",
      "category": "performance",
      "severity": "major",
      "title": "图片加载优化",
      "description": "头像图片未实现懒加载，影响首屏性能",
      "location": "UserProfileCard.tsx:32",
      "suggestion": "使用 Intersection Observer 实现图片懒加载"
    }
  ],
  "recommendations": [
    {
      "priority": "high",
      "category": "performance",
      "description": "实现头像图片懒加载",
      "effort": "small",
      "impact": "high"
    },
    {
      "priority": "medium",
      "category": "code",
      "description": "补充组件 JSDoc 文档",
      "effort": "small",
      "impact": "medium"
    },
    {
      "priority": "low",
      "category": "visual",
      "description": "优化空头像默认展示",
      "effort": "small",
      "impact": "low"
    }
  ],
  "refactorRequired": false,
  "refactorScope": "none",
  "reviewNotes": "整体质量良好，建议优先处理图片懒加载问题"
}
```

---

## 六、自审检查清单

### 6.1 代码自审清单

```markdown
## 代码自审检查清单

### 语法检查
- [ ] HTML 标签正确闭合
- [ ] CSS 属性值有效
- [ ] JavaScript 无语法错误
- [ ] TypeScript 类型检查通过

### 类型检查
- [ ] Props 类型完整定义
- [ ] 事件处理器类型正确
- [ ] 返回值类型声明
- [ ] 泛型使用恰当

### 结构检查
- [ ] 组件职责单一
- [ ] 目录结构清晰
- [ ] 无循环依赖
- [ ] 公共逻辑已提取

### 命名检查
- [ ] 组件名使用 PascalCase
- [ ] 变量名使用 camelCase
- [ ] 常量名使用 UPPER_SNAKE_CASE
- [ ] 布尔变量使用 is/has 前缀
- [ ] 事件处理使用 handle 前缀
```

### 6.2 视觉自审清单

```markdown
## 视觉自审检查清单

### 层级检查
- [ ] 信息层级清晰
- [ ] 视觉权重合理
- [ ] 空间层级正确
- [ ] 焦点元素突出

### 色彩检查
- [ ] 主色使用一致
- [ ] 辅助色符合规范
- [ ] 对比度达标 (WCAG AA)
- [ ] 暗色模式适配

### 排版检查
- [ ] 字体栈合理
- [ ] 字号阶梯完整
- [ ] 行高舒适
- [ ] 字重使用恰当

### 间距检查
- [ ] 使用 8px 网格
- [ ] 内边距一致
- [ ] 外边距合理
- [ ] 留白充足
```

### 6.3 交互自审清单

```markdown
## 交互自审检查清单

### 状态检查
- [ ] 默认状态定义
- [ ] 悬停状态实现
- [ ] 聚焦状态实现
- [ ] 禁用状态处理
- [ ] 加载状态设计
- [ ] 错误状态处理
- [ ] 空状态设计

### 反馈检查
- [ ] 点击反馈及时
- [ ] 加载指示器存在
- [ ] 成功提示友好
- [ ] 错误提示明确
- [ ] 恢复路径清晰

### 动效检查
- [ ] 过渡动画流畅
- [ ] 时长符合标准
- [ ] 缓动函数恰当
- [ ] 支持减少动画
- [ ] 60fps 运行
```

### 6.4 审美自审清单

```markdown
## 审美自审检查清单

### 现代感检查
- [ ] 设计语言简洁
- [ ] 圆角使用适度
- [ ] 阴影层次分明
- [ ] 留白处理得当

### 完成度检查
- [ ] 所有元素已实现
- [ ] 无占位符内容
- [ ] 边缘情况处理
- [ ] 响应式完整

### 品牌调性检查
- [ ] 品牌色应用正确
- [ ] 品牌字体使用
- [ ] 文案风格一致
- [ ] 品牌元素规范
```

---

## 七、使用指南

### 7.1 评估流程

```
1. 代码生成完成后，启动自评估流程
2. 按顺序执行四步自审
3. 填写检查清单，记录问题
4. 计算各维度得分
5. 生成评分卡 JSON
6. 根据总分确定等级
7. 判断是否触发重构
8. 输出评估报告
```

### 7.2 输出要求

每次自评估必须输出：

1. **评分卡文件**: `self-eval.scorecard.json`
2. **检查清单**: 完成的检查清单文档
3. **评估报告**: 包含总分、等级、主要问题
4. **优化建议**: 优先级排序的改进建议

---

## 附录

### A. 参考标准

- [WCAG 2.1](https://www.w3.org/WAI/WCAG21/quickref/)
- [Material Design](https://material.io/design)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Google Lighthouse Scoring](https://web.dev/performance-scoring/)

### B. 工具推荐

| 用途 | 工具 |
|------|------|
| 代码质量 | ESLint, Prettier, SonarQube |
| 类型检查 | TypeScript Compiler |
| 性能测试 | Lighthouse, WebPageTest |
| 可访问性 | axe, WAVE |
| 视觉回归 | Chromatic, Percy |

---

*本文档由 Claude Code 团队维护，如有问题请提交 Issue。*
