---
title: "UI 审美规范系统"
description: "完整的UI设计审美规范，涵盖视觉层级、色彩系统、排版、间距、风格预设和组件规范"
version: "1.0.0"
category: "design-system"
tags: ["ui-design", "aesthetics", "design-system", "visual-hierarchy", "color-system"]
author: "RUI Design Team"
date: "2024-01-15"
---

# UI 审美规范系统

> **文档定位**：本规范定义了UI设计的审美标准，为设计师和开发者提供可执行的设计准则，确保产品视觉体验的一致性与高品质。

---

## 目录

- [1. 视觉层级设计原则](#1-视觉层级设计原则)
  - [1.1 Z轴层级理论](#11-z轴层级理论)
  - [1.2 信息密度控制](#12-信息密度控制)
- [2. 色彩系统设计](#2-色彩系统设计)
  - [2.1 色彩系统架构](#21-色彩系统架构)
  - [2.2 主色与辅助色](#22-主色与辅助色)
  - [2.3 语义色彩](#23-语义色彩)
  - [2.4 中性色阶](#24-中性色阶)
- [3. 排版系统](#3-排版系统)
  - [3.1 字体栈](#31-字体栈)
  - [3.2 字号阶梯](#32-字号阶梯)
  - [3.3 行高与字重](#33-行高与字重)
- [4. 间距系统](#4-间距系统)
  - [4.1 4px/8px基准](#41-4px8px基准)
  - [4.2 区块间距](#42-区块间距)
  - [4.3 组件内边距](#43-组件内边距)
- [5. 圆角与阴影策略](#5-圆角与阴影策略)
- [6. 风格预设分类](#6-风格预设分类)
- [7. 组件审美规范](#7-组件审美规范)
  - [7.1 按钮](#71-按钮)
  - [7.2 输入框](#72-输入框)
  - [7.3 卡片](#73-卡片)
  - [7.4 导航](#74-导航)
- [8. 审美检查清单](#8-审美检查清单)

---

## 1. 视觉层级设计原则 {#visual-hierarchy}

### 1.1 Z轴层级理论

Z轴层级（Z-Index Hierarchy）是UI设计中控制元素视觉优先级的重要概念，通过模拟三维空间中的深度感来引导用户注意力。

#### 1.1.1 层级定义

| 层级 | Z-Index范围 | 用途 | 视觉特征 |
|------|-------------|------|----------|
| **背景层** | z-0 ~ z-10 | 页面背景、装饰元素 | 无阴影、低对比度 |
| **内容层** | z-20 ~ z-30 | 主要内容、文本、图片 | 轻微阴影或无阴影 |
| **交互层** | z-40 ~ z-50 | 按钮、输入框、卡片 | 明显阴影、hover效果 |
| **浮层** | z-60 ~ z-70 | 下拉菜单、工具提示 | 较强阴影、遮罩 |
| **模态层** | z-80 ~ z-90 | 弹窗、对话框 | 强阴影、背景遮罩 |
| **最高层** | z-100 | 通知、Toast | 最强阴影、固定位置 |

#### 1.1.2 层级应用原则

```
┌─────────────────────────────────────────────────────────┐
│  z-100  │  通知/Toast (固定右上角，自动消失)              │
│  z-90   │  模态对话框 (全屏遮罩，阻断操作)                │
│  z-70   │  下拉菜单/Tooltip (跟随触发元素)               │
│  z-50   │  卡片/按钮 (hover时提升层级)                   │
│  z-30   │  内容区域 (文本、图片、表格)                   │
│  z-10   │  背景装饰 (渐变、图案、模糊效果)               │
│  z-0    │  页面背景 (纯色或渐变)                         │
└─────────────────────────────────────────────────────────┘
```

#### 1.1.3 阴影与层级对应

| 层级 | 阴影参数 | 效果描述 |
|------|----------|----------|
| z-0 | `none` | 完全平面 |
| z-10 | `0 1px 2px rgba(0,0,0,0.05)` | 轻微浮起 |
| z-20 | `0 2px 4px rgba(0,0,0,0.08)` | 卡片默认 |
| z-30 | `0 4px 8px rgba(0,0,0,0.1)` | 卡片悬停 |
| z-40 | `0 8px 16px rgba(0,0,0,0.12)` | 下拉菜单 |
| z-50 | `0 12px 24px rgba(0,0,0,0.15)` | 模态框 |
| z-60 | `0 16px 32px rgba(0,0,0,0.18)` | 重要通知 |

### 1.2 信息密度控制

信息密度（Information Density）指单位面积内呈现的信息量，直接影响用户的认知负荷。

#### 1.2.1 密度等级

| 密度等级 | 适用场景 | 特征 |
|----------|----------|------|
| **Low (低密度)** | 营销页面、新手引导 | 大间距、大字体、大量留白 |
| **Medium (中密度)** | 内容展示、仪表板 | 平衡间距、清晰分组 |
| **High (高密度)** | 数据表格、管理后台 | 紧凑布局、信息最大化 |

#### 1.2.2 密度控制公式

```
信息密度 = 内容元素数量 / 可视区域面积

推荐密度范围：
- 低密度：0.05-0.1 elements/cm²
- 中密度：0.1-0.2 elements/cm²  
- 高密度：0.2-0.4 elements/cm²
```

#### 1.2.3 密度控制检查点

- [ ] 每屏核心信息不超过3个
- [ ] 相关元素间距 ≤ 无关元素间距
- [ ] 使用分组和分隔线降低视觉复杂度
- [ ] 关键操作按钮周围留白 ≥ 24px
- [ ] 文本行长度控制在45-75字符

---

## 2. 色彩系统设计 {#color-system}

### 2.1 色彩系统架构

色彩系统是UI设计的视觉基础，采用分层架构确保色彩使用的一致性和可扩展性。

```
┌─────────────────────────────────────────────────────────┐
│                    色彩系统架构                          │
├─────────────────────────────────────────────────────────┤
│  语义层  │  Success │ Warning │ Error │ Info            │
├──────────┼──────────────────────────────────────────────┤
│  功能层  │  Primary │ Secondary │ Accent               │
├──────────┼──────────────────────────────────────────────┤
│  中性层  │  Black │ Gray Scale │ White                 │
├──────────┼──────────────────────────────────────────────┤
│  背景层  │  Page BG │ Surface │ Elevated              │
└─────────────────────────────────────────────────────────┘
```

### 2.2 主色与辅助色

#### 2.2.1 主色（Primary）

主色是品牌识别的核心色彩，用于主要操作、高亮和强调。

| 色阶 | 色值 | 用途 |
|------|------|------|
| Primary-50 | `#EEF2FF` | 最浅背景 |
| Primary-100 | `#E0E7FF` | 浅色背景 |
| Primary-200 | `#C7D2FE` | 边框、分割线 |
| Primary-300 | `#A5B4FC` | 禁用状态 |
| Primary-400 | `#818CF8` | 次要元素 |
| **Primary-500** | `#6366F1` | **主色默认** |
| Primary-600 | `#4F46E5` | 悬停状态 |
| Primary-700 | `#4338CA` | 按下状态 |
| Primary-800 | `#3730A3` | 深色元素 |
| Primary-900 | `#312E81` | 最深文字 |

#### 2.2.2 辅助色（Secondary）

辅助色用于次要操作、补充信息和视觉平衡。

| 色阶 | 色值 | 用途 |
|------|------|------|
| Secondary-50 | `#F0FDFA` | 最浅背景 |
| Secondary-100 | `#CCFBF1` | 浅色背景 |
| Secondary-200 | `#99F6E4` | 边框、分割线 |
| Secondary-300 | `#5EEAD4` | 禁用状态 |
| Secondary-400 | `#2DD4BF` | 次要元素 |
| **Secondary-500** | `#14B8A6` | **辅助色默认** |
| Secondary-600 | `#0D9488` | 悬停状态 |
| Secondary-700 | `#0F766E` | 按下状态 |
| Secondary-800 | `#115E59` | 深色元素 |
| Secondary-900 | `#134E4A` | 最深文字 |

#### 2.2.3 强调色（Accent）

强调色用于特殊场景，如促销、新功能标记等。

| 色阶 | 色值 | 用途 |
|------|------|------|
| Accent-500 | `#F59E0B` | 强调默认（琥珀色） |
| Accent-600 | `#D97706` | 悬停状态 |
| Accent-Pink | `#EC4899` | 特殊强调 |
| Accent-Purple | `#8B5CF6` | 创意强调 |

### 2.3 语义色彩

语义色彩用于传达特定的状态或含义，用户应能直观理解其代表的意义。

| 状态 | 色值 | 浅色背景 | 深色背景 | 使用场景 |
|------|------|----------|----------|----------|
| **Success** | `#10B981` | `#D1FAE5` | `#064E3B` | 成功消息、完成状态 |
| **Warning** | `#F59E0B` | `#FEF3C7` | `#78350F` | 警告消息、注意提示 |
| **Error** | `#EF4444` | `#FEE2E2` | `#7F1D1D` | 错误消息、删除操作 |
| **Info** | `#3B82F6` | `#DBEAFE` | `#1E3A8A` | 信息提示、帮助文本 |

#### 2.3.1 语义色彩使用规范

```css
/* Success 状态 */
.success-text { color: #10B981; }
.success-bg { background-color: #D1FAE5; }
.success-border { border-color: #10B981; }

/* Warning 状态 */
.warning-text { color: #F59E0B; }
.warning-bg { background-color: #FEF3C7; }
.warning-border { border-color: #F59E0B; }

/* Error 状态 */
.error-text { color: #EF4444; }
.error-bg { background-color: #FEE2E2; }
.error-border { border-color: #EF4444; }

/* Info 状态 */
.info-text { color: #3B82F6; }
.info-bg { background-color: #DBEAFE; }
.info-border { border-color: #3B82F6; }
```

### 2.4 中性色阶

中性色用于文本、背景、边框等基础UI元素，构建界面的明暗层次。

#### 2.4.1 中性色表

| 色阶 | 色值 | 用途 |
|------|------|------|
| Neutral-0 | `#FFFFFF` | 纯白背景 |
| Neutral-50 | `#F9FAFB` | 页面背景 |
| Neutral-100 | `#F3F4F6` | 卡片背景、悬停背景 |
| Neutral-200 | `#E5E7EB` | 边框、分割线 |
| Neutral-300 | `#D1D5DB` | 禁用边框 |
| Neutral-400 | `#9CA3AF` | 占位符文字 |
| Neutral-500 | `#6B7280` | 次要文字 |
| Neutral-600 | `#4B5563` | 正文文字（浅色背景） |
| Neutral-700 | `#374151` | 标题文字（浅色背景） |
| Neutral-800 | `#1F2937` | 深色文字 |
| Neutral-900 | `#111827` | 最深文字 |
| Neutral-950 | `#030712` | 纯黑文字 |

#### 2.4.2 深色模式中性色

| 色阶 | 色值 | 用途 |
|------|------|------|
| Dark-0 | `#000000` | 纯黑背景 |
| Dark-50 | `#0A0A0A` | 深色页面背景 |
| Dark-100 | `#171717` | 深色卡片背景 |
| Dark-200 | `#262626` | 深色边框 |
| Dark-300 | `#404040` | 深色分割线 |
| Dark-400 | `#525252` | 深色占位符 |
| Dark-500 | `#737373` | 深色次要文字 |
| Dark-600 | `#A3A3A3` | 深色正文 |
| Dark-700 | `#D4D4D4` | 深色标题 |
| Dark-800 | `#E5E5E5` | 深色强调文字 |
| Dark-900 | `#F5F5F5` | 深色最深文字 |
| Dark-950 | `#FFFFFF` | 纯白文字 |

---

## 3. 排版系统 {#typography}

### 3.1 字体栈

字体栈（Font Stack）定义了字体的优先级回退机制，确保在不同系统和浏览器中都能呈现良好的排版效果。

#### 3.1.1 中文字体栈

```css
/* 无衬线字体 - 正文和UI */
--font-sans-zh: 
  "PingFang SC",      /* macOS/iOS 苹方 */
  "Hiragino Sans GB", /* macOS 冬青黑体 */
  "Microsoft YaHei",  /* Windows 微软雅黑 */
  "WenQuanYi Micro Hei", /* Linux 文泉驿 */
  "Noto Sans CJK SC", /* Google Noto */
  sans-serif;

/* 衬线字体 - 标题和强调 */
--font-serif-zh:
  "Songti SC",        /* macOS 宋体 */
  "SimSun",           /* Windows 宋体 */
  "Noto Serif CJK SC", /* Google Noto Serif */
  serif;

/* 等宽字体 - 代码和数据 */
--font-mono-zh:
  "SF Mono",
  "Fira Code",
  "JetBrains Mono",
  "Source Code Pro",
  monospace;
```

#### 3.1.2 英文字体栈

```css
/* 无衬线字体 */
--font-sans-en:
  -apple-system,      /* macOS/iOS 系统字体 */
  BlinkMacSystemFont, /* Chrome macOS */
  "Segoe UI",         /* Windows */
  Roboto,             /* Android */
  "Helvetica Neue",
  Arial,
  sans-serif;

/* 衬线字体 */
--font-serif-en:
  "Georgia",
  "Times New Roman",
  Times,
  serif;

/* 等宽字体 */
--font-mono-en:
  "SF Mono",
  "Monaco",
  "Inconsolata",
  "Roboto Mono",
  monospace;
```

#### 3.1.3 完整字体栈

```css
/* 完整字体栈（中文优先） */
--font-family-base:
  "PingFang SC",
  "Hiragino Sans GB",
  "Microsoft YaHei",
  -apple-system,
  BlinkMacSystemFont,
  "Segoe UI",
  Roboto,
  sans-serif;

/* 代码字体 */
--font-family-code:
  "SF Mono",
  "Fira Code",
  "JetBrains Mono",
  "Source Code Pro",
  monospace;
```

### 3.2 字号阶梯

字号阶梯（Type Scale）建立了一套有规律的字体大小体系，确保排版的一致性和可读性。

#### 3.2.1 基础字号阶梯表

| 层级 | 名称 | 字号 | 行高 | 字重 | 用途 |
|------|------|------|------|------|------|
| **Display** | 展示大标题 | 48px / 3rem | 1.1 | 700 | 首页Hero、大标题 |
| **H1** | 一级标题 | 36px / 2.25rem | 1.2 | 700 | 页面主标题 |
| **H2** | 二级标题 | 30px / 1.875rem | 1.25 | 600 | 区块标题 |
| **H3** | 三级标题 | 24px / 1.5rem | 1.3 | 600 | 卡片标题 |
| **H4** | 四级标题 | 20px / 1.25rem | 1.4 | 600 | 小标题 |
| **H5** | 五级标题 | 18px / 1.125rem | 1.4 | 500 | 列表标题 |
| **H6** | 六级标题 | 16px / 1rem | 1.5 | 500 | 最小标题 |
| **Body Large** | 大正文 | 18px / 1.125rem | 1.6 | 400 | 重要段落 |
| **Body** | 正文 | 16px / 1rem | 1.6 | 400 | 默认正文 |
| **Body Small** | 小正文 | 14px / 0.875rem | 1.5 | 400 | 次要文本 |
| **Caption** | 说明文字 | 12px / 0.75rem | 1.4 | 400 | 辅助说明 |
| **Overline** | 标签文字 | 10px / 0.625rem | 1.2 | 500 | 标签、徽章 |

#### 3.2.2 响应式字号调整

| 层级 | 桌面端 | 平板端 | 移动端 | 最小值 |
|------|--------|--------|--------|--------|
| Display | 48px | 40px | 32px | 28px |
| H1 | 36px | 32px | 28px | 24px |
| H2 | 30px | 26px | 22px | 20px |
| H3 | 24px | 22px | 20px | 18px |
| H4 | 20px | 18px | 16px | 16px |
| Body | 16px | 16px | 15px | 14px |

### 3.3 行高与字重

#### 3.3.1 行高规范

| 文本类型 | 推荐行高 | 说明 |
|----------|----------|------|
| 大标题 (Display-H2) | 1.1 - 1.2 | 紧凑，增强视觉冲击力 |
| 小标题 (H3-H6) | 1.3 - 1.4 | 适中，保持可读性 |
| 正文 (Body) | 1.5 - 1.7 | 宽松，提升阅读舒适度 |
| 紧凑文本 | 1.2 - 1.3 | 表格、列表等 |

#### 3.3.2 字重规范

| 字重 | 数值 | 用途 |
|------|------|------|
| Thin | 100 | 极少使用 |
| Extra Light | 200 | 装饰性大标题 |
| Light | 300 | 次要信息 |
| **Regular** | **400** | **正文默认** |
| Medium | 500 | 强调文本 |
| **Semi Bold** | **600** | **小标题** |
| **Bold** | **700** | **大标题** |
| Extra Bold | 800 | 强调标题 |
| Black | 900 | 极少使用 |

#### 3.3.3 排版CSS变量

```css
:root {
  /* 字号 */
  --text-xs: 0.75rem;      /* 12px */
  --text-sm: 0.875rem;     /* 14px */
  --text-base: 1rem;       /* 16px */
  --text-lg: 1.125rem;     /* 18px */
  --text-xl: 1.25rem;      /* 20px */
  --text-2xl: 1.5rem;      /* 24px */
  --text-3xl: 1.875rem;    /* 30px */
  --text-4xl: 2.25rem;     /* 36px */
  --text-5xl: 3rem;        /* 48px */
  
  /* 行高 */
  --leading-none: 1;
  --leading-tight: 1.25;
  --leading-snug: 1.375;
  --leading-normal: 1.5;
  --leading-relaxed: 1.625;
  --leading-loose: 2;
  
  /* 字重 */
  --font-normal: 400;
  --font-medium: 500;
  --font-semibold: 600;
  --font-bold: 700;
}
```

---

## 4. 间距系统 {#spacing}

### 4.1 4px/8px基准

间距系统基于4px和8px的倍数建立，确保所有间距值的一致性和可预测性。

#### 4.1.1 间距阶梯表

| Token | 数值 | 像素值 | 用途 |
|-------|------|--------|------|
| `space-0` | 0 | 0px | 无间距 |
| `space-px` | 1px | 1px | 细边框 |
| `space-0.5` | 0.125rem | 2px | 极小间距 |
| `space-1` | 0.25rem | 4px | 图标内边距 |
| `space-1.5` | 0.375rem | 6px | 紧凑间距 |
| `space-2` | 0.5rem | 8px | 组件内部间距 |
| `space-2.5` | 0.625rem | 10px | 小间距 |
| `space-3` | 0.75rem | 12px | 按钮内边距 |
| `space-3.5` | 0.875rem | 14px | 中等间距 |
| `space-4` | 1rem | 16px | 标准间距 |
| `space-5` | 1.25rem | 20px | 卡片内边距 |
| `space-6` | 1.5rem | 24px | 区块间距 |
| `space-7` | 1.75rem | 28px | 大间距 |
| `space-8` | 2rem | 32px | 区块内边距 |
| `space-9` | 2.25rem | 36px | 大区块间距 |
| `space-10` | 2.5rem | 40px | 页面边距 |
| `space-11` | 2.75rem | 44px | 超大间距 |
| `space-12` | 3rem | 48px | 大区块内边距 |
| `space-14` | 3.5rem | 56px | 超大区块 |
| `space-16` | 4rem | 64px | 页面区块 |
| `space-20` | 5rem | 80px | 大区块分隔 |
| `space-24` | 6rem | 96px | 超大区块 |
| `space-28` | 7rem | 112px | 特大区块 |
| `space-32` | 8rem | 128px | 页面分隔 |
| `space-36` | 9rem | 144px | 超大分隔 |
| `space-40` | 10rem | 160px | 最大分隔 |

#### 4.1.2 间距使用模式

```
┌─────────────────────────────────────────────────────────┐
│  4px (space-1)   │  图标间距、紧凑内联元素                │
│  8px (space-2)   │  组件内部小间距、图标+文字             │
│  12px (space-3)  │  按钮内边距、小卡片内边距              │
│  16px (space-4)  │  标准组件间距、表单字段间距            │
│  24px (space-6)  │  卡片内边距、区块内部间距              │
│  32px (space-8)  │  大卡片内边距、区块间距                │
│  48px (space-12) │  页面区块内边距、大区块分隔            │
│  64px (space-16) │  页面区块分隔、Section间距             │
│  96px+           │  页面大区块分隔、Hero区域              │
└─────────────────────────────────────────────────────────┘
```

### 4.2 区块间距

区块间距控制页面不同区域之间的视觉分隔。

#### 4.2.1 区块间距规范

| 区块类型 | 上内边距 | 下内边距 | 水平内边距 |
|----------|----------|----------|------------|
| **Hero区块** | 96px | 96px | 24px (移动端) / 48px (桌面端) |
| **内容区块** | 64px | 64px | 24px / 48px |
| **功能区块** | 48px | 48px | 24px / 48px |
| **卡片区块** | 32px | 32px | 24px |
| **页脚区块** | 48px | 24px | 24px / 48px |

#### 4.2.2 区块间距CSS

```css
.section {
  padding-left: var(--space-6);   /* 24px */
  padding-right: var(--space-6);  /* 24px */
}

@media (min-width: 768px) {
  .section {
    padding-left: var(--space-12);  /* 48px */
    padding-right: var(--space-12); /* 48px */
  }
}

.section-hero {
  padding-top: var(--space-24);     /* 96px */
  padding-bottom: var(--space-24);  /* 96px */
}

.section-content {
  padding-top: var(--space-16);     /* 64px */
  padding-bottom: var(--space-16);  /* 64px */
}

.section-compact {
  padding-top: var(--space-8);      /* 32px */
  padding-bottom: var(--space-8);   /* 32px */
}
```

### 4.3 组件内边距

#### 4.3.1 组件内边距规范

| 组件 | 水平内边距 | 垂直内边距 | 总高度 |
|------|------------|------------|--------|
| **小按钮** | 12px | 6px | 32px |
| **中按钮** | 16px | 10px | 40px |
| **大按钮** | 24px | 14px | 48px |
| **输入框(小)** | 12px | 8px | 36px |
| **输入框(中)** | 16px | 12px | 44px |
| **输入框(大)** | 20px | 16px | 56px |
| **小卡片** | 16px | 16px | - |
| **中卡片** | 24px | 24px | - |
| **大卡片** | 32px | 32px | - |

#### 4.3.2 组件间距CSS变量

```css
:root {
  /* 组件内边距 */
  --padding-button-sm: 6px 12px;
  --padding-button-md: 10px 16px;
  --padding-button-lg: 14px 24px;
  
  --padding-input-sm: 8px 12px;
  --padding-input-md: 12px 16px;
  --padding-input-lg: 16px 20px;
  
  --padding-card-sm: 16px;
  --padding-card-md: 24px;
  --padding-card-lg: 32px;
  
  /* 组件间距 */
  --gap-xs: 4px;
  --gap-sm: 8px;
  --gap-md: 16px;
  --gap-lg: 24px;
  --gap-xl: 32px;
}
```

---

## 5. 圆角与阴影策略 {#radius-shadow}

### 5.1 圆角系统

圆角（Border Radius）影响组件的视觉风格，从锐利到柔和。

#### 5.1.1 圆角阶梯

| Token | 数值 | 用途 |
|-------|------|------|
| `radius-none` | 0 | 锐利边角、表格 |
| `radius-sm` | 2px | 极小圆角、标签 |
| `radius-base` | 4px | 小按钮、输入框 |
| `radius-md` | 6px | 标准圆角、卡片 |
| `radius-lg` | 8px | 大按钮、模态框 |
| `radius-xl` | 12px | 大卡片、面板 |
| `radius-2xl` | 16px | 超大卡片 |
| `radius-3xl` | 24px | 特殊卡片 |
| `radius-full` | 9999px | 胶囊形状、头像 |

#### 5.1.2 圆角使用规范

| 组件类型 | 推荐圆角 | 说明 |
|----------|----------|------|
| 按钮(小) | 4px | 紧凑专业 |
| 按钮(中) | 6px | 标准友好 |
| 按钮(大) | 8px | 醒目突出 |
| 输入框 | 6px | 与按钮协调 |
| 卡片 | 8-12px | 现代感 |
| 模态框 | 12-16px | 突出重要 |
| 头像 | 9999px | 圆形 |
| 标签/徽章 | 9999px | 胶囊形 |
| 表格单元格 | 0 | 数据清晰 |

### 5.2 阴影系统

阴影（Shadow）用于创建深度感和层级关系。

#### 5.2.1 阴影阶梯

| Token | 阴影值 | 用途 |
|-------|--------|------|
| `shadow-none` | none | 平面元素 |
| `shadow-xs` | `0 1px 2px rgba(0,0,0,0.05)` | 轻微浮起 |
| `shadow-sm` | `0 1px 3px rgba(0,0,0,0.1)` | 小卡片 |
| `shadow-base` | `0 2px 4px rgba(0,0,0,0.08)` | 默认卡片 |
| `shadow-md` | `0 4px 6px rgba(0,0,0,0.1)` | 悬停状态 |
| `shadow-lg` | `0 8px 16px rgba(0,0,0,0.12)` | 下拉菜单 |
| `shadow-xl` | `0 12px 24px rgba(0,0,0,0.15)` | 模态框 |
| `shadow-2xl` | `0 20px 40px rgba(0,0,0,0.18)` | 重要弹窗 |
| `shadow-inner` | `inset 0 2px 4px rgba(0,0,0,0.06)` | 内凹效果 |

#### 5.2.2 阴影CSS变量

```css
:root {
  /* 基础阴影 */
  --shadow-xs: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-sm: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px -1px rgba(0, 0, 0, 0.1);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
  --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
  --shadow-2xl: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
  --shadow-inner: inset 0 2px 4px 0 rgba(0, 0, 0, 0.05);
  
  /* 彩色阴影（用于强调） */
  --shadow-primary: 0 4px 14px 0 rgba(99, 102, 241, 0.39);
  --shadow-success: 0 4px 14px 0 rgba(16, 185, 129, 0.39);
  --shadow-warning: 0 4px 14px 0 rgba(245, 158, 11, 0.39);
  --shadow-error: 0 4px 14px 0 rgba(239, 68, 68, 0.39);
}
```

---

## 6. 风格预设分类 {#style-presets}

风格预设（Style Presets）定义了不同产品场景下的视觉风格方向。

### 6.1 风格预设对比表

| 维度 | Data Clarity | Bold Productive | Warm Friendly | Premium Minimal | Creative Expressive |
|------|--------------|-----------------|---------------|-----------------|---------------------|
| **定位** | 数据驱动 | 效率优先 | 用户友好 | 高端品质 | 创意表达 |
| **典型场景** | 数据分析、BI工具 | 生产力工具、SaaS | 社交、教育、健康 | 奢侈品、金融、高端服务 | 设计工具、创意平台 |
| **主色** | 蓝色系 `#2563EB` | 深蓝 `#1E40AF` | 暖橙 `#F97316` | 黑白灰+金色点缀 | 多彩渐变 |
| **辅助色** | 青绿 `#0891B2` | 青色 `#06B6D4` | 珊瑚 `#FB7185` | 银色 `#C0C0C0` | 彩虹色系 |
| **中性色** | 冷灰 | 中性灰 | 暖灰 | 纯黑纯白 | 深灰 |
| **圆角** | 4-6px | 6-8px | 12-16px | 0-4px | 16-24px |
| **阴影** | 轻微或无 | 中等 | 柔和 | 极简 | 强烈 |
| **字体** | 无衬线、等宽 | 无衬线 | 圆体 | 衬线+无衬线 | 艺术字体 |
| **信息密度** | 高 | 中-高 | 中-低 | 低 | 中 |
| **动效** | 功能性 | 快速响应 | 柔和过渡 | 优雅缓慢 | 丰富创意 |

### 6.2 Data Clarity（数据清晰）

```yaml
style_preset:
  name: "Data Clarity"
  description: "专注于数据可视化和信息密度，追求极致的清晰度和可读性"
  
  color:
    primary: "#2563EB"      # 专业蓝
    secondary: "#0891B2"    # 数据青
    accent: "#7C3AED"       # 强调紫
    neutral: "#64748B"      # 冷灰
    
  typography:
    family: "Inter, SF Pro, system-ui"
    heading_weight: 600
    body_weight: 400
    
  spacing:
    density: "high"
    compact: true
    
  radius:
    button: "4px"
    card: "6px"
    input: "4px"
    
  shadow:
    level: "minimal"
    cards: "none"
    
  examples:
    - "Tableau"
    - "Power BI"
    - "Google Analytics"
```

### 6.3 Bold Productive（大胆高效）

```yaml
style_preset:
  name: "Bold Productive"
  description: "强调效率和生产力，使用大胆的视觉元素引导快速操作"
  
  color:
    primary: "#1E40AF"      # 深蓝
    secondary: "#06B6D4"    # 活力青
    accent: "#F59E0B"       # 行动橙
    neutral: "#475569"      # 中性灰
    
  typography:
    family: "Inter, Roboto, system-ui"
    heading_weight: 700
    body_weight: 400
    
  spacing:
    density: "medium-high"
    compact: false
    
  radius:
    button: "6px"
    card: "8px"
    input: "6px"
    
  shadow:
    level: "medium"
    cards: "shadow-sm"
    
  examples:
    - "Notion"
    - "Slack"
    - "Linear"
```

### 6.4 Warm Friendly（温暖友好）

```yaml
style_preset:
  name: "Warm Friendly"
  description: "营造亲切、友好的氛围，适合面向普通用户的消费级产品"
  
  color:
    primary: "#F97316"      # 暖橙
    secondary: "#FB7185"    # 珊瑚粉
    accent: "#A3E635"       # 活力绿
    neutral: "#78716C"      # 暖灰
    
  typography:
    family: "Nunito, Quicksand, system-ui"
    heading_weight: 700
    body_weight: 400
    
  spacing:
    density: "medium-low"
    compact: false
    
  radius:
    button: "12px"
    card: "16px"
    input: "12px"
    
  shadow:
    level: "soft"
    cards: "shadow-md"
    
  examples:
    - "Duolingo"
    - "Headspace"
    - "Calm"
```

### 6.5 Premium Minimal（高端极简）

```yaml
style_preset:
  name: "Premium Minimal"
  description: "追求极致的简约和品质感，通过留白和细节彰显高端定位"
  
  color:
    primary: "#000000"      # 纯黑
    secondary: "#FFFFFF"    # 纯白
    accent: "#D4AF37"       # 金色点缀
    neutral: "#1F2937"      # 深灰
    
  typography:
    family: "Helvetica Neue, Arial, sans-serif"
    heading_weight: 300
    body_weight: 400
    
  spacing:
    density: "low"
    compact: false
    
  radius:
    button: "0px"
    card: "0px"
    input: "0px"
    
  shadow:
    level: "none"
    cards: "none"
    
  examples:
    - "Apple"
    - "Aesop"
    - "Cartier"
```

### 6.6 Creative Expressive（创意表达）

```yaml
style_preset:
  name: "Creative Expressive"
  description: "鼓励创意表达，使用丰富的色彩、动效和独特的视觉元素"
  
  color:
    primary: "gradient(135deg, #667eea 0%, #764ba2 100%)"
    secondary: "gradient(135deg, #f093fb 0%, #f5576c 100%)"
    accent: "#FF6B6B"
    neutral: "#2D3748"
    
  typography:
    family: "Poppins, Montserrat, system-ui"
    heading_weight: 800
    body_weight: 400
    
  spacing:
    density: "medium"
    compact: false
    
  radius:
    button: "16px"
    card: "24px"
    input: "12px"
    
  shadow:
    level: "strong"
    cards: "shadow-lg"
    
  examples:
    - "Figma"
    - "Dribbble"
    - "Spotify"
```

---

## 7. 组件审美规范 {#component-aesthetics}

### 7.1 按钮

按钮是最常用的交互组件，其审美规范直接影响用户操作的体验。

#### 7.1.1 按钮尺寸规范

| 尺寸 | 高度 | 水平内边距 | 字号 | 圆角 | 用途 |
|------|------|------------|------|------|------|
| **xs** | 24px | 8px | 12px | 4px | 紧凑操作 |
| **sm** | 32px | 12px | 14px | 4px | 次要操作 |
| **md** | 40px | 16px | 14px | 6px | 标准操作 |
| **lg** | 48px | 24px | 16px | 8px | 主要操作 |
| **xl** | 56px | 32px | 18px | 10px | Hero CTA |

#### 7.1.2 按钮变体规范

| 变体 | 背景 | 文字 | 边框 | 阴影 | 用途 |
|------|------|------|------|------|------|
| **Primary** | `primary-500` | white | none | `shadow-primary` | 主要操作 |
| **Secondary** | `primary-100` | `primary-700` | none | none | 次要操作 |
| **Outline** | transparent | `primary-600` | `primary-500` 1px | none | 第三操作 |
| **Ghost** | transparent | `primary-600` | none | none | 低强调操作 |
| **Danger** | `error-500` | white | none | `shadow-error` | 危险操作 |
| **Link** | transparent | `primary-600` | none | none | 文本链接 |

#### 7.1.3 按钮状态规范

```css
/* Primary Button States */
.btn-primary {
  background-color: var(--primary-500);
  color: white;
  transition: all 200ms ease;
}

.btn-primary:hover {
  background-color: var(--primary-600);
  transform: translateY(-1px);
  box-shadow: var(--shadow-primary);
}

.btn-primary:active {
  background-color: var(--primary-700);
  transform: translateY(0);
}

.btn-primary:disabled {
  background-color: var(--primary-300);
  cursor: not-allowed;
  opacity: 0.6;
}

.btn-primary:focus-visible {
  outline: 2px solid var(--primary-500);
  outline-offset: 2px;
}
```

#### 7.1.4 按钮审美检查点

- [ ] 按钮高度符合尺寸规范
- [ ] 文字与按钮背景对比度 ≥ 4.5:1
- [ ] 悬停状态有明显的视觉反馈
- [ ] 按下状态有明确的按压感
- [ ] 禁用状态明显区别于可用状态
- [ ] 聚焦状态清晰可见
- [ ] 图标与文字间距为 8px
- [ ] 按钮组间距为 12px

### 7.2 输入框

输入框是表单的核心组件，其设计直接影响用户的数据输入体验。

#### 7.2.1 输入框尺寸规范

| 尺寸 | 高度 | 水平内边距 | 字号 | 圆角 | 用途 |
|------|------|------------|------|------|------|
| **sm** | 36px | 12px | 14px | 4px | 紧凑表单 |
| **md** | 44px | 16px | 14px | 6px | 标准表单 |
| **lg** | 56px | 20px | 16px | 8px | 重要输入 |

#### 7.2.2 输入框状态规范

| 状态 | 边框 | 背景 | 阴影 | 说明 |
|------|------|------|------|------|
| **Default** | `neutral-300` | white | none | 默认状态 |
| **Hover** | `neutral-400` | white | none | 悬停状态 |
| **Focus** | `primary-500` | white | `shadow-primary` | 聚焦状态 |
| **Error** | `error-500` | `error-50` | none | 错误状态 |
| **Success** | `success-500` | `success-50` | none | 成功状态 |
| **Disabled** | `neutral-200` | `neutral-100` | none | 禁用状态 |
| **Readonly** | `neutral-300` | `neutral-50` | none | 只读状态 |

#### 7.2.3 输入框CSS规范

```css
.input {
  height: 44px;
  padding: 12px 16px;
  font-size: 14px;
  border: 1px solid var(--neutral-300);
  border-radius: 6px;
  background-color: white;
  transition: all 200ms ease;
}

.input:hover {
  border-color: var(--neutral-400);
}

.input:focus {
  border-color: var(--primary-500);
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
  outline: none;
}

.input--error {
  border-color: var(--error-500);
  background-color: var(--error-50);
}

.input--error:focus {
  box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
}

.input:disabled {
  background-color: var(--neutral-100);
  border-color: var(--neutral-200);
  color: var(--neutral-400);
  cursor: not-allowed;
}
```

#### 7.2.4 输入框审美检查点

- [ ] 输入框高度符合尺寸规范
- [ ] 占位符颜色为 `neutral-400`
- [ ] 聚焦状态有清晰的视觉指示
- [ ] 错误状态有红色边框和背景
- [ ] 标签与输入框间距为 8px
- [ ] 错误提示与输入框间距为 4px
- [ ] 图标内边距为 12px
- [ ] 输入框组间距为 16px

### 7.3 卡片

卡片是内容组织的基本单元，用于展示相关信息和操作。

#### 7.3.1 卡片尺寸规范

| 尺寸 | 内边距 | 圆角 | 阴影 | 用途 |
|------|--------|------|------|------|
| **sm** | 16px | 6px | none | 紧凑信息 |
| **md** | 24px | 8px | `shadow-sm` | 标准卡片 |
| **lg** | 32px | 12px | `shadow-md` | 重要卡片 |
| **xl** | 40px | 16px | `shadow-lg` | 特色卡片 |

#### 7.3.2 卡片变体规范

| 变体 | 背景 | 边框 | 阴影 | 用途 |
|------|------|------|------|------|
| **Default** | white | `neutral-200` 1px | none | 基础卡片 |
| **Elevated** | white | none | `shadow-md` | 浮起卡片 |
| **Outlined** | transparent | `neutral-300` 1px | none | 轮廓卡片 |
| **Filled** | `neutral-100` | none | none | 填充卡片 |
| **Interactive** | white | none | `shadow-sm` | 可交互卡片 |

#### 7.3.3 卡片结构规范

```
┌─────────────────────────────────────────┐
│  Card Header (optional)                 │
│  ├─ 标题 (text-lg, font-semibold)      │
│  └─ 副标题/操作 (text-sm, neutral-500) │
│                                         │
│  Card Body                              │
│  ├─ 主要内容区域                        │
│  └─ 图片/文本/列表等                    │
│                                         │
│  Card Footer (optional)                 │
│  └─ 操作按钮/元信息                     │
└─────────────────────────────────────────┘
```

#### 7.3.4 卡片CSS规范

```css
.card {
  padding: 24px;
  border-radius: 8px;
  background-color: white;
  border: 1px solid var(--neutral-200);
  transition: all 200ms ease;
}

.card--elevated {
  border: none;
  box-shadow: var(--shadow-md);
}

.card--interactive {
  cursor: pointer;
}

.card--interactive:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-lg);
}

.card--interactive:active {
  transform: translateY(0);
}

.card__header {
  margin-bottom: 16px;
}

.card__title {
  font-size: var(--text-lg);
  font-weight: var(--font-semibold);
  color: var(--neutral-900);
}

.card__subtitle {
  font-size: var(--text-sm);
  color: var(--neutral-500);
  margin-top: 4px;
}

.card__footer {
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid var(--neutral-200);
}
```

#### 7.3.5 卡片审美检查点

- [ ] 卡片内边距符合尺寸规范
- [ ] 卡片圆角与整体风格一致
- [ ] 卡片阴影层级正确
- [ ] 卡片标题与内容间距为 16px
- [ ] 卡片页脚与内容间距为 16px
- [ ] 多张卡片间距为 24px
- [ ] 可交互卡片有悬停效果
- [ ] 卡片内容对齐方式一致

### 7.4 导航

导航是用户在产品中定位和移动的核心组件。

#### 7.4.1 导航类型规范

| 类型 | 高度 | 背景 | 阴影 | 用途 |
|------|------|------|------|------|
| **Top Nav** | 64px | white / transparent | `shadow-sm` | 顶部主导航 |
| **Side Nav** | 100vh | `neutral-50` | none | 侧边导航 |
| **Bottom Nav** | 56px | white | `shadow-lg` (top) | 移动端底部导航 |
| **Tab Nav** | 48px | transparent | none | 标签页导航 |
| **Breadcrumb** | 40px | transparent | none | 面包屑导航 |

#### 7.4.2 导航项状态规范

| 状态 | 文字颜色 | 背景 | 指示器 | 说明 |
|------|----------|------|--------|------|
| **Default** | `neutral-600` | transparent | none | 默认状态 |
| **Hover** | `neutral-900` | `neutral-100` | none | 悬停状态 |
| **Active** | `primary-600` | `primary-50` | left 3px | 激活状态 |
| **Selected** | `primary-600` | `primary-50` | bottom 2px | 选中状态 |
| **Disabled** | `neutral-400` | transparent | none | 禁用状态 |

#### 7.4.3 顶部导航CSS规范

```css
.top-nav {
  height: 64px;
  padding: 0 24px;
  background-color: white;
  border-bottom: 1px solid var(--neutral-200);
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.top-nav--fixed {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 50;
  box-shadow: var(--shadow-sm);
}

.nav-item {
  padding: 8px 16px;
  font-size: 14px;
  font-weight: 500;
  color: var(--neutral-600);
  border-radius: 6px;
  transition: all 200ms ease;
}

.nav-item:hover {
  color: var(--neutral-900);
  background-color: var(--neutral-100);
}

.nav-item--active {
  color: var(--primary-600);
  background-color: var(--primary-50);
}
```

#### 7.4.4 侧边导航CSS规范

```css
.side-nav {
  width: 240px;
  height: 100vh;
  padding: 16px 12px;
  background-color: var(--neutral-50);
  border-right: 1px solid var(--neutral-200);
}

.side-nav__item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px;
  font-size: 14px;
  color: var(--neutral-600);
  border-radius: 6px;
  transition: all 200ms ease;
}

.side-nav__item:hover {
  color: var(--neutral-900);
  background-color: var(--neutral-100);
}

.side-nav__item--active {
  color: var(--primary-600);
  background-color: var(--primary-50);
}

.side-nav__item--active::before {
  content: '';
  position: absolute;
  left: 0;
  width: 3px;
  height: 20px;
  background-color: var(--primary-500);
  border-radius: 0 3px 3px 0;
}
```

#### 7.4.5 导航审美检查点

- [ ] 导航高度符合类型规范
- [ ] 导航项间距为 4-8px
- [ ] 激活状态有明显的视觉指示
- [ ] 悬停状态有背景色变化
- [ ] 导航图标与文字间距为 12px
- [ ] 移动端导航有汉堡菜单
- [ ] 导航层级不超过3层
- [ ] 当前位置有面包屑指示

---

## 8. 审美检查清单 {#aesthetic-checklist}

### 8.1 视觉层级检查

| 序号 | 检查项 | 优先级 | 检查方法 |
|------|--------|--------|----------|
| 1 | 页面有明确的主视觉焦点 | 高 | 用户第一眼看到什么？ |
| 2 | 信息层级通过大小、颜色、间距清晰区分 | 高 | 能否快速识别重要信息？ |
| 3 | 使用不超过3种字体大小来建立层级 | 中 | 字体大小是否过多？ |
| 4 | 关键操作的视觉权重高于次要操作 | 高 | 主按钮是否最突出？ |
| 5 | 使用留白而非线条来分组相关内容 | 中 | 是否有不必要的分割线？ |
| 6 | 每屏核心信息不超过3个 | 高 | 是否信息过载？ |

### 8.2 色彩系统检查

| 序号 | 检查项 | 优先级 | 检查方法 |
|------|--------|--------|----------|
| 7 | 主色使用不超过页面色彩的30% | 高 | 主色是否过于泛滥？ |
| 8 | 文字与背景对比度 ≥ 4.5:1 | 高 | 使用对比度检查工具 |
| 9 | 语义色彩（成功/警告/错误）使用正确 | 高 | 是否符合用户预期？ |
| 10 | 深色模式有对应的色彩方案 | 中 | 深色模式是否完整？ |
| 11 | 禁用状态的色彩明度降低50%以上 | 中 | 禁用元素是否明显？ |
| 12 | 链接颜色与正文有明显区分 | 高 | 链接是否可识别？ |

### 8.3 排版系统检查

| 序号 | 检查项 | 优先级 | 检查方法 |
|------|--------|--------|----------|
| 13 | 正文行高在1.5-1.7之间 | 高 | 阅读是否舒适？ |
| 14 | 标题行高在1.1-1.3之间 | 中 | 标题是否紧凑有力？ |
| 15 | 每行文字长度控制在45-75字符 | 高 | 阅读是否需要频繁换行？ |
| 16 | 使用不超过2种字体家族 | 中 | 字体是否过多？ |
| 17 | 字重变化用于强调而非装饰 | 中 | 字重使用是否有意义？ |

### 8.4 间距系统检查

| 序号 | 检查项 | 优先级 | 检查方法 |
|------|--------|--------|----------|
| 18 | 所有间距值为4px的倍数 | 中 | 检查CSS中的间距值 |
| 19 | 相关元素间距 < 无关元素间距 | 高 | 分组是否清晰？ |
| 20 | 按钮周围留白 ≥ 24px | 中 | 按钮是否被挤压？ |
| 21 | 卡片内边距 ≥ 16px | 中 | 内容是否贴边？ |
| 22 | 区块间距使用8px的倍数 | 中 | 区块分隔是否一致？ |

### 8.5 组件审美检查

| 序号 | 检查项 | 优先级 | 检查方法 |
|------|--------|--------|----------|
| 23 | 按钮有明确的悬停、按下、禁用状态 | 高 | 交互反馈是否清晰？ |
| 24 | 输入框聚焦状态有明显的视觉指示 | 高 | 当前输入位置是否明确？ |
| 25 | 卡片阴影与层级相匹配 | 中 | 阴影是否过强或过弱？ |
| 26 | 导航当前位置有明确的视觉指示 | 高 | 用户是否知道在哪里？ |
| 27 | 图标与文字对齐方式一致 | 中 | 是否有错位？ |

### 8.6 整体审美检查

| 序号 | 检查项 | 优先级 | 检查方法 |
|------|--------|--------|----------|
| 28 | 整体风格与产品定位一致 | 高 | 是否符合品牌调性？ |
| 29 | 动效时长在200-400ms之间 | 中 | 动效是否自然？ |
| 30 | 移动端与桌面端体验一致 | 高 | 响应式是否完整？ |

### 8.7 检查清单JSON格式

```json
{
  "aesthetic_checklist": {
    "visual_hierarchy": [
      { "id": 1, "item": "页面有明确的主视觉焦点", "priority": "high" },
      { "id": 2, "item": "信息层级通过大小、颜色、间距清晰区分", "priority": "high" },
      { "id": 3, "item": "使用不超过3种字体大小来建立层级", "priority": "medium" },
      { "id": 4, "item": "关键操作的视觉权重高于次要操作", "priority": "high" },
      { "id": 5, "item": "使用留白而非线条来分组相关内容", "priority": "medium" },
      { "id": 6, "item": "每屏核心信息不超过3个", "priority": "high" }
    ],
    "color_system": [
      { "id": 7, "item": "主色使用不超过页面色彩的30%", "priority": "high" },
      { "id": 8, "item": "文字与背景对比度 ≥ 4.5:1", "priority": "high" },
      { "id": 9, "item": "语义色彩（成功/警告/错误）使用正确", "priority": "high" },
      { "id": 10, "item": "深色模式有对应的色彩方案", "priority": "medium" },
      { "id": 11, "item": "禁用状态的色彩明度降低50%以上", "priority": "medium" },
      { "id": 12, "item": "链接颜色与正文有明显区分", "priority": "high" }
    ],
    "typography": [
      { "id": 13, "item": "正文行高在1.5-1.7之间", "priority": "high" },
      { "id": 14, "item": "标题行高在1.1-1.3之间", "priority": "medium" },
      { "id": 15, "item": "每行文字长度控制在45-75字符", "priority": "high" },
      { "id": 16, "item": "使用不超过2种字体家族", "priority": "medium" },
      { "id": 17, "item": "字重变化用于强调而非装饰", "priority": "medium" }
    ],
    "spacing": [
      { "id": 18, "item": "所有间距值为4px的倍数", "priority": "medium" },
      { "id": 19, "item": "相关元素间距 < 无关元素间距", "priority": "high" },
      { "id": 20, "item": "按钮周围留白 ≥ 24px", "priority": "medium" },
      { "id": 21, "item": "卡片内边距 ≥ 16px", "priority": "medium" },
      { "id": 22, "item": "区块间距使用8px的倍数", "priority": "medium" }
    ],
    "components": [
      { "id": 23, "item": "按钮有明确的悬停、按下、禁用状态", "priority": "high" },
      { "id": 24, "item": "输入框聚焦状态有明显的视觉指示", "priority": "high" },
      { "id": 25, "item": "卡片阴影与层级相匹配", "priority": "medium" },
      { "id": 26, "item": "导航当前位置有明确的视觉指示", "priority": "high" },
      { "id": 27, "item": "图标与文字对齐方式一致", "priority": "medium" }
    ],
    "overall": [
      { "id": 28, "item": "整体风格与产品定位一致", "priority": "high" },
      { "id": 29, "item": "动效时长在200-400ms之间", "priority": "medium" },
      { "id": 30, "item": "移动端与桌面端体验一致", "priority": "high" }
    ]
  }
}
```

---

## 附录

### A. 快速参考表

#### A.1 色彩速查

| 用途 | 浅色模式 | 深色模式 |
|------|----------|----------|
| 页面背景 | `#F9FAFB` | `#0A0A0A` |
| 卡片背景 | `#FFFFFF` | `#171717` |
| 主要文字 | `#111827` | `#F5F5F5` |
| 次要文字 | `#6B7280` | `#A3A3A3` |
| 边框 | `#E5E7EB` | `#262626` |
| 分割线 | `#E5E7EB` | `#262626` |

#### A.2 间距速查

| Token | 像素值 | 常用场景 |
|-------|--------|----------|
| `space-1` | 4px | 图标内边距 |
| `space-2` | 8px | 组件内部间距 |
| `space-3` | 12px | 按钮内边距 |
| `space-4` | 16px | 标准间距 |
| `space-6` | 24px | 卡片内边距 |
| `space-8` | 32px | 区块间距 |
| `space-12` | 48px | 页面边距 |
| `space-16` | 64px | 区块分隔 |

#### A.3 字号速查

| Token | 像素值 | 用途 |
|-------|--------|------|
| `text-xs` | 12px | 说明文字 |
| `text-sm` | 14px | 次要文本 |
| `text-base` | 16px | 正文 |
| `text-lg` | 18px | 大正文 |
| `text-xl` | 20px | 小标题 |
| `text-2xl` | 24px | 三级标题 |
| `text-3xl` | 30px | 二级标题 |
| `text-4xl` | 36px | 一级标题 |

---

## 文档信息

- **版本**: 1.0.0
- **更新日期**: 2024-01-15
- **作者**: RUI Design Team
- **分类**: design-system
- **标签**: ui-design, aesthetics, design-system, visual-hierarchy, color-system

---

## 可引用章节锚点

| 章节 | 锚点ID |
|------|--------|
| 视觉层级设计原则 | `#visual-hierarchy` |
| Z轴层级理论 | `#z-axis-hierarchy` |
| 信息密度控制 | `#information-density` |
| 色彩系统设计 | `#color-system` |
| 主色与辅助色 | `#primary-secondary-colors` |
| 语义色彩 | `#semantic-colors` |
| 中性色阶 | `#neutral-colors` |
| 排版系统 | `#typography` |
| 字体栈 | `#font-stack` |
| 字号阶梯 | `#type-scale` |
| 间距系统 | `#spacing` |
| 4px/8px基准 | `#spacing-base` |
| 圆角与阴影策略 | `#radius-shadow` |
| 风格预设分类 | `#style-presets` |
| Data Clarity | `#data-clarity` |
| Bold Productive | `#bold-productive` |
| Warm Friendly | `#warm-friendly` |
| Premium Minimal | `#premium-minimal` |
| Creative Expressive | `#creative-expressive` |
| 组件审美规范 | `#component-aesthetics` |
| 按钮 | `#button-aesthetics` |
| 输入框 | `#input-aesthetics` |
| 卡片 | `#card-aesthetics` |
| 导航 | `#navigation-aesthetics` |
| 审美检查清单 | `#aesthetic-checklist` |
