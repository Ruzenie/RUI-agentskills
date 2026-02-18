# 项目脚手架模板指南

> 一份完整的现代前端项目初始化与组织结构最佳实践文档

---

## 目录

1. [项目脚手架目录结构](#1-项目脚手架目录结构)
2. [技术栈组合推荐](#2-技术栈组合推荐)
3. [目录组织最佳实践](#3-目录组织最佳实践)
4. [配置文件模板](#4-配置文件模板)
5. [初始化脚本](#5-初始化脚本)

---

## 1. 项目脚手架目录结构

### 1.1 标准目录结构

```
my-project/
├── 📁 .github/                 # GitHub 配置
│   ├── workflows/              # CI/CD 工作流
│   │   ├── ci.yml
│   │   └── deploy.yml
│   ├── ISSUE_TEMPLATE/
│   └── PULL_REQUEST_TEMPLATE.md
│
├── 📁 .husky/                  # Git hooks
│   └── pre-commit
│
├── 📁 .vscode/                 # VS Code 配置
│   ├── extensions.json
│   ├── launch.json
│   └── settings.json
│
├── 📁 docs/                    # 项目文档
│   ├── README.md
│   ├── API.md
│   ├── ARCHITECTURE.md
│   └── DEPLOYMENT.md
│
├── 📁 public/                  # 静态资源（不经过构建）
│   ├── favicon.ico
│   ├── robots.txt
│   └── assets/
│       └── images/
│
├── 📁 src/                     # 源代码
│   ├── 📁 assets/              # 静态资源（经过构建）
│   │   ├── styles/
│   │   │   ├── global.css
│   │   │   └── variables.css
│   │   ├── images/
│   │   └── fonts/
│   │
│   ├── 📁 components/          # 通用组件
│   │   ├── ui/                 # 基础UI组件
│   │   │   ├── Button/
│   │   │   │   ├── index.tsx
│   │   │   │   ├── Button.tsx
│   │   │   │   ├── Button.test.tsx
│   │   │   │   └── Button.module.css
│   │   │   ├── Input/
│   │   │   └── Modal/
│   │   └── common/             # 业务通用组件
│   │       ├── Header/
│   │       ├── Footer/
│   │       └── Sidebar/
│   │
│   ├── 📁 hooks/               # 自定义 Hooks
│   │   ├── useAuth.ts
│   │   ├── useLocalStorage.ts
│   │   └── useDebounce.ts
│   │
│   ├── 📁 layouts/             # 布局组件
│   │   ├── MainLayout/
│   │   ├── AuthLayout/
│   │   └── index.ts
│   │
│   ├── 📁 pages/               # 页面组件
│   │   ├── Home/
│   │   │   ├── index.tsx
│   │   │   └── components/
│   │   ├── About/
│   │   └── Dashboard/
│   │
│   ├── 📁 routes/              # 路由配置
│   │   ├── index.tsx
│   │   ├── privateRoutes.tsx
│   │   └── publicRoutes.tsx
│   │
│   ├── 📁 services/            # API 服务
│   │   ├── api/
│   │   │   ├── client.ts
│   │   │   ├── userApi.ts
│   │   │   └── authApi.ts
│   │   └── types/
│   │       ├── user.ts
│   │       └── auth.ts
│   │
│   ├── 📁 stores/              # 状态管理
│   │   ├── index.ts
│   │   ├── slices/
│   │   │   ├── authSlice.ts
│   │   │   └── userSlice.ts
│   │   └── middleware/
│   │
│   ├── 📁 utils/               # 工具函数
│   │   ├── helpers/
│   │   │   ├── formatDate.ts
│   │   │   └── validate.ts
│   │   ├── constants/
│   │   │   ├── routes.ts
│   │   │   └── config.ts
│   │   └── types/
│   │       └── global.ts
│   │
│   ├── 📁 contexts/            # React Context
│   │   ├── AuthContext.tsx
│   │   └── ThemeContext.tsx
│   │
│   ├── 📁 config/              # 应用配置
│   │   ├── env.ts
│   │   └── app.ts
│   │
│   ├── App.tsx
│   ├── main.tsx
│   └── vite-env.d.ts
│
├── 📁 tests/                   # 测试文件
│   ├── unit/
│   ├── integration/
│   └── e2e/
│
├── 📁 scripts/                 # 脚本工具
│   ├── setup.sh
│   ├── build.sh
│   └── deploy.sh
│
├── 📁 types/                   # 全局类型定义
│   └── global.d.ts
│
├── .env                        # 环境变量
├── .env.example
├── .env.development
├── .env.production
├── .env.test
│
├── .eslintrc.cjs               # ESLint 配置
├── .prettierrc                 # Prettier 配置
├── .gitignore
├── .nvmrc                      # Node 版本
│
├── index.html
├── package.json
├── tsconfig.json               # TypeScript 配置
├── tsconfig.node.json
├── vite.config.ts              # Vite 配置
├── tailwind.config.js          # Tailwind CSS 配置
├── postcss.config.js
├── jest.config.js              # Jest 配置
├── vitest.config.ts            # Vitest 配置
├── playwright.config.ts        # Playwright 配置
│
├── README.md
├── LICENSE
└── CHANGELOG.md
```

### 1.2 目录说明

| 目录 | 用途 | 说明 |
|------|------|------|
| `.github/` | GitHub 配置 | 工作流、Issue 模板、PR 模板 |
| `.husky/` | Git hooks | 代码提交前检查 |
| `.vscode/` | IDE 配置 | 团队共享的 VS Code 设置 |
| `docs/` | 项目文档 | 架构、API、部署文档 |
| `public/` | 静态资源 | 不经过构建处理的文件 |
| `src/` | 源代码 | 项目核心代码 |
| `tests/` | 测试文件 | 单元、集成、E2E 测试 |
| `scripts/` | 脚本工具 | 自动化脚本 |
| `types/` | 全局类型 | TypeScript 类型定义 |

---

## 2. 技术栈组合推荐

### 2.1 组合一：React + TypeScript + Vite（推荐）

**适用场景**：现代 Web 应用、SPA、需要快速开发的项目

```
核心框架: React 18+
语言: TypeScript 5+
构建工具: Vite 5+
样式方案: Tailwind CSS + CSS Modules
状态管理: Zustand / Redux Toolkit
路由: React Router v6
UI组件库: Radix UI + shadcn/ui
HTTP客户端: Axios / TanStack Query
测试: Vitest + React Testing Library + Playwright
代码规范: ESLint + Prettier + Husky
```

**优势**：
- ⚡ 极快的开发服务器启动速度
- 📦 优化的生产构建
- 🔧 开箱即用的 TypeScript 支持
- 🎨 原子化 CSS，开发效率高

### 2.2 组合二：Next.js + TypeScript（全栈方案）

**适用场景**：SEO 友好的应用、需要 SSR/SSG 的项目

```
核心框架: Next.js 14+ (App Router)
语言: TypeScript 5+
样式方案: Tailwind CSS + NextUI
状态管理: Zustand / Jotai
数据库: Prisma + PostgreSQL / MongoDB
认证: NextAuth.js / Clerk
部署: Vercel / Docker
测试: Jest + Cypress
```

**优势**：
- 🚀 内置 SSR/SSG/ISR 支持
- 📊 优秀的 SEO 性能
- 🔒 内置 API 路由
- 🎯 图片、字体优化

### 2.3 组合三：Vue 3 + TypeScript + Vite

**适用场景**：Vue 生态项目、渐进式升级

```
核心框架: Vue 3.4+ (Composition API)
语言: TypeScript 5+
构建工具: Vite 5+
状态管理: Pinia
路由: Vue Router 4
UI组件库: Element Plus / Ant Design Vue
样式方案: UnoCSS / Tailwind CSS
HTTP客户端: Axios / VueUse
测试: Vitest + Vue Test Utils
```

**优势**：
- 🌿 渐进式框架，易于上手
- 📝 组合式 API，逻辑复用
- 🎯 优秀的性能表现
- 📚 丰富的生态系统

### 2.4 组合四：React Native + Expo（移动端）

**适用场景**：跨平台移动应用

```
核心框架: React Native 0.73+
开发工具: Expo SDK 50+
语言: TypeScript 5+
导航: React Navigation 6
状态管理: Zustand
UI组件: React Native Paper / NativeBase
存储: AsyncStorage / MMKV
推送: Expo Notifications
测试: Jest + Detox
```

**优势**：
- 📱 一套代码，iOS + Android
- 🔄 热更新支持（Expo）
- 🛠️ 丰富的原生模块
- 📦 无需配置原生环境

### 2.5 组合五：Tauri + React/Vue（桌面端）

**适用场景**：跨平台桌面应用

```
核心框架: Tauri 2.0
前端: React 18+ / Vue 3+
语言: TypeScript 5+ / Rust
样式方案: Tailwind CSS
状态管理: Zustand
存储: Tauri Store / SQLite
通知: Tauri Notification
打包: Tauri CLI
```

**优势**：
- 💻 轻量级桌面应用
- 🔒 安全的沙箱环境
- 📦 极小的安装包体积
- 🎯 原生性能体验

---

## 3. 目录组织最佳实践

### 3.1 十条核心原则

#### 1. 按功能模块组织（Feature-Based）

```
❌ 不推荐（按类型组织）
src/
  components/
    UserList.tsx
    UserForm.tsx
    ProductList.tsx
  hooks/
    useUser.ts
    useProduct.ts

✅ 推荐（按功能组织）
src/
  features/
    users/
      components/
        UserList.tsx
        UserForm.tsx
      hooks/
        useUser.ts
      api/
        userApi.ts
      types/
        user.ts
    products/
      components/
        ProductList.tsx
      hooks/
        useProduct.ts
```

#### 2. 使用索引文件（Barrel Exports）

```typescript
// components/ui/index.ts
export { Button } from './Button';
export { Input } from './Input';
export { Modal } from './Modal';

// 使用方式
import { Button, Input, Modal } from '@/components/ui';
```

#### 3. 组件文件命名规范

```
组件目录结构：
ComponentName/
├── index.ts           # 导出入口
├── ComponentName.tsx  # 组件实现
├── ComponentName.test.tsx  # 测试文件
├── ComponentName.module.css / .styled.ts  # 样式
├── ComponentName.types.ts  # 类型定义（可选）
└── hooks/
    └── useComponentLogic.ts  # 组件逻辑（可选）
```

#### 4. 路径别名配置

```typescript
// tsconfig.json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"],
      "@components/*": ["src/components/*"],
      "@hooks/*": ["src/hooks/*"],
      "@utils/*": ["src/utils/*"],
      "@services/*": ["src/services/*"],
      "@stores/*": ["src/stores/*"],
      "@types/*": ["src/types/*"],
      "@assets/*": ["src/assets/*"]
    }
  }
}
```

#### 5. 环境变量管理

```
.env                 # 默认环境变量
.env.local           # 本地环境变量（不提交）
.env.development     # 开发环境
.env.production      # 生产环境
.env.test            # 测试环境
```

```typescript
// src/config/env.ts
export const env = {
  API_URL: import.meta.env.VITE_API_URL || 'http://localhost:3000',
  APP_NAME: import.meta.env.VITE_APP_NAME || 'MyApp',
  IS_DEV: import.meta.env.DEV,
  IS_PROD: import.meta.env.PROD,
} as const;
```

#### 6. 类型定义分离

```typescript
// 组件类型
// src/components/ui/Button/Button.types.ts
export interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  loading?: boolean;
  onClick?: () => void;
  children: React.ReactNode;
}

// API 类型
// src/services/types/user.ts
export interface User {
  id: string;
  email: string;
  name: string;
  avatar?: string;
  createdAt: Date;
}

export interface CreateUserRequest {
  email: string;
  name: string;
  password: string;
}
```

#### 7. 常量集中管理

```typescript
// src/utils/constants/routes.ts
export const ROUTES = {
  HOME: '/',
  ABOUT: '/about',
  DASHBOARD: '/dashboard',
  PROFILE: '/profile',
  SETTINGS: '/settings',
  LOGIN: '/login',
  REGISTER: '/register',
  NOT_FOUND: '*',
} as const;

// src/utils/constants/config.ts
export const CONFIG = {
  PAGINATION: {
    DEFAULT_PAGE: 1,
    DEFAULT_LIMIT: 10,
    MAX_LIMIT: 100,
  },
  TOKEN: {
    ACCESS_TOKEN_KEY: 'access_token',
    REFRESH_TOKEN_KEY: 'refresh_token',
  },
} as const;
```

#### 8. 工具函数分类

```
src/utils/
├── helpers/           # 通用辅助函数
│   ├── formatDate.ts
│   ├── formatCurrency.ts
│   ├── validateEmail.ts
│   └── debounce.ts
├── constants/         # 常量
│   ├── routes.ts
│   ├── config.ts
│   └── messages.ts
├── types/             # 工具类型
│   └── global.ts
└── lib/               # 第三方库封装
    ├── axios.ts
    └── queryClient.ts
```

#### 9. 测试文件组织

```
方案一：与源文件同目录
src/
  components/
    Button/
      ├── Button.tsx
      ├── Button.test.tsx
      └── Button.e2e.test.tsx

方案二：独立 tests 目录
tests/
  unit/
    components/
      Button.test.tsx
  integration/
    auth.test.tsx
  e2e/
    login.spec.ts
```

#### 10. 文档与代码同步

```
docs/
├── README.md              # 项目介绍
├── GETTING_STARTED.md     # 快速开始
├── ARCHITECTURE.md        # 架构设计
├── API.md                 # API 文档
├── DEPLOYMENT.md          # 部署指南
├── DEVELOPMENT.md         # 开发规范
└── CHANGELOG.md           # 变更日志
```

---

## 4. 配置文件模板

### 4.1 tsconfig.json

```json
{
  "compilerOptions": {
    /* 基础配置 */
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,

    /* 模块解析 */
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",

    /* 路径别名 */
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@components/*": ["./src/components/*"],
      "@hooks/*": ["./src/hooks/*"],
      "@utils/*": ["./src/utils/*"],
      "@services/*": ["./src/services/*"],
      "@stores/*": ["./src/stores/*"],
      "@types/*": ["./src/types/*"],
      "@assets/*": ["./src/assets/*"],
      "@layouts/*": ["./src/layouts/*"],
      "@pages/*": ["./src/pages/*"],
      "@config/*": ["./src/config/*"]
    },

    /* 严格类型检查 */
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,

    /* 代码质量 */
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true,

    /* 高级功能 */
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,

    /* 装饰器（如需要） */
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true
  },
  "include": [
    "src/**/*",
    "tests/**/*",
    "types/**/*",
    "*.config.ts",
    "*.config.js"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "build",
    "coverage"
  ],
  "references": [
    { "path": "./tsconfig.node.json" }
  ]
}
```

### 4.2 tsconfig.node.json

```json
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowSyntheticDefaultImports": true,
    "strict": true
  },
  "include": [
    "vite.config.ts",
    "vitest.config.ts",
    "playwright.config.ts"
  ]
}
```

### 4.3 vite.config.ts

```typescript
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';
import { visualizer } from 'rollup-plugin-visualizer';

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => ({
  // 插件配置
  plugins: [
    react({
      // React 插件选项
      jsxImportSource: '@emotion/react', // 如使用 emotion
      babel: {
        plugins: ['@emotion/babel-plugin'],
      },
    }),
    // 打包分析（仅生产环境）
    mode === 'production' &&
      visualizer({
        open: false,
        gzipSize: true,
        brotliSize: true,
        filename: 'dist/stats.html',
      }),
  ],

  // 路径解析
  resolve: {
    alias: {
      '@': resolve(__dirname, './src'),
      '@components': resolve(__dirname, './src/components'),
      '@hooks': resolve(__dirname, './src/hooks'),
      '@utils': resolve(__dirname, './src/utils'),
      '@services': resolve(__dirname, './src/services'),
      '@stores': resolve(__dirname, './src/stores'),
      '@types': resolve(__dirname, './src/types'),
      '@assets': resolve(__dirname, './src/assets'),
      '@layouts': resolve(__dirname, './src/layouts'),
      '@pages': resolve(__dirname, './src/pages'),
      '@config': resolve(__dirname, './src/config'),
    },
  },

  // 开发服务器
  server: {
    port: 3000,
    open: true,
    cors: true,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ''),
      },
    },
  },

  // 构建配置
  build: {
    target: 'es2020',
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: mode !== 'production',
    minify: 'terser',
    terserOptions: {
      compress: {
        drop_console: mode === 'production',
        drop_debugger: mode === 'production',
      },
    },
    rollupOptions: {
      output: {
        // 代码分割
        manualChunks: {
          vendor: ['react', 'react-dom', 'react-router-dom'],
          ui: ['@radix-ui/react-dialog', '@radix-ui/react-dropdown-menu'],
        },
        // 资源命名
        entryFileNames: 'js/[name]-[hash].js',
        chunkFileNames: 'js/[name]-[hash].js',
        assetFileNames: (assetInfo) => {
          const info = assetInfo.name.split('.');
          const ext = info[info.length - 1];
          if (/\.(png|jpe?g|gif|svg|webp|ico)$/i.test(assetInfo.name)) {
            return 'images/[name]-[hash][extname]';
          }
          if (/\.(woff2?|eot|ttf|otf)$/i.test(assetInfo.name)) {
            return 'fonts/[name]-[hash][extname]';
          }
          if (ext === 'css') {
            return 'css/[name]-[hash][extname]';
          }
          return 'assets/[name]-[hash][extname]';
        },
      },
    },
    //  chunk 大小警告
    chunkSizeWarningLimit: 1000,
  },

  // CSS 配置
  css: {
    devSourcemap: true,
    modules: {
      localsConvention: 'camelCase',
      generateScopedName: mode === 'production'
        ? '[hash:base64:8]'
        : '[name]__[local]__[hash:base64:5]',
    },
    preprocessorOptions: {
      scss: {
        additionalData: `@import "@/assets/styles/variables.scss";`,
      },
    },
  },

  // 环境变量前缀
  envPrefix: 'VITE_',

  // 预览配置
  preview: {
    port: 4173,
    open: true,
  },

  // 优化依赖
  optimizeDeps: {
    include: ['react', 'react-dom', 'react-router-dom'],
    exclude: ['@emotion/react'],
  },
}));
```

### 4.4 tailwind.config.js

```javascript
/** @type {import('tailwindcss').Config} */
export default {
  // 内容路径
  content: [
    './index.html',
    './src/**/*.{js,ts,jsx,tsx}',
    './src/**/**/*.{js,ts,jsx,tsx}',
  ],

  // 暗色模式
  darkMode: ['class', '[data-theme="dark"]'],

  // 主题配置
  theme: {
    // 容器配置
    container: {
      center: true,
      padding: {
        DEFAULT: '1rem',
        sm: '2rem',
        lg: '4rem',
        xl: '5rem',
        '2xl': '6rem',
      },
      screens: {
        sm: '640px',
        md: '768px',
        lg: '1024px',
        xl: '1280px',
        '2xl': '1536px',
      },
    },

    // 扩展配置
    extend: {
      // 颜色系统
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
          50: '#eff6ff',
          100: '#dbeafe',
          200: '#bfdbfe',
          300: '#93c5fd',
          400: '#60a5fa',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
          800: '#1e40af',
          900: '#1e3a8a',
          950: '#172554',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary))',
          foreground: 'hsl(var(--secondary-foreground))',
        },
        destructive: {
          DEFAULT: 'hsl(var(--destructive))',
          foreground: 'hsl(var(--destructive-foreground))',
        },
        muted: {
          DEFAULT: 'hsl(var(--muted))',
          foreground: 'hsl(var(--muted-foreground))',
        },
        accent: {
          DEFAULT: 'hsl(var(--accent))',
          foreground: 'hsl(var(--accent-foreground))',
        },
        popover: {
          DEFAULT: 'hsl(var(--popover))',
          foreground: 'hsl(var(--popover-foreground))',
        },
        card: {
          DEFAULT: 'hsl(var(--card))',
          foreground: 'hsl(var(--card-foreground))',
        },
      },

      // 圆角
      borderRadius: {
        lg: 'var(--radius)',
        md: 'calc(var(--radius) - 2px)',
        sm: 'calc(var(--radius) - 4px)',
      },

      // 字体
      fontFamily: {
        sans: [
          'Inter',
          'system-ui',
          '-apple-system',
          'BlinkMacSystemFont',
          'Segoe UI',
          'Roboto',
          'Helvetica Neue',
          'Arial',
          'sans-serif',
        ],
        mono: [
          'JetBrains Mono',
          'Fira Code',
          'Consolas',
          'Monaco',
          'monospace',
        ],
      },

      // 字体大小
      fontSize: {
        '2xs': ['0.625rem', { lineHeight: '0.875rem' }],
        xs: ['0.75rem', { lineHeight: '1rem' }],
        sm: ['0.875rem', { lineHeight: '1.25rem' }],
        base: ['1rem', { lineHeight: '1.5rem' }],
        lg: ['1.125rem', { lineHeight: '1.75rem' }],
        xl: ['1.25rem', { lineHeight: '1.75rem' }],
        '2xl': ['1.5rem', { lineHeight: '2rem' }],
        '3xl': ['1.875rem', { lineHeight: '2.25rem' }],
        '4xl': ['2.25rem', { lineHeight: '2.5rem' }],
        '5xl': ['3rem', { lineHeight: '1.1' }],
        '6xl': ['3.75rem', { lineHeight: '1.1' }],
      },

      // 间距
      spacing: {
        '4.5': '1.125rem',
        '13': '3.25rem',
        '15': '3.75rem',
        '18': '4.5rem',
        '22': '5.5rem',
        '26': '6.5rem',
        '30': '7.5rem',
      },

      // 动画
      animation: {
        'fade-in': 'fadeIn 0.2s ease-out',
        'fade-out': 'fadeOut 0.2s ease-out',
        'slide-in': 'slideIn 0.2s ease-out',
        'slide-out': 'slideOut 0.2s ease-out',
        'spin-slow': 'spin 3s linear infinite',
        'bounce-slow': 'bounce 2s infinite',
        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      },

      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        fadeOut: {
          '0%': { opacity: '1' },
          '100%': { opacity: '0' },
        },
        slideIn: {
          '0%': { transform: 'translateY(10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        slideOut: {
          '0%': { transform: 'translateY(0)', opacity: '1' },
          '100%': { transform: 'translateY(10px)', opacity: '0' },
        },
      },

      // 过渡
      transitionTimingFunction: {
        'in-expo': 'cubic-bezier(0.95, 0.05, 0.795, 0.035)',
        'out-expo': 'cubic-bezier(0.19, 1, 0.22, 1)',
      },

      // 阴影
      boxShadow: {
        'soft': '0 2px 15px -3px rgba(0, 0, 0, 0.07), 0 10px 20px -2px rgba(0, 0, 0, 0.04)',
        'glow': '0 0 20px rgba(59, 130, 246, 0.5)',
      },

      // Z-index
      zIndex: {
        '60': '60',
        '70': '70',
        '80': '80',
        '90': '90',
        '100': '100',
      },
    },
  },

  // 插件
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio'),
    require('tailwindcss-animate'),

    // 自定义插件
    function ({ addComponents, addUtilities, theme }) {
      // 添加自定义组件
      addComponents({
        '.btn': {
          padding: `${theme('spacing.2')} ${theme('spacing.4')}`,
          borderRadius: theme('borderRadius.md'),
          fontWeight: theme('fontWeight.medium'),
          transition: 'all 0.2s',
          '&:hover': {
            opacity: '0.9',
          },
          '&:focus': {
            outline: 'none',
            ring: '2px',
            ringOffset: '2px',
          },
        },
      });

      // 添加自定义工具类
      addUtilities({
        '.text-balance': {
          textWrap: 'balance',
        },
        '.scrollbar-hide': {
          '-ms-overflow-style': 'none',
          'scrollbar-width': 'none',
          '&::-webkit-scrollbar': {
            display: 'none',
          },
        },
      });
    },
  ],

  // 预设（如需要）
  presets: [],

  // 核心插件配置
  corePlugins: {
    // 禁用不需要的核心插件
    // container: false,
  },
};
```

### 4.5 postcss.config.js

```javascript
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
    // 生产环境优化
    ...(process.env.NODE_ENV === 'production'
      ? {
          cssnano: {
            preset: ['default', { discardComments: { removeAll: true } }],
          },
        }
      : {}),
  },
};
```

### 4.6 .eslintrc.cjs

```javascript
module.exports = {
  root: true,
  env: {
    browser: true,
    es2021: true,
    node: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-requiring-type-checking',
    'plugin:react/recommended',
    'plugin:react-hooks/recommended',
    'plugin:jsx-a11y/recommended',
    'plugin:import/recommended',
    'plugin:import/typescript',
    'prettier',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    project: ['./tsconfig.json', './tsconfig.node.json'],
    ecmaFeatures: {
      jsx: true,
    },
  },
  plugins: [
    '@typescript-eslint',
    'react',
    'react-hooks',
    'jsx-a11y',
    'import',
    'unused-imports',
    'simple-import-sort',
  ],
  settings: {
    react: {
      version: 'detect',
    },
    'import/resolver': {
      typescript: {
        project: './tsconfig.json',
      },
      alias: {
        map: [
          ['@', './src'],
          ['@components', './src/components'],
          ['@hooks', './src/hooks'],
          ['@utils', './src/utils'],
        ],
        extensions: ['.ts', '.tsx', '.js', '.jsx'],
      },
    },
  },
  rules: {
    // TypeScript
    '@typescript-eslint/no-unused-vars': 'off',
    '@typescript-eslint/no-explicit-any': 'warn',
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-empty-function': 'warn',
    '@typescript-eslint/no-non-null-assertion': 'warn',
    '@typescript-eslint/consistent-type-imports': [
      'warn',
      { prefer: 'type-imports' },
    ],

    // React
    'react/react-in-jsx-scope': 'off',
    'react/prop-types': 'off',
    'react/jsx-props-no-spreading': 'off',
    'react/require-default-props': 'off',
    'react/jsx-sort-props': [
      'warn',
      {
        callbacksLast: true,
        shorthandFirst: true,
        noSortAlphabetically: false,
        reservedFirst: true,
      },
    ],

    // React Hooks
    'react-hooks/rules-of-hooks': 'error',
    'react-hooks/exhaustive-deps': 'warn',

    // Import
    'import/no-unresolved': 'error',
    'import/named': 'error',
    'import/namespace': 'error',
    'import/default': 'error',
    'import/export': 'error',
    'import/no-duplicates': 'error',
    'import/order': 'off',
    'simple-import-sort/imports': 'error',
    'simple-import-sort/exports': 'error',

    // Unused imports
    'unused-imports/no-unused-imports': 'error',
    'unused-imports/no-unused-vars': [
      'warn',
      {
        vars: 'all',
        varsIgnorePattern: '^_',
        args: 'after-used',
        argsIgnorePattern: '^_',
      },
    ],

    // General
    'no-console': ['warn', { allow: ['warn', 'error'] }],
    'no-debugger': 'warn',
    'no-alert': 'warn',
    'no-var': 'error',
    'prefer-const': 'error',
    'eqeqeq': ['error', 'always'],
  },
  overrides: [
    {
      files: ['*.test.ts', '*.test.tsx'],
      rules: {
        '@typescript-eslint/no-explicit-any': 'off',
      },
    },
  ],
  ignorePatterns: [
    'dist',
    'build',
    'node_modules',
    '*.config.js',
    '*.config.ts',
  ],
};
```

### 4.7 .prettierrc

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 80,
  "useTabs": false,
  "bracketSpacing": true,
  "arrowParens": "always",
  "endOfLine": "lf",
  "quoteProps": "as-needed",
  "jsxSingleQuote": false,
  "bracketSameLine": false,
  "htmlWhitespaceSensitivity": "css",
  "vueIndentScriptAndStyle": false,
  "proseWrap": "preserve",
  "insertPragma": false,
  "requirePragma": false,
  "embeddedLanguageFormatting": "auto",
  "plugins": [
    "prettier-plugin-tailwindcss"
  ],
  "tailwindConfig": "./tailwind.config.js"
}
```

---

## 5. 初始化脚本

### 5.1 完整初始化脚本（setup.sh）

```bash
#!/bin/bash

# ============================================================
# 项目初始化脚本
# 用途：自动化创建新项目脚手架
# 用法：./setup.sh <project-name> [template]
# ============================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目配置
PROJECT_NAME=$1
TEMPLATE=${2:-"react-vite"}
NODE_VERSION="20"

# 打印函数
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查参数
check_params() {
    if [ -z "$PROJECT_NAME" ]; then
        print_error "请提供项目名称"
        echo "用法: ./setup.sh <project-name> [template]"
        echo "可用模板: react-vite, nextjs, vue-vite"
        exit 1
    fi

    if [ -d "$PROJECT_NAME" ]; then
        print_error "目录 '$PROJECT_NAME' 已存在"
        exit 1
    fi
}

# 检查环境
check_environment() {
    print_info "检查环境..."

    # 检查 Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js 未安装"
        exit 1
    fi

    NODE_CURRENT=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_CURRENT" -lt "$NODE_VERSION" ]; then
        print_error "Node.js 版本需要 >= $NODE_VERSION"
        exit 1
    fi

    # 检查 pnpm
    if ! command -v pnpm &> /dev/null; then
        print_warning "pnpm 未安装，尝试安装..."
        npm install -g pnpm
    fi

    print_success "环境检查通过"
}

# 创建项目目录结构
create_directory_structure() {
    print_info "创建目录结构..."

    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"

    # 创建目录
    mkdir -p \
        .github/workflows \
        .husky \
        .vscode \
        docs \
        public/assets/images \
        src/{assets/{styles,images,fonts},components/{ui,common},hooks,layouts,pages,routes,services/{api,types},stores/slices,utils/{helpers,constants,types},contexts,config} \
        tests/{unit,integration,e2e} \
        scripts \
        types

    print_success "目录结构创建完成"
}

# 创建 package.json
create_package_json() {
    print_info "创建 package.json..."

    cat > package.json << 'EOF'
{
  "name": "PROJECT_NAME_PLACEHOLDER",
  "private": true,
  "version": "0.0.1",
  "type": "module",
  "description": "A modern React application built with Vite",
  "author": "Your Name <your.email@example.com>",
  "license": "MIT",
  "engines": {
    "node": ">=20.0.0",
    "pnpm": ">=8.0.0"
  },
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "build:analyze": "tsc && vite build --mode analyze",
    "preview": "vite preview",
    "test": "vitest",
    "test:ui": "vitest --ui",
    "test:coverage": "vitest --coverage",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "lint:fix": "eslint . --ext ts,tsx --fix",
    "format": "prettier --write \"src/**/*.{ts,tsx,css,scss}\"",
    "format:check": "prettier --check \"src/**/*.{ts,tsx,css,scss}\"",
    "type-check": "tsc --noEmit",
    "prepare": "husky install",
    "commit": "cz",
    "release": "standard-version"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.21.0",
    "zustand": "^4.4.7",
    "@tanstack/react-query": "^5.13.4",
    "axios": "^1.6.2",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.1.0",
    "class-variance-authority": "^0.7.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.43",
    "@types/react-dom": "^18.2.17",
    "@typescript-eslint/eslint-plugin": "^6.14.0",
    "@typescript-eslint/parser": "^6.14.0",
    "@vitejs/plugin-react": "^4.2.1",
    "@vitest/coverage-v8": "^1.0.4",
    "@vitest/ui": "^1.0.4",
    "@playwright/test": "^1.40.1",
    "autoprefixer": "^10.4.16",
    "eslint": "^8.55.0",
    "eslint-config-prettier": "^9.1.0",
    "eslint-import-resolver-typescript": "^3.6.1",
    "eslint-plugin-import": "^2.29.0",
    "eslint-plugin-jsx-a11y": "^6.8.0",
    "eslint-plugin-react": "^7.33.2",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-simple-import-sort": "^10.0.0",
    "eslint-plugin-unused-imports": "^3.0.0",
    "husky": "^8.0.3",
    "lint-staged": "^15.2.0",
    "postcss": "^8.4.32",
    "prettier": "^3.1.1",
    "prettier-plugin-tailwindcss": "^0.5.9",
    "tailwindcss": "^3.3.6",
    "tailwindcss-animate": "^1.0.7",
    "@tailwindcss/forms": "^0.5.7",
    "@tailwindcss/typography": "^0.5.10",
    "typescript": "^5.3.3",
    "vite": "^5.0.8",
    "rollup-plugin-visualizer": "^5.11.0",
    "vitest": "^1.0.4",
    "jsdom": "^23.0.1",
    "@testing-library/react": "^14.1.2",
    "@testing-library/jest-dom": "^6.1.5",
    "@testing-library/user-event": "^14.5.1",
    "commitizen": "^4.3.0",
    "cz-conventional-changelog": "^3.3.0",
    "standard-version": "^9.5.0"
  },
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{css,scss}": [
      "prettier --write"
    ]
  },
  "config": {
    "commitizen": {
      "path": "./node_modules/cz-conventional-changelog"
    }
  }
}
EOF

    # 替换项目名称
    sed -i.bak "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" package.json
    rm -f package.json.bak

    print_success "package.json 创建完成"
}

# 创建配置文件
create_config_files() {
    print_info "创建配置文件..."

    # .gitignore
    cat > .gitignore << 'EOF'
# Dependencies
node_modules
.pnp
.pnp.js

# Build outputs
dist
dist-ssr
build
*.local

# Environment files
.env
.env.local
.env.*.local

# IDE
.idea
.vscode/*
!.vscode/extensions.json
!.vscode/settings.json
!.vscode/launch.json
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# OS
.DS_Store
Thumbs.db

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

# Testing
coverage
.nyc_output

# Cache
.cache
.temp
*.tsbuildinfo

# Misc
*.pem
.eslintcache
.stylelintcache
EOF

    # .nvmrc
    echo "$NODE_VERSION" > .nvmrc

    # .env.example
    cat > .env.example << 'EOF'
# API Configuration
VITE_API_URL=http://localhost:3000
VITE_API_TIMEOUT=10000

# App Configuration
VITE_APP_NAME=MyApp
VITE_APP_VERSION=1.0.0

# Feature Flags
VITE_ENABLE_ANALYTICS=false
VITE_ENABLE_DEBUG=false
EOF

    # README.md
    cat > README.md << EOF
# $PROJECT_NAME

> A modern React application built with Vite, TypeScript, and Tailwind CSS.

## 🚀 快速开始

### 环境要求

- Node.js >= 20.0.0
- pnpm >= 8.0.0

### 安装

\`\`\`bash
# 克隆项目
git clone <repository-url>
cd $PROJECT_NAME

# 安装依赖
pnpm install

# 启动开发服务器
pnpm dev
\`\`\`

### 可用脚本

| 脚本 | 描述 |
|------|------|
| \`pnpm dev\` | 启动开发服务器 |
| \`pnpm build\` | 构建生产版本 |
| \`pnpm preview\` | 预览生产构建 |
| \`pnpm test\` | 运行测试 |
| \`pnpm test:coverage\` | 生成测试覆盖率报告 |
| \`pnpm lint\` | 运行 ESLint |
| \`pnpm lint:fix\` | 自动修复 ESLint 问题 |
| \`pnpm format\` | 格式化代码 |
| \`pnpm type-check\` | 运行 TypeScript 类型检查 |

## 📁 项目结构

\`\`\`
src/
├── assets/         # 静态资源
├── components/     # 组件
├── hooks/          # 自定义 Hooks
├── layouts/        # 布局组件
├── pages/          # 页面组件
├── routes/         # 路由配置
├── services/       # API 服务
├── stores/         # 状态管理
├── utils/          # 工具函数
├── contexts/       # React Context
└── config/         # 应用配置
\`\`\`

## 🛠️ 技术栈

- **框架**: React 18
- **语言**: TypeScript 5
- **构建工具**: Vite 5
- **样式**: Tailwind CSS
- **状态管理**: Zustand
- **路由**: React Router v6
- **HTTP 客户端**: Axios + TanStack Query
- **测试**: Vitest + React Testing Library + Playwright

## 📄 许可证

[MIT](LICENSE)
EOF

    print_success "配置文件创建完成"
}

# 安装依赖
install_dependencies() {
    print_info "安装依赖..."

    pnpm install

    print_success "依赖安装完成"
}

# 初始化 Git
init_git() {
    print_info "初始化 Git 仓库..."

    git init
    git add .
    git commit -m "chore: initial commit"

    print_success "Git 仓库初始化完成"
}

# 设置 Husky
setup_husky() {
    print_info "设置 Husky..."

    npx husky install
    npx husky add .husky/pre-commit "npx lint-staged"
    npx husky add .husky/commit-msg 'npx --no-install commitlint --edit "$1"'

    print_success "Husky 设置完成"
}

# 主函数
main() {
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}  项目脚手架初始化工具${NC}"
    echo -e "${GREEN}================================${NC}"
    echo ""

    check_params
    check_environment
    create_directory_structure
    create_package_json
    create_config_files
    install_dependencies
    init_git
    setup_husky

    echo ""
    echo -e "${GREEN}================================${NC}"
    print_success "项目 '$PROJECT_NAME' 初始化完成！"
    echo -e "${GREEN}================================${NC}"
    echo ""
    echo "下一步:"
    echo "  cd $PROJECT_NAME"
    echo "  pnpm dev"
    echo ""
}

# 执行主函数
main
```

### 5.2 Node.js 初始化脚本（init-project.js）

```javascript
#!/usr/bin/env node

/**
 * 项目初始化脚本（Node.js 版本）
 * 用途：跨平台项目脚手架创建
 * 用法：node init-project.js <project-name> [--template=react-vite]
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// 配置
const CONFIG = {
  nodeVersion: '20',
  templates: {
    'react-vite': {
      name: 'React + Vite',
      dependencies: ['react', 'react-dom', 'react-router-dom'],
      devDependencies: [
        '@types/react',
        '@types/react-dom',
        '@vitejs/plugin-react',
        'typescript',
        'vite',
      ],
    },
    'nextjs': {
      name: 'Next.js',
      dependencies: ['next', 'react', 'react-dom'],
      devDependencies: ['@types/node', '@types/react', '@types/react-dom', 'typescript'],
    },
    'vue-vite': {
      name: 'Vue + Vite',
      dependencies: ['vue', 'vue-router', 'pinia'],
      devDependencies: ['@vitejs/plugin-vue', 'typescript', 'vite', 'vue-tsc'],
    },
  },
};

// 颜色工具
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
};

const log = {
  info: (msg) => console.log(`${colors.blue}[INFO]${colors.reset} ${msg}`),
  success: (msg) => console.log(`${colors.green}[SUCCESS]${colors.reset} ${msg}`),
  warning: (msg) => console.log(`${colors.yellow}[WARNING]${colors.reset} ${msg}`),
  error: (msg) => console.log(`${colors.red}[ERROR]${colors.reset} ${msg}`),
};

// 解析参数
function parseArgs() {
  const args = process.argv.slice(2);
  const projectName = args[0];
  const templateArg = args.find((arg) => arg.startsWith('--template='));
  const template = templateArg ? templateArg.split('=')[1] : 'react-vite';

  return { projectName, template };
}

// 验证参数
function validateArgs(projectName, template) {
  if (!projectName) {
    log.error('请提供项目名称');
    console.log('用法: node init-project.js <project-name> [--template=react-vite]');
    console.log('可用模板:', Object.keys(CONFIG.templates).join(', '));
    process.exit(1);
  }

  if (!CONFIG.templates[template]) {
    log.error(`未知模板: ${template}`);
    console.log('可用模板:', Object.keys(CONFIG.templates).join(', '));
    process.exit(1);
  }

  if (fs.existsSync(projectName)) {
    log.error(`目录 '${projectName}' 已存在`);
    process.exit(1);
  }
}

// 检查环境
function checkEnvironment() {
  log.info('检查环境...');

  try {
    const nodeVersion = process.version;
    const majorVersion = parseInt(nodeVersion.slice(1).split('.')[0]);

    if (majorVersion < parseInt(CONFIG.nodeVersion)) {
      log.error(`Node.js 版本需要 >= ${CONFIG.nodeVersion}`);
      process.exit(1);
    }

    log.success(`Node.js 版本: ${nodeVersion}`);
  } catch (error) {
    log.error('无法检查 Node.js 版本');
    process.exit(1);
  }
}

// 创建目录
function createDirectories(projectName) {
  log.info('创建目录结构...');

  const directories = [
    '.github/workflows',
    '.husky',
    '.vscode',
    'docs',
    'public/assets/images',
    'src/assets/styles',
    'src/assets/images',
    'src/components/ui',
    'src/components/common',
    'src/hooks',
    'src/layouts',
    'src/pages',
    'src/routes',
    'src/services/api',
    'src/services/types',
    'src/stores/slices',
    'src/utils/helpers',
    'src/utils/constants',
    'src/contexts',
    'src/config',
    'tests/unit',
    'tests/integration',
    'tests/e2e',
    'scripts',
    'types',
  ];

  directories.forEach((dir) => {
    fs.mkdirSync(path.join(projectName, dir), { recursive: true });
  });

  log.success('目录结构创建完成');
}

// 创建文件
function createFile(projectName, filePath, content) {
  const fullPath = path.join(projectName, filePath);
  fs.writeFileSync(fullPath, content, 'utf-8');
}

// 生成 package.json
function generatePackageJson(projectName, template) {
  const templateConfig = CONFIG.templates[template];

  return {
    name: projectName,
    private: true,
    version: '0.0.1',
    type: 'module',
    description: `A ${templateConfig.name} application`,
    scripts: {
      dev: template === 'nextjs' ? 'next dev' : 'vite',
      build: template === 'nextjs' ? 'next build' : 'tsc && vite build',
      start: template === 'nextjs' ? 'next start' : undefined,
      preview: template === 'nextjs' ? undefined : 'vite preview',
      test: 'vitest',
      'test:coverage': 'vitest --coverage',
      lint: 'eslint . --ext ts,tsx --report-unused-disable-directives',
      'lint:fix': 'eslint . --ext ts,tsx --fix',
      format: 'prettier --write "src/**/*.{ts,tsx,css}"',
      'type-check': 'tsc --noEmit',
    },
    dependencies: {},
    devDependencies: {},
    engines: {
      node: `>=${CONFIG.nodeVersion}.0.0`,
    },
  };
}

// 创建配置文件
function createConfigFiles(projectName, template) {
  log.info('创建配置文件...');

  // .gitignore
  createFile(
    projectName,
    '.gitignore',
    `# Dependencies
node_modules
.pnp
.pnp.js

# Build outputs
dist
dist-ssr
build
.next
*.local

# Environment files
.env
.env.local
.env.*.local

# IDE
.idea
.vscode/*
!.vscode/extensions.json
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# OS
.DS_Store
Thumbs.db

# Logs
logs
*.log
npm-debug.log*

# Testing
coverage
.nyc_output

# Cache
.cache
.temp
*.tsbuildinfo
`
  );

  // .nvmrc
  createFile(projectName, '.nvmrc', CONFIG.nodeVersion);

  // .env.example
  createFile(
    projectName,
    '.env.example',
    `# App Configuration
VITE_APP_NAME=${projectName}
VITE_APP_VERSION=1.0.0

# API Configuration
VITE_API_URL=http://localhost:3000
`
  );

  // README.md
  createFile(
    projectName,
    'README.md',
    `# ${projectName}

> A ${CONFIG.templates[template].name} application.

## 🚀 快速开始

\`\`\`bash
# 安装依赖
npm install

# 启动开发服务器
npm run dev
\`\`\`

## 📄 许可证

MIT
`
  );

  log.success('配置文件创建完成');
}

// 初始化 Git
function initGit(projectName) {
  log.info('初始化 Git 仓库...');

  try {
    execSync('git init', { cwd: projectName, stdio: 'ignore' });
    execSync('git add .', { cwd: projectName, stdio: 'ignore' });
    execSync('git commit -m "chore: initial commit"', {
      cwd: projectName,
      stdio: 'ignore',
    });
    log.success('Git 仓库初始化完成');
  } catch (error) {
    log.warning('Git 初始化失败，请手动执行');
  }
}

// 主函数
function main() {
  console.log(`${colors.green}================================${colors.reset}`);
  console.log(`${colors.green}  项目脚手架初始化工具${colors.reset}`);
  console.log(`${colors.green}================================${colors.reset}`);
  console.log('');

  const { projectName, template } = parseArgs();

  validateArgs(projectName, template);
  checkEnvironment();
  createDirectories(projectName);

  // 创建 package.json
  const packageJson = generatePackageJson(projectName, template);
  createFile(projectName, 'package.json', JSON.stringify(packageJson, null, 2));

  createConfigFiles(projectName, template);
  initGit(projectName);

  console.log('');
  console.log(`${colors.green}================================${colors.reset}`);
  log.success(`项目 '${projectName}' 初始化完成！`);
  console.log(`${colors.green}================================${colors.reset}`);
  console.log('');
  console.log('下一步:');
  console.log(`  cd ${projectName}`);
  console.log('  npm install');
  console.log('  npm run dev');
  console.log('');
}

// 执行
main();
```

### 5.3 使用说明

```bash
# 1. 使用 Bash 脚本
chmod +x setup.sh
./setup.sh my-project react-vite

# 2. 使用 Node.js 脚本
node init-project.js my-project --template=react-vite

# 3. 安装依赖后启动
cd my-project
pnpm install
pnpm dev
```

---

## 附录

### A. 推荐 VS Code 扩展

```json
// .vscode/extensions.json
{
  "recommendations": [
    "bradlc.vscode-tailwindcss",
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "formulahendry.auto-rename-tag",
    "christian-kohler.path-intellisense",
    "ms-vscode.vscode-typescript-next",
    "streetsidesoftware.code-spell-checker",
    "usernamehw.errorlens",
    "yoavbls.pretty-ts-errors",
    "antfu.iconify",
    "mikestead.dotenv"
  ]
}
```

### B. 推荐 VS Code 设置

```json
// .vscode/settings.json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit",
    "source.organizeImports": "explicit"
  },
  "typescript.preferences.importModuleSpecifier": "relative",
  "tailwindCSS.includeLanguages": {
    "typescript": "javascript",
    "typescriptreact": "javascript"
  },
  "files.associations": {
    "*.css": "tailwindcss"
  }
}
```

---

*文档版本: 1.0.0*
*最后更新: 2024年*
