---
title: "RUI 组件库设计指南"
description: "基于原子设计方法论的企业级React组件库完整设计规范"
version: "1.0.0"
author: "RUI Design Team"
date: "2024-01-15"
tags: ["design-system", "component-library", "atomic-design", "typescript", "accessibility"]
---

# RUI 组件库设计指南

> 基于原子设计方法论的企业级React组件库完整设计规范

---

## 目录

1. [原子设计方法论](#1-原子设计方法论)
2. [Design Tokens 架构](#2-design-tokens-架构)
3. [组件变体策略](#3-组件变体策略)
4. [状态管理规范](#4-状态管理规范)
5. [可访问性要求](#5-可访问性要求)
6. [TypeScript 类型设计](#6-typescript-类型设计)
7. [Storybook 文档规范](#7-storybook-文档规范)
8. [发布流程与版本控制](#8-发布流程与版本控制)
9. [迁移策略](#9-迁移策略)

---

## 1. 原子设计方法论

### 1.1 概述

原子设计（Atomic Design）是由 Brad Frost 提出的一种设计系统方法论，将界面组件分解为五个层次，从最基本的原子到完整的页面。

```
┌─────────────────────────────────────────────────────────┐
│                      原子设计层次                         │
├─────────────────────────────────────────────────────────┤
│  Atoms (原子)        →  最小不可再分的UI元素              │
│  Molecules (分子)    →  原子组合形成的简单组件            │
│  Organisms (有机体)  →  分子组合形成的复杂组件            │
│  Templates (模板)    →  页面布局结构                      │
│  Pages (页面)        →  真实内容填充的完整页面            │
└─────────────────────────────────────────────────────────┘
```

### 1.2 各层详细定义

#### 1.2.1 Atoms (原子)

**定义**：构成界面的最基本元素，无法进一步分解。

**示例组件**：

| 类别 | 组件 | 说明 |
|------|------|------|
| 基础 | `Button`, `Input`, `Label` | 表单基础元素 |
| 排版 | `Text`, `Heading`, `Paragraph` | 文本元素 |
| 图标 | `Icon`, `Avatar` | 视觉元素 |
| 布局 | `Box`, `Stack`, `Grid` | 布局容器 |

**代码示例**：

```tsx
// Atoms/Button/Button.tsx
import React from 'react';
import { styled } from '@rui/styled';

export interface ButtonProps {
  /** 按钮变体 */
  variant?: 'solid' | 'outline' | 'ghost';
  /** 按钮尺寸 */
  size?: 'sm' | 'md' | 'lg';
  /** 是否禁用 */
  disabled?: boolean;
  /** 点击事件 */
  onClick?: () => void;
  /** 子元素 */
  children: React.ReactNode;
}

const StyledButton = styled('button', {
  // 基础样式
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center',
  borderRadius: '$radius-md',
  fontWeight: '$font-weight-medium',
  transition: 'all 200ms ease',
  
  // 变体样式
  variants: {
    variant: {
      solid: {
        backgroundColor: '$primary-500',
        color: '$white',
        '&:hover': { backgroundColor: '$primary-600' },
      },
      outline: {
        backgroundColor: 'transparent',
        border: '1px solid $primary-500',
        color: '$primary-500',
        '&:hover': { backgroundColor: '$primary-50' },
      },
      ghost: {
        backgroundColor: 'transparent',
        color: '$primary-500',
        '&:hover': { backgroundColor: '$primary-50' },
      },
    },
    size: {
      sm: { padding: '$space-2 $space-3', fontSize: '$font-size-sm' },
      md: { padding: '$space-3 $space-4', fontSize: '$font-size-base' },
      lg: { padding: '$space-4 $space-6', fontSize: '$font-size-lg' },
    },
  },
  
  defaultVariants: {
    variant: 'solid',
    size: 'md',
  },
});

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ variant, size, disabled, onClick, children, ...props }, ref) => (
    <StyledButton
      ref={ref}
      variant={variant}
      size={size}
      disabled={disabled}
      onClick={onClick}
      {...props}
    >
      {children}
    </StyledButton>
  )
);

Button.displayName = 'Button';
```

#### 1.2.2 Molecules (分子)

**定义**：由多个原子组合而成的简单功能组件。

**示例组件**：

| 组件 | 组成原子 | 功能说明 |
|------|----------|----------|
| `InputGroup` | Label + Input + ErrorText | 表单输入组 |
| `SearchBar` | Input + Button + Icon | 搜索栏 |
| `CardHeader` | Avatar + Text + Icon | 卡片头部 |
| `Badge` | Icon + Text | 状态标签 |

**代码示例**：

```tsx
// Molecules/InputGroup/InputGroup.tsx
import React from 'react';
import { Label } from '../../Atoms/Label';
import { Input } from '../../Atoms/Input';
import { Text } from '../../Atoms/Text';
import { Box } from '../../Atoms/Box';

export interface InputGroupProps {
  /** 标签文本 */
  label: string;
  /** 输入框占位符 */
  placeholder?: string;
  /** 错误信息 */
  error?: string;
  /** 是否必填 */
  required?: boolean;
  /** 输入值 */
  value?: string;
  /** 值变化回调 */
  onChange?: (value: string) => void;
}

export const InputGroup: React.FC<InputGroupProps> = ({
  label,
  placeholder,
  error,
  required,
  value,
  onChange,
}) => {
  return (
    <Box css={{ display: 'flex', flexDirection: 'column', gap: '$space-2' }}>
      <Label required={required}>{label}</Label>
      <Input
        placeholder={placeholder}
        value={value}
        onChange={(e) => onChange?.(e.target.value)}
        aria-invalid={!!error}
        aria-describedby={error ? 'error-message' : undefined}
      />
      {error && (
        <Text
          id="error-message"
          variant="error"
          size="sm"
          role="alert"
        >
          {error}
        </Text>
      )}
    </Box>
  );
};
```

#### 1.2.3 Organisms (有机体)

**定义**：由分子和原子组合而成的复杂、独立的功能模块。

**示例组件**：

| 组件 | 组成元素 | 功能说明 |
|------|----------|----------|
| `Form` | InputGroup + ButtonGroup + Validation | 完整表单 |
| `DataTable` | Table + Pagination + FilterBar | 数据表格 |
| `Modal` | Overlay + Card + Header + Footer | 模态对话框 |
| `Navigation` | Logo + Menu + UserMenu | 导航栏 |

**代码示例**：

```tsx
// Organisms/LoginForm/LoginForm.tsx
import React, { useState } from 'react';
import { InputGroup } from '../../Molecules/InputGroup';
import { Button } from '../../Atoms/Button';
import { Box, Stack } from '../../Atoms/Layout';
import { validateEmail, validatePassword } from '../../../utils/validation';

export interface LoginFormProps {
  /** 登录回调 */
  onSubmit: (credentials: { email: string; password: string }) => Promise<void>;
  /** 加载状态 */
  isLoading?: boolean;
}

export const LoginForm: React.FC<LoginFormProps> = ({ onSubmit, isLoading }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [errors, setErrors] = useState<{ email?: string; password?: string }>({});

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // 验证
    const newErrors = {
      email: validateEmail(email) || undefined,
      password: validatePassword(password) || undefined,
    };
    
    if (newErrors.email || newErrors.password) {
      setErrors(newErrors);
      return;
    }
    
    await onSubmit({ email, password });
  };

  return (
    <Box as="form" onSubmit={handleSubmit} css={{ width: '100%', maxWidth: '400px' }}>
      <Stack direction="vertical" gap="lg">
        <InputGroup
          label="邮箱地址"
          placeholder="请输入邮箱"
          value={email}
          onChange={setEmail}
          error={errors.email}
          required
        />
        <InputGroup
          label="密码"
          placeholder="请输入密码"
          value={password}
          onChange={setPassword}
          error={errors.password}
          required
        />
        <Button
          type="submit"
          variant="solid"
          size="lg"
          disabled={isLoading}
          css={{ width: '100%' }}
        >
          {isLoading ? '登录中...' : '登录'}
        </Button>
      </Stack>
    </Box>
  );
};
```

#### 1.2.4 Templates (模板)

**定义**：定义页面布局结构，使用占位符表示内容区域。

**代码示例**：

```tsx
// Templates/DashboardTemplate/DashboardTemplate.tsx
import React from 'react';
import { Box, Grid } from '../../Atoms/Layout';

export interface DashboardTemplateProps {
  /** 侧边栏内容 */
  sidebar: React.ReactNode;
  /** 顶部导航 */
  header: React.ReactNode;
  /** 主内容区 */
  main: React.ReactNode;
  /** 底部 */
  footer?: React.ReactNode;
}

export const DashboardTemplate: React.FC<DashboardTemplateProps> = ({
  sidebar,
  header,
  main,
  footer,
}) => {
  return (
    <Grid
      css={{
        gridTemplateAreas: `
          "sidebar header"
          "sidebar main"
          "sidebar footer"
        `,
        gridTemplateColumns: '240px 1fr',
        gridTemplateRows: '64px 1fr auto',
        minHeight: '100vh',
      }}
    >
      <Box css={{ gridArea: 'sidebar' }}>{sidebar}</Box>
      <Box css={{ gridArea: 'header' }}>{header}</Box>
      <Box css={{ gridArea: 'main', padding: '$space-6' }}>{main}</Box>
      {footer && <Box css={{ gridArea: 'footer' }}>{footer}</Box>}
    </Grid>
  );
};
```

#### 1.2.5 Pages (页面)

**定义**：将真实数据填入模板形成的完整页面。

**代码示例**：

```tsx
// Pages/DashboardPage/DashboardPage.tsx
import React from 'react';
import { DashboardTemplate } from '../../Templates/DashboardTemplate';
import { Sidebar } from '../../Organisms/Sidebar';
import { Header } from '../../Organisms/Header';
import { DataTable } from '../../Organisms/DataTable';
import { useUsers } from '../../../hooks/useUsers';

export const DashboardPage: React.FC = () => {
  const { users, isLoading, error } = useUsers();

  return (
    <DashboardTemplate
      sidebar={<Sidebar activeItem="users" />}
      header={<Header title="用户管理" user={{ name: '管理员' }} />}
      main={
        <DataTable
          data={users}
          columns={[
            { key: 'name', title: '姓名' },
            { key: 'email', title: '邮箱' },
            { key: 'role', title: '角色' },
            { key: 'status', title: '状态' },
          ]}
          isLoading={isLoading}
          error={error}
        />
      }
    />
  );
};
```

### 1.3 目录结构规范

```
src/
├── Atoms/                    # 原子组件
│   ├── Button/
│   │   ├── Button.tsx
│   │   ├── Button.test.tsx
│   │   ├── Button.stories.tsx
│   │   └── index.ts
│   ├── Input/
│   ├── Label/
│   └── index.ts
├── Molecules/                # 分子组件
│   ├── InputGroup/
│   ├── SearchBar/
│   └── index.ts
├── Organisms/                # 有机体组件
│   ├── Form/
│   ├── DataTable/
│   └── index.ts
├── Templates/                # 页面模板
│   ├── DashboardTemplate/
│   └── index.ts
├── Pages/                    # 页面组件（可选，通常不在组件库中）
│   └── index.ts
└── index.ts                  # 统一导出
```

---

## 2. Design Tokens 架构

### 2.1 概述

Design Tokens 是设计系统的视觉原子，用于存储颜色、字体、间距等设计决策。它们确保设计在不同平台和团队中保持一致性。

### 2.2 六层架构

```
┌─────────────────────────────────────────────────────────────────┐
│                    Design Tokens 六层架构                         │
├─────────────────────────────────────────────────────────────────┤
│  Layer 6: Component Tokens    →  组件特定样式                     │
│  Layer 5: Semantic Tokens     →  语义化抽象                       │
│  Layer 4: Alias Tokens        →  别名引用                         │
│  Layer 3: Brand Tokens        →  品牌相关                         │
│  Layer 2: System Tokens       →  系统设计                         │
│  Layer 1: Primitive Tokens    →  原始值                          │
└─────────────────────────────────────────────────────────────────┘
```

### 2.3 各层详细定义

#### Layer 1: Primitive Tokens (原始值)

最基础的数值定义，不包含任何语义。

```json
{
  "primitive": {
    "color": {
      "black": { "value": "#000000" },
      "white": { "value": "#FFFFFF" },
      "red": {
        "50": { "value": "#FEF2F2" },
        "100": { "value": "#FEE2E2" },
        "500": { "value": "#EF4444" },
        "600": { "value": "#DC2626" },
        "900": { "value": "#7F1D1D" }
      },
      "blue": {
        "50": { "value": "#EFF6FF" },
        "100": { "value": "#DBEAFE" },
        "500": { "value": "#3B82F6" },
        "600": { "value": "#2563EB" },
        "900": { "value": "#1E3A8A" }
      }
    },
    "font": {
      "family": {
        "sans": { "value": "Inter, system-ui, sans-serif" },
        "mono": { "value": "JetBrains Mono, monospace" }
      },
      "size": {
        "12": { "value": "12px" },
        "14": { "value": "14px" },
        "16": { "value": "16px" },
        "18": { "value": "18px" },
        "20": { "value": "20px" },
        "24": { "value": "24px" }
      },
      "weight": {
        "400": { "value": "400" },
        "500": { "value": "500" },
        "600": { "value": "600" },
        "700": { "value": "700" }
      }
    },
    "space": {
      "0": { "value": "0" },
      "4": { "value": "4px" },
      "8": { "value": "8px" },
      "12": { "value": "12px" },
      "16": { "value": "16px" },
      "24": { "value": "24px" },
      "32": { "value": "32px" },
      "48": { "value": "48px" }
    },
    "radius": {
      "0": { "value": "0" },
      "4": { "value": "4px" },
      "8": { "value": "8px" },
      "12": { "value": "12px" },
      "16": { "value": "16px" },
      "full": { "value": "9999px" }
    },
    "shadow": {
      "sm": { "value": "0 1px 2px 0 rgb(0 0 0 / 0.05)" },
      "md": { "value": "0 4px 6px -1px rgb(0 0 0 / 0.1)" },
      "lg": { "value": "0 10px 15px -3px rgb(0 0 0 / 0.1)" }
    }
  }
}
```

#### Layer 2: System Tokens (系统设计)

定义系统的通用设计决策。

```json
{
  "system": {
    "color": {
      "background": { "value": "{primitive.color.white}" },
      "foreground": { "value": "{primitive.color.black}" }
    },
    "font": {
      "body": { "value": "{primitive.font.family.sans}" },
      "code": { "value": "{primitive.font.family.mono}" }
    }
  }
}
```

#### Layer 3: Brand Tokens (品牌相关)

定义品牌特定的颜色和样式。

```json
{
  "brand": {
    "primary": {
      "50": { "value": "{primitive.color.blue.50}" },
      "100": { "value": "{primitive.color.blue.100}" },
      "500": { "value": "{primitive.color.blue.500}" },
      "600": { "value": "{primitive.color.blue.600}" },
      "900": { "value": "{primitive.color.blue.900}" }
    },
    "danger": {
      "50": { "value": "{primitive.color.red.50}" },
      "500": { "value": "{primitive.color.red.500}" },
      "600": { "value": "{primitive.color.red.600}" }
    }
  }
}
```

#### Layer 4: Alias Tokens (别名引用)

创建语义化的别名，便于理解和使用。

```json
{
  "alias": {
    "color": {
      "text": {
        "primary": { "value": "{system.color.foreground}" },
        "secondary": { "value": "rgba(0, 0, 0, 0.6)" },
        "disabled": { "value": "rgba(0, 0, 0, 0.38)" },
        "inverse": { "value": "{primitive.color.white}" }
      },
      "surface": {
        "default": { "value": "{system.color.background}" },
        "elevated": { "value": "{primitive.color.white}" },
        "overlay": { "value": "rgba(0, 0, 0, 0.5)" }
      },
      "border": {
        "default": { "value": "rgba(0, 0, 0, 0.12)" },
        "hover": { "value": "rgba(0, 0, 0, 0.24)" }
      }
    },
    "font": {
      "size": {
        "xs": { "value": "{primitive.font.size.12}" },
        "sm": { "value": "{primitive.font.size.14}" },
        "base": { "value": "{primitive.font.size.16}" },
        "lg": { "value": "{primitive.font.size.18}" },
        "xl": { "value": "{primitive.font.size.20}" },
        "2xl": { "value": "{primitive.font.size.24}" }
      }
    },
    "space": {
      "1": { "value": "{primitive.space.4}" },
      "2": { "value": "{primitive.space.8}" },
      "3": { "value": "{primitive.space.12}" },
      "4": { "value": "{primitive.space.16}" },
      "6": { "value": "{primitive.space.24}" },
      "8": { "value": "{primitive.space.32}" }
    },
    "radius": {
      "sm": { "value": "{primitive.radius.4}" },
      "md": { "value": "{primitive.radius.8}" },
      "lg": { "value": "{primitive.radius.12}" },
      "xl": { "value": "{primitive.radius.16}" },
      "full": { "value": "{primitive.radius.full}" }
    }
  }
}
```

#### Layer 5: Semantic Tokens (语义化抽象)

为特定用途创建语义化Token。

```json
{
  "semantic": {
    "color": {
      "action": {
        "primary": {
          "default": { "value": "{brand.primary.500}" },
          "hover": { "value": "{brand.primary.600}" },
          "active": { "value": "{brand.primary.900}" },
          "disabled": { "value": "rgba(59, 130, 246, 0.38)" }
        },
        "danger": {
          "default": { "value": "{brand.danger.500}" },
          "hover": { "value": "{brand.danger.600}" }
        }
      },
      "feedback": {
        "success": { "value": "#22C55E" },
        "warning": { "value": "#F59E0B" },
        "error": { "value": "{brand.danger.500}" },
        "info": { "value": "{brand.primary.500}" }
      },
      "state": {
        "hover": { "value": "rgba(0, 0, 0, 0.04)" },
        "selected": { "value": "rgba(59, 130, 246, 0.08)" },
        "focus": { "value": "rgba(59, 130, 246, 0.2)" }
      }
    }
  }
}
```

#### Layer 6: Component Tokens (组件特定)

为特定组件定义样式Token。

```json
{
  "component": {
    "button": {
      "solid": {
        "background": { "value": "{semantic.color.action.primary.default}" },
        "backgroundHover": { "value": "{semantic.color.action.primary.hover}" },
        "color": { "value": "{alias.color.text.inverse}" },
        "padding": { "value": "{alias.space.3} {alias.space.4}" },
        "radius": { "value": "{alias.radius.md}" }
      },
      "outline": {
        "border": { "value": "1px solid {brand.primary.500}" },
        "backgroundHover": { "value": "{brand.primary.50}" },
        "color": { "value": "{brand.primary.500}" }
      }
    },
    "input": {
      "border": { "value": "1px solid {alias.color.border.default}" },
      "borderHover": { "value": "1px solid {alias.color.border.hover}" },
      "borderFocus": { "value": "2px solid {brand.primary.500}" },
      "borderError": { "value": "2px solid {brand.danger.500}" },
      "padding": { "value": "{alias.space.3} {alias.space.4}" },
      "radius": { "value": "{alias.radius.md}" }
    },
    "card": {
      "background": { "value": "{alias.color.surface.elevated}" },
      "shadow": { "value": "{primitive.shadow.md}" },
      "radius": { "value": "{alias.radius.lg}" },
      "padding": { "value": "{alias.space.6}" }
    }
  }
}
```

### 2.4 Token 转换配置

```javascript
// tokens.config.js
module.exports = {
  source: ['tokens/**/*.json'],
  platforms: {
    css: {
      transformGroup: 'css',
      buildPath: 'dist/css/',
      files: [{
        destination: 'tokens.css',
        format: 'css/variables',
        options: {
          outputReferences: true,
        },
      }],
    },
    scss: {
      transformGroup: 'scss',
      buildPath: 'dist/scss/',
      files: [{
        destination: '_tokens.scss',
        format: 'scss/variables',
      }],
    },
    js: {
      transformGroup: 'js',
      buildPath: 'dist/js/',
      files: [{
        destination: 'tokens.js',
        format: 'javascript/es6',
      }],
    },
    ts: {
      transformGroup: 'js',
      buildPath: 'dist/ts/',
      files: [{
        destination: 'tokens.d.ts',
        format: 'typescript/es6-declarations',
      }],
    },
  },
};
```

### 2.5 使用示例

```tsx
// 使用 CSS 变量
import 'rui-tokens/dist/css/tokens.css';

const Button = styled('button', {
  backgroundColor: 'var(--rui-color-action-primary-default)',
  color: 'var(--rui-color-text-inverse)',
  padding: 'var(--rui-space-3) var(--rui-space-4)',
  borderRadius: 'var(--rui-radius-md)',
});

// 使用 JavaScript 导入
import { color, space, radius } from 'rui-tokens';

const Button = styled('button', {
  backgroundColor: color.action.primary.default,
  color: color.text.inverse,
  padding: `${space[3]} ${space[4]}`,
  borderRadius: radius.md,
});
```

---

## 3. 组件变体策略

### 3.1 Variants API 设计模式

采用 **Compound Variants** 模式，支持基于多个属性组合定义样式。

### 3.2 基础变体结构

```tsx
import { styled } from '@rui/styled';

const Component = styled('element', {
  // 基础样式
  baseStyles: { ... },
  
  // 变体定义
  variants: {
    // 单属性变体
    variant: {
      primary: { ... },
      secondary: { ... },
    },
    size: {
      sm: { ... },
      md: { ... },
      lg: { ... },
    },
  },
  
  // 复合变体（多属性组合）
  compoundVariants: [
    {
      variant: 'primary',
      size: 'lg',
      css: { ... },
    },
  ],
  
  // 默认变体
  defaultVariants: {
    variant: 'primary',
    size: 'md',
  },
});
```

### 3.3 完整变体示例

```tsx
// Button.variants.ts
import { styled } from '@rui/styled';

export const StyledButton = styled('button', {
  // 基础样式
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center',
  gap: '$space-2',
  fontFamily: '$font-family-sans',
  fontWeight: '$font-weight-medium',
  lineHeight: '$line-height-tight',
  whiteSpace: 'nowrap',
  transition: 'all 200ms cubic-bezier(0.4, 0, 0.2, 1)',
  cursor: 'pointer',
  border: 'none',
  outline: 'none',
  
  '&:disabled': {
    cursor: 'not-allowed',
    opacity: 0.5,
  },
  
  '&:focus-visible': {
    boxShadow: '0 0 0 2px $colors$primary-200',
  },
  
  // 变体定义
  variants: {
    // 视觉变体
    variant: {
      solid: {},
      outline: {},
      ghost: {},
      link: {},
    },
    
    // 尺寸变体
    size: {
      xs: {
        height: '24px',
        padding: '0 $space-2',
        fontSize: '$font-size-xs',
        borderRadius: '$radius-sm',
      },
      sm: {
        height: '32px',
        padding: '0 $space-3',
        fontSize: '$font-size-sm',
        borderRadius: '$radius-md',
      },
      md: {
        height: '40px',
        padding: '0 $space-4',
        fontSize: '$font-size-base',
        borderRadius: '$radius-md',
      },
      lg: {
        height: '48px',
        padding: '0 $space-6',
        fontSize: '$font-size-lg',
        borderRadius: '$radius-lg',
      },
      xl: {
        height: '56px',
        padding: '0 $space-8',
        fontSize: '$font-size-xl',
        borderRadius: '$radius-lg',
      },
    },
    
    // 颜色变体
    colorScheme: {
      primary: {},
      secondary: {},
      success: {},
      warning: {},
      danger: {},
      neutral: {},
    },
    
    // 宽度变体
    fullWidth: {
      true: {
        width: '100%',
      },
    },
    
    // 圆角变体
    rounded: {
      true: {
        borderRadius: '$radius-full',
      },
    },
  },
  
  // 复合变体 - 定义 variant + colorScheme 的组合
  compoundVariants: [
    // Solid + Primary
    {
      variant: 'solid',
      colorScheme: 'primary',
      css: {
        backgroundColor: '$primary-500',
        color: '$white',
        '&:hover:not(:disabled)': {
          backgroundColor: '$primary-600',
        },
        '&:active:not(:disabled)': {
          backgroundColor: '$primary-700',
        },
      },
    },
    // Solid + Danger
    {
      variant: 'solid',
      colorScheme: 'danger',
      css: {
        backgroundColor: '$danger-500',
        color: '$white',
        '&:hover:not(:disabled)': {
          backgroundColor: '$danger-600',
        },
      },
    },
    // Outline + Primary
    {
      variant: 'outline',
      colorScheme: 'primary',
      css: {
        backgroundColor: 'transparent',
        border: '1px solid $primary-500',
        color: '$primary-500',
        '&:hover:not(:disabled)': {
          backgroundColor: '$primary-50',
        },
      },
    },
    // Ghost + Primary
    {
      variant: 'ghost',
      colorScheme: 'primary',
      css: {
        backgroundColor: 'transparent',
        color: '$primary-500',
        '&:hover:not(:disabled)': {
          backgroundColor: '$primary-50',
        },
      },
    },
    // Link + Primary
    {
      variant: 'link',
      colorScheme: 'primary',
      css: {
        backgroundColor: 'transparent',
        color: '$primary-500',
        padding: 0,
        height: 'auto',
        textDecoration: 'underline',
        '&:hover:not(:disabled)': {
          color: '$primary-600',
        },
      },
    },
  ],
  
  // 默认变体
  defaultVariants: {
    variant: 'solid',
    size: 'md',
    colorScheme: 'primary',
  },
});
```

### 3.4 TypeScript 变体类型

```tsx
// Button.types.ts
import type { VariantProps } from '@rui/styled';
import type { StyledButton } from './Button.variants';

// 从 styled 组件提取变体类型
export type ButtonVariantProps = VariantProps<typeof StyledButton>;

// 完整的 Button Props
export interface ButtonProps extends ButtonVariantProps {
  /** 按钮内容 */
  children: React.ReactNode;
  /** 左侧图标 */
  leftIcon?: React.ReactNode;
  /** 右侧图标 */
  rightIcon?: React.ReactNode;
  /** 加载状态 */
  isLoading?: boolean;
  /** 加载文本 */
  loadingText?: string;
  /** 点击事件 */
  onClick?: () => void;
  /** HTML button type */
  type?: 'button' | 'submit' | 'reset';
}

// 变体组合类型（用于文档）
export type ButtonVariantCombination = 
  | { variant: 'solid'; colorScheme: 'primary' | 'secondary' | 'success' | 'danger' }
  | { variant: 'outline'; colorScheme: 'primary' | 'secondary' | 'neutral' }
  | { variant: 'ghost'; colorScheme: 'primary' | 'neutral' }
  | { variant: 'link'; colorScheme: 'primary' | 'neutral' };
```

### 3.5 变体决策矩阵

| 变体类型 | 适用场景 | 示例值 |
|----------|----------|--------|
| `variant` | 视觉风格 | `solid`, `outline`, `ghost`, `link` |
| `size` | 尺寸层级 | `xs`, `sm`, `md`, `lg`, `xl` |
| `colorScheme` | 颜色主题 | `primary`, `secondary`, `success`, `warning`, `danger`, `neutral` |
| `fullWidth` | 宽度适应 | `true`, `false` |
| `rounded` | 圆角风格 | `true`, `false` |

---

## 4. 状态管理规范

### 4.1 六种核心状态

```
┌─────────────────────────────────────────────────────────────┐
│                      组件状态定义                             │
├─────────────────────────────────────────────────────────────┤
│  Default (默认)    →  组件的初始状态                          │
│  Hover (悬停)      →  鼠标悬停时的状态                        │
│  Focus (焦点)      →  获得键盘焦点时的状态                    │
│  Disabled (禁用)   →  不可交互的状态                          │
│  Loading (加载)    →  异步操作进行中的状态                    │
│  Error (错误)      →  发生错误时的状态                        │
└─────────────────────────────────────────────────────────────┘
```

### 4.2 状态详细定义

#### 4.2.1 Default (默认状态)

```tsx
interface DefaultState {
  /** 状态标识 */
  state: 'default';
  /** 视觉表现 */
  visual: {
    background: 'Token: semantic.color.surface.default';
    border: 'Token: alias.color.border.default';
    color: 'Token: alias.color.text.primary';
    shadow: 'none';
  };
  /** 交互能力 */
  interactive: {
    clickable: true;
    focusable: true;
    hoverable: true;
  };
  /** 动画 */
  animation: {
    duration: '200ms';
    easing: 'cubic-bezier(0.4, 0, 0.2, 1)';
  };
}
```

#### 4.2.2 Hover (悬停状态)

```tsx
interface HoverState {
  /** 状态标识 */
  state: 'hover';
  /** 触发条件 */
  trigger: 'mouseenter' | 'pointerenter';
  /** 视觉表现 */
  visual: {
    background: 'Token: semantic.color.state.hover';
    border: 'Token: alias.color.border.hover';
    color: 'Token: alias.color.text.primary';
    shadow: 'Token: primitive.shadow.sm';
    cursor: 'pointer';
  };
  /** 过渡动画 */
  transition: {
    property: 'background-color, border-color, box-shadow';
    duration: '200ms';
    easing: 'ease-out';
  };
}

// CSS 实现
const hoverStyles = {
  '&:hover:not(:disabled):not([data-loading="true"])': {
    backgroundColor: '$colors$semantic-state-hover',
    borderColor: '$colors$alias-border-hover',
    boxShadow: '$shadows$sm',
  },
};
```

#### 4.2.3 Focus (焦点状态)

```tsx
interface FocusState {
  /** 状态标识 */
  state: 'focus';
  /** 触发条件 */
  trigger: 'keyboard' | 'mouse' | 'programmatic';
  /** 视觉表现 */
  visual: {
    outline: 'none';
    ring: {
      width: '2px';
      color: 'Token: brand.primary.200';
      offset: '2px';
    };
    background: 'Token: semantic.color.state.focus';
  };
  /** 可访问性 */
  a11y: {
    focusVisible: true;  // 仅键盘焦点显示
    tabIndex: 0;
  };
}

// CSS 实现
const focusStyles = {
  '&:focus': {
    outline: 'none',
  },
  '&:focus-visible': {
    boxShadow: '0 0 0 2px $colors$primary-200',
    backgroundColor: '$colors$semantic-state-focus',
  },
};
```

#### 4.2.4 Disabled (禁用状态)

```tsx
interface DisabledState {
  /** 状态标识 */
  state: 'disabled';
  /** 触发条件 */
  trigger: 'prop: disabled' | 'HTML: disabled' | 'parent: disabled';
  /** 视觉表现 */
  visual: {
    background: 'Token: semantic.color.action.primary.disabled';
    border: 'Token: alias.color.border.default';
    color: 'Token: alias.color.text.disabled';
    opacity: 0.5;
  };
  /** 交互能力 */
  interactive: {
    clickable: false;
    focusable: false;
    hoverable: false;
    pointerEvents: 'none';
  };
  /** 可访问性 */
  a11y: {
    ariaDisabled: true;
    tabIndex: -1;
  };
}

// CSS 实现
const disabledStyles = {
  '&:disabled, &[aria-disabled="true"], &[data-disabled="true"]': {
    backgroundColor: '$colors$semantic-action-primary-disabled',
    color: '$colors$alias-text-disabled',
    opacity: 0.5,
    cursor: 'not-allowed',
    pointerEvents: 'none',
  },
};
```

#### 4.2.5 Loading (加载状态)

```tsx
interface LoadingState {
  /** 状态标识 */
  state: 'loading';
  /** 触发条件 */
  trigger: 'prop: isLoading' | 'async action';
  /** 视觉表现 */
  visual: {
    background: 'Token: semantic.color.action.primary.default';
    opacity: 0.8;
    spinner: {
      size: '1em';
      color: 'currentColor';
    };
  };
  /** 交互能力 */
  interactive: {
    clickable: false;
    hoverable: false;
  };
  /** 内容 */
  content: {
    originalText: 'hidden';
    loadingText: 'optional';
    spinner: 'visible';
  };
}

// React 实现
const Button: React.FC<ButtonProps> = ({ 
  children, 
  isLoading, 
  loadingText,
  disabled,
  ...props 
}) => {
  return (
    <button
      disabled={disabled || isLoading}
      data-loading={isLoading}
      aria-busy={isLoading}
      {...props}
    >
      {isLoading && (
        <Spinner 
          size="1em" 
          aria-hidden="true"
        />
      )}
      {isLoading ? (loadingText || children) : children}
    </button>
  );
};
```

#### 4.2.6 Error (错误状态)

```tsx
interface ErrorState {
  /** 状态标识 */
  state: 'error';
  /** 触发条件 */
  trigger: 'validation: failed' | 'api: error' | 'prop: hasError';
  /** 视觉表现 */
  visual: {
    border: 'Token: brand.danger.500';
    background: 'Token: brand.danger.50';
    color: 'Token: brand.danger.500';
    icon: 'ErrorIcon';
  };
  /** 反馈 */
  feedback: {
    message: 'string';
    position: 'below' | 'tooltip';
  };
  /** 可访问性 */
  a11y: {
    ariaInvalid: true;
    ariaDescribedBy: 'error-message-id';
    role: 'alert';
  };
}

// React 实现
const Input: React.FC<InputProps> = ({ 
  error,
  errorMessage,
  ...props 
}) => {
  const errorId = error ? `${props.id}-error` : undefined;
  
  return (
    <div>
      <input
        aria-invalid={error}
        aria-describedby={errorId}
        data-error={error}
        {...props}
      />
      {error && (
        <Text
          id={errorId}
          variant="error"
          size="sm"
          role="alert"
        >
          {errorMessage}
        </Text>
      )}
    </div>
  );
};
```

### 4.3 状态优先级

```
状态优先级（从高到低）：

1. Disabled (最高优先级)
   - 覆盖所有其他状态
   - 完全禁用交互

2. Loading
   - 仅次于 Disabled
   - 显示加载状态，禁用点击

3. Error
   - 显示错误样式
   - 不影响交互（除非配合 disabled）

4. Focus
   - 键盘焦点状态
   - 使用 :focus-visible 避免鼠标焦点环

5. Hover
   - 鼠标悬停状态
   - 不影响 Focus 状态

6. Default (最低优先级)
   - 基础默认样式
```

### 4.4 状态组合表

| 组合 | 效果 | 说明 |
|------|------|------|
| Default + Hover | 悬停样式 | 正常交互 |
| Default + Focus | 焦点环 | 键盘导航 |
| Disabled + Hover | 无变化 | Disabled 优先 |
| Loading + Hover | 无变化 | Loading 优先 |
| Error + Focus | 错误边框 + 焦点环 | 两者都显示 |
| Error + Hover | 错误样式 + 悬停背景 | 叠加效果 |

---

## 5. 可访问性要求

### 5.1 WCAG 2.1 AA 标准对照表

```
┌─────────────────────────────────────────────────────────────────────┐
│                    WCAG 2.1 AA 合规性检查表                          │
├─────────────────────────────────────────────────────────────────────┤
│  原则1: 可感知性 (Perceivable)                                       │
│  原则2: 可操作性 (Operable)                                          │
│  原则3: 可理解性 (Understandable)                                    │
│  原则4: 健壮性 (Robust)                                              │
└─────────────────────────────────────────────────────────────────────┘
```

#### 5.1.1 色彩对比度要求

| 元素类型 | 最小对比度 | 增强对比度 | 测试工具 |
|----------|------------|------------|----------|
| 普通文本 | 4.5:1 | 7:1 | WebAIM Contrast Checker |
| 大文本 (18pt+/14pt bold) | 3:1 | 4.5:1 | Stark |
| UI 组件边界 | 3:1 | - | axe DevTools |
| 图形元素 | 3:1 | - | Color Contrast Analyzer |

**Token 配置示例**：

```json
{
  "a11y": {
    "contrast": {
      "minimum": {
        "normal": { "value": 4.5 },
        "large": { "value": 3 },
        "ui": { "value": 3 }
      },
      "enhanced": {
        "normal": { "value": 7 },
        "large": { "value": 4.5 }
      }
    },
    "colorPairs": {
      "textOnPrimary": {
        "foreground": { "value": "{primitive.color.white}" },
        "background": { "value": "{brand.primary.500}" },
        "contrast": { "value": 7.2 }
      },
      "textOnSurface": {
        "foreground": { "value": "{alias.color.text.primary}" },
        "background": { "value": "{alias.color.surface.default}" },
        "contrast": { "value": 15.3 }
      }
    }
  }
}
```

#### 5.1.2 键盘导航要求

| 要求 | 标准 | 实现方式 |
|------|------|----------|
| 所有功能可键盘访问 | WCAG 2.1.1 | `tabIndex`, 事件监听 |
| 无键盘陷阱 | WCAG 2.1.2 | `Escape` 退出 |
| 焦点顺序逻辑 | WCAG 2.4.3 | DOM 顺序 |
| 焦点可见 | WCAG 2.4.7 | `:focus-visible` 样式 |
| 绕过块 | WCAG 2.4.1 | Skip Link |

**键盘导航实现**：

```tsx
// 键盘导航 Hook
export const useKeyboardNavigation = () => {
  const handleKeyDown = (event: KeyboardEvent) => {
    switch (event.key) {
      case 'Tab':
        // 自然 Tab 顺序
        break;
      case 'Enter':
      case ' ':
        // 激活按钮
        event.preventDefault();
        activate();
        break;
      case 'Escape':
        // 关闭/取消
        event.preventDefault();
        close();
        break;
      case 'ArrowDown':
      case 'ArrowUp':
        // 列表导航
        event.preventDefault();
        navigateList(event.key);
        break;
      case 'Home':
        // 跳转到开头
        event.preventDefault();
        goToFirst();
        break;
      case 'End':
        // 跳转到末尾
        event.preventDefault();
        goToLast();
        break;
    }
  };

  return { handleKeyDown };
};
```

#### 5.1.3 ARIA 属性规范

| 组件类型 | 必需 ARIA | 推荐 ARIA |
|----------|-----------|-----------|
| Button | `aria-label` (无文本时) | `aria-pressed`, `aria-expanded` |
| Input | `aria-label`/`aria-labelledby`, `aria-describedby` | `aria-required`, `aria-invalid` |
| Modal | `role="dialog"`, `aria-modal="true"` | `aria-labelledby` |
| Tabs | `role="tablist"`, `role="tab"`, `role="tabpanel"` | `aria-selected`, `aria-controls` |
| Menu | `role="menu"`, `role="menuitem"` | `aria-haspopup`, `aria-expanded` |
| Alert | `role="alert"` | `aria-live="polite"` |

**ARIA 实现示例**：

```tsx
// Button ARIA
interface AccessibleButtonProps {
  /** 按钮文本（优先） */
  children?: React.ReactNode;
  /** 无文本时的标签 */
  'aria-label'?: string;
  /** 关联描述元素ID */
  'aria-describedby'?: string;
  /** 按下状态（切换按钮） */
  'aria-pressed'?: boolean;
  /** 展开状态（下拉按钮） */
  'aria-expanded'?: boolean;
  /** 控制元素ID */
  'aria-controls'?: string;
  /** 是否有弹出菜单 */
  'aria-haspopup'?: boolean | 'menu' | 'dialog';
}

const AccessibleButton: React.FC<AccessibleButtonProps> = ({
  children,
  'aria-label': ariaLabel,
  'aria-describedby': ariaDescribedBy,
  'aria-pressed': ariaPressed,
  'aria-expanded': ariaExpanded,
  'aria-controls': ariaControls,
  'aria-haspopup': ariaHasPopup,
  ...props
}) => {
  // 验证：无文本时必须提供 aria-label
  if (!children && !ariaLabel) {
    console.warn('Button: 无文本内容时必须提供 aria-label');
  }

  return (
    <button
      aria-label={ariaLabel}
      aria-describedby={ariaDescribedBy}
      aria-pressed={ariaPressed}
      aria-expanded={ariaExpanded}
      aria-controls={ariaControls}
      aria-haspopup={ariaHasPopup}
      {...props}
    >
      {children}
    </button>
  );
};
```

### 5.2 可访问性测试清单

```tsx
// 可访问性测试模板
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

describe('Component Accessibility', () => {
  it('应通过 axe 可访问性检查', async () => {
    const { container } = render(<Component />);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });

  it('应支持键盘导航', async () => {
    render(<Component />);
    const element = screen.getByRole('button');
    
    // Tab 导航
    await userEvent.tab();
    expect(element).toHaveFocus();
    
    // Enter 激活
    await userEvent.keyboard('{Enter}');
    expect(onActivate).toHaveBeenCalled();
    
    // Space 激活
    await userEvent.keyboard(' ');
    expect(onActivate).toHaveBeenCalled();
  });

  it('应有正确的 ARIA 属性', () => {
    render(<Component aria-label="描述" />);
    const element = screen.getByRole('button');
    expect(element).toHaveAttribute('aria-label', '描述');
  });

  it('应有足够的色彩对比度', () => {
    render(<Component />);
    // 使用 axe 或自定义对比度检查
  });
});
```

---

## 6. TypeScript 类型设计

### 6.1 类型设计原则

1. **显式优于隐式**：所有 Props 都应有明确的类型定义
2. **可扩展性**：使用泛型支持自定义扩展
3. **可推导性**：利用 TypeScript 的类型推导能力
4. **文档化**：类型即文档，添加 JSDoc 注释

### 6.2 组件 Props 类型模式

```tsx
// 基础 Props 类型
import type { ComponentPropsWithoutRef, ElementType, ReactNode } from 'react';

// 1. Polymorphic Component (多态组件)
export type AsProp<C extends ElementType = ElementType> = {
  /** 渲染的元素类型 */
  as?: C;
};

export type PropsToOmit<C extends ElementType, P> = keyof (AsProp<C> & P);

export type PolymorphicComponentProp<
  C extends ElementType,
  Props = {}
> = AsProp<C> &
  Omit<ComponentPropsWithoutRef<C>, PropsToOmit<C, Props>> &
  Props;

// 使用示例
export interface ButtonOwnProps {
  /** 变体 */
  variant?: 'solid' | 'outline' | 'ghost';
  /** 尺寸 */
  size?: 'sm' | 'md' | 'lg';
  /** 是否加载中 */
  isLoading?: boolean;
}

export type ButtonProps<C extends ElementType = 'button'> = PolymorphicComponentProp<
  C,
  ButtonOwnProps
>;

// 2. 变体 Props 类型
import type { VariantProps } from '@rui/styled';

export type StyledButtonVariants = VariantProps<typeof StyledButton>;

// 3. 完整组件 Props
export interface ComponentProps extends StyledButtonVariants {
  /** 子元素 */
  children: ReactNode;
  /** 类名 */
  className?: string;
  /** 样式 */
  style?: CSSProperties;
}
```

### 6.3 类型工具库

```tsx
// types/utils.ts

/** 可空类型 */
export type Nullable<T> = T | null | undefined;

/** 必需字段 */
export type RequiredFields<T, K extends keyof T> = T & Required<Pick<T, K>>;

/** 可选字段 */
export type OptionalFields<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>;

/** 值类型 */
export type ValueOf<T> = T[keyof T];

/** 深度可选 */
export type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P];
};

/** 事件处理函数 */
export type EventHandler<E extends Event = Event> = (event: E) => void;

/** 异步函数 */
export type AsyncFunction<T = void, Args extends unknown[] = []> = (
  ...args: Args
) => Promise<T>;

/** 大小枚举 */
export type Size = 'xs' | 'sm' | 'md' | 'lg' | 'xl';

/** 颜色枚举 */
export type ColorScheme = 'primary' | 'secondary' | 'success' | 'warning' | 'danger' | 'neutral';

/** 位置枚举 */
export type Placement = 'top' | 'bottom' | 'left' | 'right';

/** 对齐枚举 */
export type Alignment = 'start' | 'center' | 'end';
```

### 6.4 完整组件类型示例

```tsx
// types/button.ts
import type { 
  ComponentPropsWithoutRef, 
  ElementType, 
  ReactNode,
  MouseEvent,
  KeyboardEvent,
  FocusEvent
} from 'react';
import type { VariantProps } from '@rui/styled';

// ============================================
// 基础类型
// ============================================

/** 按钮变体 */
export type ButtonVariant = 'solid' | 'outline' | 'ghost' | 'link';

/** 按钮尺寸 */
export type ButtonSize = 'xs' | 'sm' | 'md' | 'lg' | 'xl';

/** 按钮颜色方案 */
export type ButtonColorScheme = ColorScheme;

/** 按钮类型 */
export type ButtonType = 'button' | 'submit' | 'reset';

// ============================================
// 样式变体类型
// ============================================

export interface ButtonStyleVariants {
  /** 视觉变体 */
  variant?: ButtonVariant;
  /** 尺寸变体 */
  size?: ButtonSize;
  /** 颜色方案 */
  colorScheme?: ButtonColorScheme;
  /** 是否全宽 */
  fullWidth?: boolean;
  /** 是否圆角 */
  rounded?: boolean;
}

// ============================================
// 事件处理类型
// ============================================

export interface ButtonEventHandlers {
  /** 点击事件 */
  onClick?: (event: MouseEvent<HTMLButtonElement>) => void;
  /** 双击事件 */
  onDoubleClick?: (event: MouseEvent<HTMLButtonElement>) => void;
  /** 鼠标按下事件 */
  onMouseDown?: (event: MouseEvent<HTMLButtonElement>) => void;
  /** 鼠标抬起事件 */
  onMouseUp?: (event: MouseEvent<HTMLButtonElement>) => void;
  /** 键盘按下事件 */
  onKeyDown?: (event: KeyboardEvent<HTMLButtonElement>) => void;
  /** 获得焦点事件 */
  onFocus?: (event: FocusEvent<HTMLButtonElement>) => void;
  /** 失去焦点事件 */
  onBlur?: (event: FocusEvent<HTMLButtonElement>) => void;
}

// ============================================
// ARIA 类型
// ============================================

export interface ButtonAriaProps {
  /** 标签（无文本时必需） */
  'aria-label'?: string;
  /** 描述元素ID */
  'aria-describedby'?: string;
  /** 按下状态 */
  'aria-pressed'?: boolean;
  /** 展开状态 */
  'aria-expanded'?: boolean;
  /** 控制元素ID */
  'aria-controls'?: string;
  /** 是否有弹出菜单 */
  'aria-haspopup'?: boolean | 'menu' | 'dialog' | 'listbox' | 'tree' | 'grid';
  /** 是否隐藏 */
  'aria-hidden'?: boolean;
}

// ============================================
// 完整 Props 类型
// ============================================

export interface ButtonOwnProps extends 
  ButtonStyleVariants,
  ButtonEventHandlers,
  ButtonAriaProps {
  /** 按钮内容 */
  children?: ReactNode;
  /** 左侧图标 */
  leftIcon?: ReactNode;
  /** 右侧图标 */
  rightIcon?: ReactNode;
  /** 加载状态 */
  isLoading?: boolean;
  /** 加载文本 */
  loadingText?: string;
  /** 禁用状态 */
  disabled?: boolean;
  /** HTML 按钮类型 */
  type?: ButtonType;
  /** 表单 ID */
  form?: string;
  /** 名称 */
  name?: string;
  /** 值 */
  value?: string | number;
  /** 自动聚焦 */
  autoFocus?: boolean;
  /** 类名 */
  className?: string;
  /** 内联样式 */
  style?: React.CSSProperties;
  /** ID */
  id?: string;
  /** 测试 ID */
  'data-testid'?: string;
}

/** 多态按钮 Props */
export type ButtonProps<C extends ElementType = 'button'> = 
  PolymorphicComponentProp<C, ButtonOwnProps>;

// ============================================
// Ref 类型
// ============================================

export type ButtonRef<C extends ElementType = 'button'> = 
  ComponentPropsWithoutRef<C>['ref'];

// ============================================
// 组件类型
// ============================================

export type ButtonComponent = <C extends ElementType = 'button'>(
  props: ButtonProps<C>
) => React.ReactElement | null;
```

### 6.5 类型导出规范

```tsx
// index.ts
// 导出所有类型
export type {
  // 基础类型
  ButtonVariant,
  ButtonSize,
  ButtonColorScheme,
  ButtonType,
  
  // Props 类型
  ButtonOwnProps,
  ButtonProps,
  ButtonStyleVariants,
  ButtonEventHandlers,
  ButtonAriaProps,
  
  // Ref 类型
  ButtonRef,
  
  // 组件类型
  ButtonComponent,
} from './types/button';

// 导出工具类型
export type {
  Size,
  ColorScheme,
  Placement,
  Alignment,
  PolymorphicComponentProp,
} from './types/utils';
```

---

## 7. Storybook 文档规范

### 7.1 文档结构

每个组件的 Storybook 文档应包含：

```
ComponentName/
├── ComponentName.stories.tsx    # Story 定义
├── ComponentName.mdx            # 文档页面
└── examples/                    # 示例代码
    ├── BasicExample.tsx
    ├── AdvancedExample.tsx
    └── Playground.tsx
```

### 7.2 Stories 文件规范

```tsx
// Button.stories.tsx
import type { Meta, StoryObj } from '@storybook/react';
import { Button } from './Button';
import { within, userEvent, expect } from '@storybook/test';

// ============================================
// Meta 配置
// ============================================

const meta: Meta<typeof Button> = {
  // 组件标题（分类/组件名）
  title: 'Atoms/Button',
  
  // 组件
  component: Button,
  
  // 参数配置
  parameters: {
    // 文档配置
    docs: {
      description: {
        component: '按钮组件用于触发操作或事件。',
      },
    },
    // 布局
    layout: 'centered',
    // 背景
    backgrounds: {
      default: 'light',
      values: [
        { name: 'light', value: '#ffffff' },
        { name: 'dark', value: '#1a1a1a' },
      ],
    },
    // 设计稿
    design: {
      type: 'figma',
      url: 'https://www.figma.com/file/...',
    },
    // 可访问性
    a11y: {
      config: {
        rules: [
          { id: 'color-contrast', enabled: true },
        ],
      },
    },
  },
  
  // 标签
  tags: ['autodocs', 'a11y-tested'],
  
  // 参数类型
  argTypes: {
    variant: {
      description: '按钮视觉变体',
      control: 'select',
      options: ['solid', 'outline', 'ghost', 'link'],
      table: {
        type: { summary: 'ButtonVariant' },
        defaultValue: { summary: 'solid' },
      },
    },
    size: {
      description: '按钮尺寸',
      control: 'select',
      options: ['xs', 'sm', 'md', 'lg', 'xl'],
      table: {
        type: { summary: 'ButtonSize' },
        defaultValue: { summary: 'md' },
      },
    },
    colorScheme: {
      description: '颜色方案',
      control: 'select',
      options: ['primary', 'secondary', 'success', 'warning', 'danger', 'neutral'],
    },
    isLoading: {
      description: '加载状态',
      control: 'boolean',
    },
    disabled: {
      description: '禁用状态',
      control: 'boolean',
    },
    onClick: {
      description: '点击事件',
      action: 'clicked',
    },
    children: {
      description: '按钮内容',
      control: 'text',
    },
  },
  
  // 默认参数
  args: {
    variant: 'solid',
    size: 'md',
    colorScheme: 'primary',
    children: '按钮',
  },
};

export default meta;

// ============================================
// Story 定义
// ============================================

type Story = StoryObj<typeof Button>;

/**
 * ### 默认按钮
 * 
 * 最基础的按钮样式，使用 `solid` 变体和 `primary` 颜色方案。
 */
export const Default: Story = {};

/**
 * ### 变体展示
 * 
 * 展示所有可用的按钮变体。
 */
export const Variants: Story = {
  render: (args) => (
    <div style={{ display: 'flex', gap: '16px', flexWrap: 'wrap' }}>
      <Button {...args} variant="solid">Solid</Button>
      <Button {...args} variant="outline">Outline</Button>
      <Button {...args} variant="ghost">Ghost</Button>
      <Button {...args} variant="link">Link</Button>
    </div>
  ),
  parameters: {
    docs: {
      description: {
        story: `
- **Solid**: 实心按钮，用于主要操作
- **Outline**: 描边按钮，用于次要操作
- **Ghost**: 幽灵按钮，用于低优先级操作
- **Link**: 链接样式，用于导航
        `,
      },
    },
  },
};

/**
 * ### 尺寸展示
 * 
 * 展示所有可用的按钮尺寸。
 */
export const Sizes: Story = {
  render: (args) => (
    <div style={{ display: 'flex', gap: '16px', alignItems: 'center' }}>
      <Button {...args} size="xs">Extra Small</Button>
      <Button {...args} size="sm">Small</Button>
      <Button {...args} size="md">Medium</Button>
      <Button {...args} size="lg">Large</Button>
      <Button {...args} size="xl">Extra Large</Button>
    </div>
  ),
};

/**
 * ### 颜色方案
 * 
 * 展示所有可用的颜色方案。
 */
export const ColorSchemes: Story = {
  render: (args) => (
    <div style={{ display: 'flex', gap: '16px', flexWrap: 'wrap' }}>
      <Button {...args} colorScheme="primary">Primary</Button>
      <Button {...args} colorScheme="secondary">Secondary</Button>
      <Button {...args} colorScheme="success">Success</Button>
      <Button {...args} colorScheme="warning">Warning</Button>
      <Button {...args} colorScheme="danger">Danger</Button>
      <Button {...args} colorScheme="neutral">Neutral</Button>
    </div>
  ),
};

/**
 * ### 加载状态
 * 
 * 按钮在异步操作时的加载状态。
 */
export const Loading: Story = {
  args: {
    isLoading: true,
    children: '保存',
    loadingText: '保存中...',
  },
  parameters: {
    docs: {
      description: {
        story: '设置 `isLoading` 为 `true` 显示加载状态，按钮将显示加载动画并禁用点击。',
      },
    },
  },
};

/**
 * ### 禁用状态
 * 
 * 按钮的禁用状态。
 */
export const Disabled: Story = {
  args: {
    disabled: true,
    children: '禁用按钮',
  },
};

/**
 * ### 带图标
 * 
 * 带图标的按钮。
 */
export const WithIcons: Story = {
  render: (args) => (
    <div style={{ display: 'flex', gap: '16px', flexWrap: 'wrap' }}>
      <Button {...args} leftIcon={<span>👈</span>}>左图标</Button>
      <Button {...args} rightIcon={<span>👉</span>}>右图标</Button>
      <Button {...args} leftIcon={<span>🔍</span>} variant="outline">搜索</Button>
    </div>
  ),
};

/**
 * ### 交互测试
 * 
 * 包含交互测试的 Story。
 */
export const WithInteractionTest: Story = {
  args: {
    children: '点击我',
  },
  play: async ({ canvasElement, args }) => {
    const canvas = within(canvasElement);
    const button = canvas.getByRole('button');
    
    // 点击按钮
    await userEvent.click(button);
    
    // 验证点击事件被触发
    expect(args.onClick).toHaveBeenCalled();
    
    // 验证按钮可聚焦
    await userEvent.tab();
    expect(button).toHaveFocus();
    
    // 验证 Enter 键可激活
    await userEvent.keyboard('{Enter}');
    expect(args.onClick).toHaveBeenCalledTimes(2);
  },
};

/**
 * ### Playground
 * 
 * 可交互的 Playground，可以调整所有参数。
 */
export const Playground: Story = {
  parameters: {
    docs: {
      canvas: {
        sourceState: 'shown',
      },
    },
  },
};
```

### 7.3 MDX 文档规范

```mdx
{/* Button.mdx */}
import { Meta, Canvas, Story, Controls, Primary } from '@storybook/blocks';
import * as ButtonStories from './Button.stories';

<Meta of={ButtonStories} />

# Button 按钮

按钮组件用于触发操作或事件，是界面中最常用的交互元素。

## 概述

Button 组件支持多种变体、尺寸和颜色方案，适用于不同的使用场景。

<Primary />

## Props

<Controls />

## 变体

### Solid (实心)

用于主要操作，视觉权重最高。

<Canvas of={ButtonStories.Variants} />

### Outline (描边)

用于次要操作，视觉权重适中。

### Ghost (幽灵)

用于低优先级操作，视觉权重最低。

### Link (链接)

用于导航操作，外观类似文本链接。

## 尺寸

<Canvas of={ButtonStories.Sizes} />

## 颜色方案

<Canvas of={ButtonStories.ColorSchemes} />

## 状态

### 加载状态

<Canvas of={ButtonStories.Loading} />

### 禁用状态

<Canvas of={ButtonStories.Disabled} />

## 最佳实践

### ✅ 推荐用法

- 使用 `solid` 变体表示主要操作
- 每页只使用一个主要按钮
- 使用描述性的按钮文本

### ❌ 避免用法

- 不要在一行中使用过多按钮
- 避免使用模糊的按钮文本（如"点击这里"）
- 不要在加载状态下允许重复点击

## 可访问性

- 支持键盘导航（Tab、Enter、Space）
- 支持屏幕阅读器
- 满足 WCAG 2.1 AA 色彩对比度要求

## 代码示例

```tsx
import { Button } from '@rui/react';

// 基础用法
<Button>点击我</Button>

// 带变体
<Button variant="outline" colorScheme="danger">
  删除
</Button>

// 加载状态
<Button isLoading loadingText="保存中...">
  保存
</Button>
```
```

### 7.4 Storybook 配置

```tsx
// .storybook/main.ts
import type { StorybookConfig } from '@storybook/react-vite';

const config: StorybookConfig = {
  stories: ['../src/**/*.mdx', '../src/**/*.stories.@(js|jsx|ts|tsx)'],
  
  addons: [
    '@storybook/addon-links',
    '@storybook/addon-essentials',
    '@storybook/addon-interactions',
    '@storybook/addon-a11y',
    '@storybook/addon-designs',
  ],
  
  framework: {
    name: '@storybook/react-vite',
    options: {},
  },
  
  typescript: {
    check: false,
    reactDocgen: 'react-docgen-typescript',
    reactDocgenTypescriptOptions: {
      shouldExtractLiteralValuesFromEnum: true,
      propFilter: (prop) => (prop.parent ? !/node_modules/.test(prop.parent.fileName) : true),
    },
  },
  
  docs: {
    autodocs: 'tag',
    defaultName: 'Documentation',
  },
};

export default config;
```

```tsx
// .storybook/preview.ts
import type { Preview } from '@storybook/react';
import { withThemeByClassName } from '@storybook/addon-themes';

const preview: Preview = {
  parameters: {
    actions: { argTypesRegex: '^on[A-Z].*' },
    
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/,
      },
    },
    
    a11y: {
      config: {
        rules: [
          { id: 'color-contrast', enabled: true },
        ],
      },
    },
    
    backgrounds: {
      default: 'light',
      values: [
        { name: 'light', value: '#ffffff' },
        { name: 'dark', value: '#1a1a1a' },
      ],
    },
    
    viewport: {
      viewports: {
        mobile: {
          name: 'Mobile',
          styles: { width: '375px', height: '667px' },
        },
        tablet: {
          name: 'Tablet',
          styles: { width: '768px', height: '1024px' },
        },
        desktop: {
          name: 'Desktop',
          styles: { width: '1440px', height: '900px' },
        },
      },
    },
  },
  
  decorators: [
    withThemeByClassName({
      themes: {
        light: 'rui-theme-light',
        dark: 'rui-theme-dark',
      },
      defaultTheme: 'light',
    }),
  ],
};

export default preview;
```

---

## 8. 发布流程与版本控制

### 8.1 语义化版本 (SemVer)

```
版本格式: MAJOR.MINOR.PATCH

MAJOR (主版本): 不兼容的 API 修改
MINOR (次版本): 向下兼容的功能新增
PATCH (修订版本): 向下兼容的问题修复

示例:
1.0.0 → 1.0.1 (Bug 修复)
1.0.0 → 1.1.0 (新功能)
1.0.0 → 2.0.0 (破坏性变更)
```

### 8.2 版本发布流程

```
┌─────────────────────────────────────────────────────────────────┐
│                        发布流程图                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. 开发阶段                                                     │
│     ├── 功能开发 → feature/* 分支                               │
│     ├── Bug 修复 → fix/* 分支                                   │
│     └── 代码审查 → Pull Request                                 │
│                          ↓                                      │
│  2. 合并到 develop 分支                                          │
│     ├── 自动化测试                                               │
│     ├── Storybook 构建                                          │
│     └── 预览部署                                                 │
│                          ↓                                      │
│  3. 发布准备 (Release Branch)                                    │
│     ├── git flow release start v1.1.0                           │
│     ├── 版本号更新                                               │
│     ├── CHANGELOG 更新                                          │
│     └── 最终测试                                                 │
│                          ↓                                      │
│  4. 正式发布                                                     │
│     ├── git flow release finish v1.1.0                          │
│     ├── 打标签 git tag v1.1.0                                   │
│     ├── 构建生产包                                               │
│     └── npm publish                                             │
│                          ↓                                      │
│  5. 发布后                                                       │
│     ├── GitHub Release                                          │
│     ├── 文档更新                                                 │
│     └── 通知团队                                                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 8.3 版本管理配置

```json
// package.json
{
  "name": "@rui/react",
  "version": "1.0.0",
  "description": "RUI React Component Library",
  "main": "dist/index.js",
  "module": "dist/index.esm.js",
  "types": "dist/index.d.ts",
  "files": [
    "dist",
    "README.md",
    "LICENSE"
  ],
  "scripts": {
    "build": "rollup -c",
    "build:tokens": "style-dictionary build",
    "test": "jest",
    "test:a11y": "jest --testPathPattern=a11y",
    "lint": "eslint src --ext .ts,.tsx",
    "typecheck": "tsc --noEmit",
    "storybook": "storybook dev -p 6006",
    "storybook:build": "storybook build",
    "prepublishOnly": "npm run build && npm run test",
    "version:patch": "npm version patch",
    "version:minor": "npm version minor",
    "version:major": "npm version major"
  },
  "publishConfig": {
    "access": "public",
    "registry": "https://registry.npmjs.org/"
  }
}
```

### 8.4 变更日志规范

```markdown
<!-- CHANGELOG.md -->
# Changelog

所有 notable 变更都将记录在此文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本号遵循 [Semantic Versioning](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### Added
- 新增 `DatePicker` 组件
- 新增 `TimePicker` 组件

### Changed
- 优化 `Button` 组件的加载状态动画

### Fixed
- 修复 `Modal` 在 iOS Safari 上的滚动问题

## [1.1.0] - 2024-01-15

### Added
- 新增 `DataTable` 组件的排序功能
- 新增 `Select` 组件的多选模式

### Changed
- 更新 `Input` 组件的默认样式
- 提升 `Button` 组件的可访问性

### Deprecated
- 废弃 `OldComponent`，将在 v2.0.0 中移除

### Fixed
- 修复 `Tooltip` 在边界检测时的偏移问题

### Security
- 更新依赖包以修复安全漏洞

## [1.0.1] - 2024-01-10

### Fixed
- 修复 `Button` 组件在禁用状态下的样式问题

## [1.0.0] - 2024-01-01

### Added
- 初始发布
- 包含 30+ 基础组件
- 完整的 TypeScript 类型支持
- Storybook 文档
```

### 8.5 自动化发布脚本

```bash
#!/bin/bash
# scripts/release.sh

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 获取版本类型
VERSION_TYPE=$1

if [ -z "$VERSION_TYPE" ]; then
  echo -e "${RED}错误: 请指定版本类型 (patch|minor|major)${NC}"
  exit 1
fi

# 验证版本类型
if [[ ! "$VERSION_TYPE" =~ ^(patch|minor|major)$ ]]; then
  echo -e "${RED}错误: 版本类型必须是 patch、minor 或 major${NC}"
  exit 1
fi

echo -e "${YELLOW}开始发布流程...${NC}"

# 1. 检查工作区是否干净
if [ -n "$(git status --porcelain)" ]; then
  echo -e "${RED}错误: 工作区有未提交的变更${NC}"
  git status
  exit 1
fi

# 2. 切换到 main 分支并拉取最新代码
echo -e "${YELLOW}更新 main 分支...${NC}"
git checkout main
git pull origin main

# 3. 运行测试
echo -e "${YELLOW}运行测试...${NC}"
npm run test

# 4. 运行构建
echo -e "${YELLOW}构建项目...${NC}"
npm run build

# 5. 更新版本号
echo -e "${YELLOW}更新版本号 ($VERSION_TYPE)...${NC}"
npm version $VERSION_TYPE --no-git-tag-version

# 获取新版本号
NEW_VERSION=$(node -p "require('./package.json').version")
echo -e "${GREEN}新版本号: $NEW_VERSION${NC}"

# 6. 更新 CHANGELOG
echo -e "${YELLOW}请更新 CHANGELOG.md，然后按回车继续...${NC}"
read

# 7. 提交变更
echo -e "${YELLOW}提交变更...${NC}"
git add package.json package-lock.json CHANGELOG.md
git commit -m "chore(release): v$NEW_VERSION"

# 8. 打标签
echo -e "${YELLOW}打标签 v$NEW_VERSION...${NC}"
git tag -a "v$NEW_VERSION" -m "Release v$NEW_VERSION"

# 9. 推送到远程
echo -e "${YELLOW}推送到远程...${NC}"
git push origin main
git push origin "v$NEW_VERSION"

# 10. 发布到 npm
echo -e "${YELLOW}发布到 npm...${NC}"
npm publish

echo -e "${GREEN}✅ 发布完成! v$NEW_VERSION${NC}"
```

---

## 9. 迁移策略

### 9.1 五步迁移策略

```
┌─────────────────────────────────────────────────────────────────┐
│                        五步迁移策略                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  步骤1: 评估与规划                                                │
│     ├── 识别需要迁移的组件                                        │
│     ├── 分析依赖关系                                              │
│     └── 制定迁移计划                                              │
│                          ↓                                      │
│  步骤2: 创建兼容层                                                │
│     ├── 开发适配器组件                                            │
│     ├── 保持 API 兼容                                             │
│     └── 添加废弃警告                                              │
│                          ↓                                      │
│  步骤3: 渐进式迁移                                                │
│     ├── 按优先级分批迁移                                          │
│     ├── 并行运行新旧组件                                          │
│     └── 持续测试验证                                              │
│                          ↓                                      │
│  步骤4: 文档与培训                                                │
│     ├── 编写迁移指南                                              │
│     ├── 更新 API 文档                                             │
│     └── 团队培训                                                  │
│                          ↓                                      │
│  步骤5: 清理与优化                                                │
│     ├── 移除兼容层                                                │
│     ├── 清理废弃代码                                              │
│     └── 性能优化                                                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 9.2 步骤详解

#### 步骤1: 评估与规划

```typescript
// 迁移评估清单
interface MigrationAssessment {
  // 组件清单
  components: {
    name: string;
    currentVersion: string;
    targetVersion: string;
    breakingChanges: string[];
    estimatedEffort: 'low' | 'medium' | 'high';
    priority: 'critical' | 'high' | 'medium' | 'low';
  }[];
  
  // 依赖分析
  dependencies: {
    component: string;
    usedBy: string[];
    externalDeps: string[];
  }[];
  
  // 风险评估
  risks: {
    description: string;
    impact: 'low' | 'medium' | 'high';
    mitigation: string;
  }[];
}

// 迁移计划模板
const migrationPlan = {
  phases: [
    {
      name: 'Phase 1: 核心组件',
      components: ['Button', 'Input', 'Select'],
      timeline: '2 weeks',
      owner: 'Team A',
    },
    {
      name: 'Phase 2: 表单组件',
      components: ['Form', 'Checkbox', 'Radio'],
      timeline: '2 weeks',
      owner: 'Team B',
    },
    {
      name: 'Phase 3: 数据展示',
      components: ['Table', 'List', 'Card'],
      timeline: '2 weeks',
      owner: 'Team C',
    },
  ],
};
```

#### 步骤2: 创建兼容层

```tsx
// 适配器组件示例
// compat/Button/Button.compat.tsx

import React from 'react';
import { Button as NewButton } from '../../Atoms/Button';
import type { ButtonProps as NewButtonProps } from '../../Atoms/Button';
import { deprecate } from '../../utils/deprecate';

// 旧版本 Props
interface OldButtonProps {
  /** @deprecated 使用 variant="solid" 替代 */
  type?: 'primary' | 'secondary' | 'danger';
  /** @deprecated 使用 size 替代 */
  btnSize?: 'small' | 'medium' | 'large';
  /** @deprecated 使用 isLoading 替代 */
  loading?: boolean;
  /** @deprecated 使用 disabled 替代 */
  isDisabled?: boolean;
  onClick?: () => void;
  children: React.ReactNode;
}

// Props 映射函数
const mapOldPropsToNew = (oldProps: OldButtonProps): NewButtonProps => {
  const { type, btnSize, loading, isDisabled, ...rest } = oldProps;
  
  // 发出废弃警告
  if (type) {
    deprecate('Button: type 属性已废弃，请使用 variant');
  }
  if (btnSize) {
    deprecate('Button: btnSize 属性已废弃，请使用 size');
  }
  if (loading) {
    deprecate('Button: loading 属性已废弃，请使用 isLoading');
  }
  if (isDisabled) {
    deprecate('Button: isDisabled 属性已废弃，请使用 disabled');
  }
  
  // 属性映射
  return {
    variant: type === 'primary' ? 'solid' : type === 'secondary' ? 'outline' : 'solid',
    size: btnSize === 'small' ? 'sm' : btnSize === 'large' ? 'lg' : 'md',
    colorScheme: type === 'danger' ? 'danger' : 'primary',
    isLoading: loading,
    disabled: isDisabled,
    ...rest,
  };
};

// 兼容层组件
export const Button: React.FC<OldButtonProps> = (props) => {
  const newProps = mapOldPropsToNew(props);
  return <NewButton {...newProps} />;
};

// 废弃警告工具
export function deprecate(message: string) {
  if (process.env.NODE_ENV !== 'production') {
    console.warn(`[RUI Deprecation] ${message}`);
  }
}
```

#### 步骤3: 渐进式迁移

```tsx
// 渐进式迁移示例
// 使用功能开关控制新旧组件

import React from 'react';
import { Button as OldButton } from './compat/Button';
import { Button as NewButton } from './Atoms/Button';

// 功能开关
const FEATURE_FLAGS = {
  useNewButton: process.env.REACT_APP_USE_NEW_BUTTON === 'true',
};

// 条件渲染
export const Button: React.FC<ButtonProps> = (props) => {
  if (FEATURE_FLAGS.useNewButton) {
    return <NewButton {...props} />;
  }
  return <OldButton {...props} />;
};

// 或者使用构建时替换
// webpack.config.js
module.exports = {
  resolve: {
    alias: {
      '@rui/button': process.env.USE_NEW_COMPONENTS 
        ? '@rui/react/dist/Button'
        : '@rui/react-compat/dist/Button',
    },
  },
};
```

#### 步骤4: 文档与培训

```markdown
<!-- MIGRATION.md -->
# RUI v1.x 到 v2.x 迁移指南

## 概述

本文档指导您从 RUI v1.x 迁移到 v2.x。

## 破坏性变更

### Button 组件

#### 属性变更

| v1.x (旧) | v2.x (新) | 说明 |
|-----------|-----------|------|
| `type` | `variant` | 视觉变体 |
| `btnSize` | `size` | 尺寸 |
| `loading` | `isLoading` | 加载状态 |
| `isDisabled` | `disabled` | 禁用状态 |

#### 迁移示例

**Before (v1.x):**
```tsx
<Button type="primary" btnSize="large" loading={true}>
  提交
</Button>
```

**After (v2.x):**
```tsx
<Button variant="solid" size="lg" isLoading={true}>
  提交
</Button>
```

#### 自动迁移脚本

```bash
# 安装迁移工具
npm install -g @rui/codemod

# 运行迁移
ui-codemod migrate v1-to-v2 --src ./src
```

## 迁移检查清单

- [ ] 更新 package.json 中的依赖版本
- [ ] 运行迁移脚本
- [ ] 检查废弃警告
- [ ] 运行测试套件
- [ ] 验证视觉回归
- [ ] 更新项目文档

## 常见问题

### Q: 迁移过程中可以混合使用新旧组件吗？

A: 可以，通过兼容层组件，新旧 API 可以同时工作。

### Q: 迁移需要多长时间？

A: 取决于项目规模，通常需要 1-2 个迭代周期。
```

#### 步骤5: 清理与优化

```typescript
// 清理检查清单
const cleanupChecklist = {
  // 代码清理
  code: [
    '移除所有兼容层组件',
    '删除废弃的 Props 处理逻辑',
    '清理未使用的导入',
    '移除功能开关代码',
  ],
  
  // 文档清理
  documentation: [
    '更新 README.md',
    '移除迁移指南中的过时内容',
    '更新 API 参考文档',
    '更新 Storybook 示例',
  ],
  
  // 依赖清理
  dependencies: [
    '移除 @rui/compat 包',
    '更新 package.json',
    '运行 npm prune',
  ],
  
  // 性能优化
  optimization: [
    '分析包体积变化',
    '优化 tree-shaking',
    '检查重复代码',
  ],
};

// 清理脚本
// scripts/cleanup.sh
#!/bin/bash

echo "开始清理..."

# 1. 移除兼容层
rm -rf src/compat

# 2. 移除废弃代码
find src -name "*.deprecated.*" -delete

# 3. 更新导入
sed -i 's/@rui\/compat/@rui\/react/g' src/**/*.ts

# 4. 运行测试
npm test

echo "清理完成!"
```

### 9.3 Codemod 迁移工具

```javascript
// codemods/v1-to-v2/button.js
// jscodeshift transform

module.exports = function(fileInfo, api) {
  const j = api.jscodeshift;
  const root = j(fileInfo.source);
  
  // 查找 Button 组件
  root.find(j.JSXOpeningElement, { name: { name: 'Button' } })
    .forEach(path => {
      const attributes = path.node.attributes;
      
      attributes.forEach(attr => {
        if (attr.type === 'JSXAttribute') {
          // type -> variant
          if (attr.name.name === 'type') {
            attr.name.name = 'variant';
            if (attr.value.value === 'primary') {
              attr.value.value = 'solid';
            } else if (attr.value.value === 'secondary') {
              attr.value.value = 'outline';
            }
          }
          
          // btnSize -> size
          if (attr.name.name === 'btnSize') {
            attr.name.name = 'size';
            if (attr.value.value === 'small') {
              attr.value.value = 'sm';
            } else if (attr.value.value === 'large') {
              attr.value.value = 'lg';
            }
          }
          
          // loading -> isLoading
          if (attr.name.name === 'loading') {
            attr.name.name = 'isLoading';
          }
          
          // isDisabled -> disabled
          if (attr.name.name === 'isDisabled') {
            attr.name.name = 'disabled';
          }
        }
      });
    });
  
  return root.toSource();
};

// 使用方式
// npx jscodeshift -t codemods/v1-to-v2/button.js src/
```

---

## 附录

### A. 命名规范

| 类型 | 规范 | 示例 |
|------|------|------|
| 组件名 | PascalCase | `Button`, `InputGroup` |
| Props | camelCase | `isLoading`, `onClick` |
| 常量 | UPPER_SNAKE_CASE | `DEFAULT_SIZE` |
| 类型 | PascalCase | `ButtonProps`, `ButtonSize` |
| 文件 | PascalCase | `Button.tsx`, `Button.test.tsx` |
| 目录 | PascalCase | `Atoms/`, `Molecules/` |

### B. 文件模板

```tsx
// 组件文件模板
// ComponentName.tsx
import React from 'react';
import { styled } from '@rui/styled';

export interface ComponentNameProps {
  /** 描述 */
  propName?: string;
}

const StyledComponent = styled('div', {
  // 样式
});

export const ComponentName = React.forwardRef<
  HTMLDivElement,
  ComponentNameProps
>(({ propName, ...props }, ref) => {
  return <StyledComponent ref={ref} {...props} />;
});

ComponentName.displayName = 'ComponentName';
```

### C. 参考资源

- [Atomic Design](https://atomicdesign.bradfrost.com/)
- [Design Tokens W3C](https://www.w3.org/community/design-tokens/)
- [WCAG 2.1](https://www.w3.org/WAI/WCAG21/quickref/)
- [Storybook Docs](https://storybook.js.org/docs/react/get-started/introduction)
- [Semantic Versioning](https://semver.org/)

---

*文档版本: 1.0.0*
*最后更新: 2024-01-15*
*作者: RUI Design Team*
