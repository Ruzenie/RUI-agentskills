---
title: 前端代码规范
description: React + TypeScript + Tailwind CSS 项目开发规范
date: 2024-01-15
author: Frontend Team
version: 1.0.0
---

# 前端代码规范

> 本规范适用于 React + TypeScript + Tailwind CSS 技术栈的前端项目

## 目录

- [1. 项目目录结构规范](#1-项目目录结构规范)
- [2. 组件分类与文件组织](#2-组件分类与文件组织)
- [3. 命名规范](#3-命名规范)
- [4. TypeScript规范](#4-typescript规范)
- [5. React/JSX规范](#5-reactjsx规范)
- [6. CSS/Tailwind规范](#6-csstailwind规范)
- [7. 性能规范](#7-性能规范)
- [8. 测试规范](#8-测试规范)
- [9. 安全规范](#9-安全规范)
- [10. 强制规则清单](#10-强制规则清单)

---

## 1. 项目目录结构规范

### 1.1 完整项目目录结构示例

```
project-root/
├── .github/                    # GitHub 配置
│   └── workflows/              # CI/CD 工作流
├── public/                     # 静态资源
│   ├── favicon.ico
│   ├── robots.txt
│   └── assets/                 # 无需构建的静态资源
├── src/
│   ├── api/                    # API 请求层
│   │   ├── client.ts           # axios/fetch 实例
│   │   ├── endpoints/          # 按模块组织的 API
│   │   └── types/              # API 类型定义
│   ├── assets/                 # 需要构建的静态资源
│   │   ├── images/
│   │   ├── icons/
│   │   └── fonts/
│   ├── components/             # 组件库（原子设计）
│   │   ├── atoms/              # 原子组件
│   │   ├── molecules/          # 分子组件
│   │   ├── organisms/          # 有机体组件
│   │   ├── templates/          # 模板组件
│   │   └── pages/              # 页面组件
│   ├── config/                 # 配置文件
│   │   ├── routes.ts           # 路由配置
│   │   ├── theme.ts            # 主题配置
│   │   └── constants.ts        # 常量定义
│   ├── hooks/                  # 自定义 Hooks
│   │   ├── useAuth.ts
│   │   ├── useLocalStorage.ts
│   │   └── index.ts            # 统一导出
│   ├── lib/                    # 第三方库封装
│   │   ├── queryClient.ts      # React Query 配置
│   │   └── utils.ts            # 工具函数
│   ├── providers/              # 上下文提供者
│   │   ├── AppProvider.tsx
│   │   └── index.tsx
│   ├── stores/                 # 状态管理
│   │   ├── slices/
│   │   └── index.ts
│   ├── styles/                 # 全局样式
│   │   ├── globals.css
│   │   └── variables.css
│   ├── types/                  # 全局类型定义
│   │   ├── common.ts
│   │   └── index.ts
│   ├── utils/                  # 工具函数
│   │   ├── formatters.ts
│   │   ├── validators.ts
│   │   └── index.ts
│   ├── App.tsx
│   └── main.tsx
├── tests/                      # 测试文件
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── .editorconfig
├── .env.example
├── .eslintrc.js
├── .gitignore
├── .prettierrc
├── index.html
├── package.json
├── tailwind.config.js
├── tsconfig.json
└── vite.config.ts
```

### 1.2 目录组织原则

| 原则 | 说明 | 示例 |
|------|------|------|
| **按功能组织** | 相关功能文件放在一起 | `UserProfile/` 包含组件、样式、测试 |
| **扁平优先** | 避免过深的嵌套 | 最多 3 层目录深度 |
| **单一职责** | 每个目录有明确职责 | `api/` 只处理网络请求 |
| **可预测性** | 目录命名一致 | 始终使用复数形式 |

---

## 2. 组件分类与文件组织

### 2.1 原子设计五层架构

```
┌─────────────────────────────────────────────────────────┐
│  PAGES (页面)        完整页面，路由级别                   │
│  例: DashboardPage, LoginPage, UserProfilePage          │
├─────────────────────────────────────────────────────────┤
│  TEMPLATES (模板)    页面布局结构，不含真实数据           │
│  例: DashboardLayout, AuthLayout, SidebarLayout         │
├─────────────────────────────────────────────────────────┤
│  ORGANISMS (有机体)  复杂功能区块，可独立存在             │
│  例: Header, Sidebar, DataTable, FormSection            │
├─────────────────────────────────────────────────────────┤
│  MOLECULES (分子)    简单组件组合，有明确功能             │
│  例: SearchBar, FormField, CardHeader, NavItem          │
├─────────────────────────────────────────────────────────┤
│  ATOMS (原子)        最小不可再分单元                     │
│  例: Button, Input, Label, Icon, Text                   │
└─────────────────────────────────────────────────────────┘
```

### 2.2 各层详细说明

#### Atoms（原子组件）

```typescript
// src/components/atoms/Button/Button.tsx
import { forwardRef } from 'react';
import { cn } from '@/lib/utils';
import { buttonVariants } from './variants';
import type { ButtonProps } from './types';

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant = 'primary', size = 'md', ...props }, ref) => {
    return (
      <button
        ref={ref}
        className={cn(buttonVariants({ variant, size }), className)}
        {...props}
      />
    );
  }
);

Button.displayName = 'Button';
```

**文件组织：**
```
Button/
├── Button.tsx          # 主组件
├── Button.test.tsx     # 测试文件
├── Button.stories.tsx  # Storybook 文档
├── types.ts            # 类型定义
├── variants.ts         # 样式变体（cva）
└── index.ts            # 统一导出
```

#### Molecules（分子组件）

```typescript
// src/components/molecules/SearchBar/SearchBar.tsx
import { useState } from 'react';
import { Input } from '@/components/atoms/Input';
import { Button } from '@/components/atoms/Button';
import { Icon } from '@/components/atoms/Icon';
import type { SearchBarProps } from './types';

export function SearchBar({ onSearch, placeholder }: SearchBarProps) {
  const [query, setQuery] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSearch(query);
  };

  return (
    <form onSubmit={handleSubmit} className="flex gap-2">
      <Input
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder={placeholder}
      />
      <Button type="submit">
        <Icon name="search" />
      </Button>
    </form>
  );
}
```

#### Organisms（有机体组件）

```typescript
// src/components/organisms/DataTable/DataTable.tsx
import { useMemo } from 'react';
import { TableHeader } from './TableHeader';
import { TableBody } from './TableBody';
import { TablePagination } from './TablePagination';
import { useTableSort } from './hooks/useTableSort';
import type { DataTableProps, Column } from './types';

export function DataTable<T extends Record<string, unknown>>({
  data,
  columns,
  pagination,
}: DataTableProps<T>) {
  const { sortedData, sortConfig, handleSort } = useTableSort(data);

  return (
    <div className="rounded-lg border">
      <table className="w-full">
        <TableHeader columns={columns} sortConfig={sortConfig} onSort={handleSort} />
        <TableBody data={sortedData} columns={columns} />
      </table>
      {pagination && <TablePagination {...pagination} />}
    </div>
  );
}
```

#### Templates（模板组件）

```typescript
// src/components/templates/DashboardLayout/DashboardLayout.tsx
import { Header } from '@/components/organisms/Header';
import { Sidebar } from '@/components/organisms/Sidebar';
import type { DashboardLayoutProps } from './types';

export function DashboardLayout({ 
  children, 
  sidebarItems,
  user 
}: DashboardLayoutProps) {
  return (
    <div className="flex h-screen">
      <Sidebar items={sidebarItems} />
      <div className="flex flex-1 flex-col">
        <Header user={user} />
        <main className="flex-1 overflow-auto p-6">
          {children}
        </main>
      </div>
    </div>
  );
}
```

#### Pages（页面组件）

```typescript
// src/components/pages/DashboardPage/DashboardPage.tsx
import { useQuery } from '@tanstack/react-query';
import { DashboardLayout } from '@/components/templates/DashboardLayout';
import { StatsCard } from '@/components/organisms/StatsCard';
import { DataTable } from '@/components/organisms/DataTable';
import { fetchDashboardData } from '@/api/endpoints/dashboard';

export function DashboardPage() {
  const { data, isLoading } = useQuery({
    queryKey: ['dashboard'],
    queryFn: fetchDashboardData,
  });

  if (isLoading) return <DashboardSkeleton />;

  return (
    <DashboardLayout sidebarItems={data.sidebarItems} user={data.user}>
      <div className="grid grid-cols-4 gap-4">
        {data.stats.map((stat) => (
          <StatsCard key={stat.id} {...stat} />
        ))}
      </div>
      <DataTable data={data.tableData} columns={columns} />
    </DashboardLayout>
  );
}
```

### 2.3 组件文件模板

```typescript
// 标准组件模板
import { forwardRef } from 'react';
import { cn } from '@/lib/utils';
import type { ComponentNameProps } from './types';

/**
 * ComponentName 组件描述
 * @description 详细描述组件的用途和行为
 * @example
 * ```tsx
 * <ComponentName prop1="value" />
 * ```
 */
export const ComponentName = forwardRef<HTMLElement, ComponentNameProps>(
  ({ className, children, ...props }, ref) => {
    return (
      <div ref={ref} className={cn('base-classes', className)} {...props}>
        {children}
      </div>
    );
  }
);

ComponentName.displayName = 'ComponentName';
```

---

## 3. 命名规范

### 3.1 完整命名规则表

| 类型 | 规则 | 示例 | 反例 |
|------|------|------|------|
| **文件/目录** | kebab-case | `user-profile.tsx` | `UserProfile.tsx`, `userProfile.tsx` |
| **组件** | PascalCase | `UserProfile` | `userProfile`, `user-profile` |
| **Hook** | camelCase + use前缀 | `useAuth` | `UseAuth`, `useauth` |
| **工具函数** | camelCase | `formatDate` | `FormatDate`, `format_date` |
| **常量** | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` | `maxRetryCount`, `MaxRetryCount` |
| **类型/接口** | PascalCase + 后缀 | `UserProps`, `ApiResponse` | `userProps`, `IUser` |
| **枚举** | PascalCase | `StatusCode` | `statusCode`, `STATUS_CODE` |
| **枚举成员** | PascalCase | `StatusCode.NotFound` | `StatusCode.NOT_FOUND` |
| **CSS 类名** | kebab-case | `btn-primary` | `btnPrimary`, `BtnPrimary` |
| **测试文件** | `.test.ts` 后缀 | `Button.test.tsx` | `Button.spec.tsx` |
| **Storybook** | `.stories.ts` 后缀 | `Button.stories.tsx` | `Button.story.tsx` |
| **类型文件** | `.types.ts` 后缀 | `Button.types.ts` | `Button.type.ts` |

### 3.2 变量命名规范

```typescript
// ✅ 正确示例
const userName = 'John';                    // 基本变量：camelCase
const MAX_RETRY_COUNT = 3;                  // 常量：UPPER_SNAKE_CASE
const isLoading = true;                     // 布尔值：is/has/should 前缀
const hasPermission = false;
const shouldShowModal = true;
const userList: User[] = [];                // 数组：复数形式
const userMap: Map<string, User> = new Map(); // Map：Map 后缀
const handleClick = () => {};               // 事件处理：handle 前缀
const onSubmit = () => {};                  // 回调属性：on 前缀
const getUserData = async () => {};         // 获取数据：get 前缀
const fetchUserList = async () => {};       // 网络请求：fetch 前缀

// ❌ 错误示例
const user_name = 'John';                   // 使用下划线
const maxretrycount = 3;                    // 全小写
const loading = true;                       // 布尔值无前缀
const arr = [];                             // 无意义名称
const data = {};                            // 过于笼统
const tmp = '';                             // 缩写
```

### 3.3 函数命名规范

```typescript
// ✅ 正确示例
// 动作 + 对象
function validateEmail(email: string): boolean {}
function parseJSON<T>(json: string): T {}
function formatCurrency(amount: number): string {}

// 布尔判断
function isValidEmail(email: string): boolean {}
function hasEmptyField(data: object): boolean {}
function shouldUpdateCache(timestamp: number): boolean {}

// 异步操作
async function fetchUserData(id: string): Promise<User> {}
async function createUser(payload: CreateUserPayload): Promise<User> {}
async function updateUserSettings(settings: UserSettings): Promise<void> {}

// 副作用操作
function initializeApp(): void {}
function cleanupResources(): void {}

// ❌ 错误示例
function check() {}                         // 过于笼统
function process() {}                       // 不明确
function data() {}                          // 名词作函数名
function doSomething() {}                   // 无意义
```

### 3.4 事件处理命名

```typescript
// ✅ 正确示例
// 组件内部事件处理
const handleClick = () => {};
const handleSubmit = (e: FormEvent) => {};
const handleInputChange = (e: ChangeEvent<HTMLInputElement>) => {};
const handleKeyDown = (e: KeyboardEvent) => {};

// Props 回调
interface ButtonProps {
  onClick?: () => void;
  onSubmit?: (data: FormData) => void;
  onChange?: (value: string) => void;
}

// 自定义事件
const onUserSelect = (user: User) => {};
const onFilterChange = (filters: FilterState) => {};

// ❌ 错误示例
const clickHandler = () => {};              // 名词形式
const onClickHandler = () => {};            // 冗余
const click = () => {};                     // 过于简短
```

---

## 4. TypeScript规范

### 4.1 类型定义最佳实践

```typescript
// ✅ 正确示例

// 1. 优先使用 interface 定义对象类型
interface User {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
}

// 2. 使用 type 定义联合类型、交叉类型、元组
type Status = 'idle' | 'loading' | 'success' | 'error';
type Theme = 'light' | 'dark' | 'system';
type Response<T> = { data: T; status: number } | { error: string; status: number };

// 3. Props 接口命名
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  onClick?: () => void;
  children: React.ReactNode;
}

// 4. 使用泛型提高复用性
interface ApiResponse<T> {
  data: T;
  status: number;
  message: string;
}

interface PaginatedResponse<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
}

// 5. 使用 satisfies 进行类型约束
const config = {
  apiUrl: 'https://api.example.com',
  timeout: 5000,
} satisfies { apiUrl: string; timeout: number };

// 6. 使用 as const 创建不可变对象
const HTTP_STATUS = {
  OK: 200,
  NOT_FOUND: 404,
  SERVER_ERROR: 500,
} as const;

// ❌ 错误示例
// 避免使用 any
type BadType = any;

// 避免冗余的类型注解
const count: number = 0;  // 可以推断，无需注解

// 避免使用 Function 类型
const badCallback: Function = () => {};
```

### 4.2 Props 接口规范

```typescript
// ✅ 完整 Props 接口示例
import type { ReactNode, ComponentPropsWithoutRef } from 'react';

// 基础 Props
interface BaseProps {
  /** 自定义类名 */
  className?: string;
  /** 子元素 */
  children?: ReactNode;
  /** 测试ID */
  'data-testid'?: string;
}

// 组件 Props
interface CardProps extends BaseProps {
  /** 卡片标题 */
  title?: string;
  /** 标题右侧操作 */
  extra?: ReactNode;
  /** 是否加载中 */
  loading?: boolean;
  /** 点击事件 */
  onClick?: () => void;
}

// 使用 ComponentPropsWithoutRef 继承原生属性
interface InputProps extends ComponentPropsWithoutRef<'input'> {
  /** 标签文本 */
  label?: string;
  /** 错误信息 */
  error?: string;
  /** 帮助文本 */
  helperText?: string;
}

// 泛型组件 Props
interface DataTableProps<T extends Record<string, unknown>> {
  /** 表格数据 */
  data: T[];
  /** 列配置 */
  columns: Column<T>[];
  /** 行唯一标识字段 */
  rowKey: keyof T;
  /** 行点击事件 */
  onRowClick?: (record: T) => void;
}
```

### 4.3 泛型使用规范

```typescript
// ✅ 正确示例

// 1. 泛型函数
function identity<T>(value: T): T {
  return value;
}

// 2. 泛型约束
interface HasId {
  id: string;
}

function findById<T extends HasId>(items: T[], id: string): T | undefined {
  return items.find((item) => item.id === id);
}

// 3. 泛型 Hook
function useLocalStorage<T>(key: string, initialValue: T) {
  const [value, setValue] = useState<T>(() => {
    const stored = localStorage.getItem(key);
    return stored ? (JSON.parse(stored) as T) : initialValue;
  });
  
  // ...
  
  return [value, setValue] as const;
}

// 4. 泛型组件
interface ListProps<T> {
  items: T[];
  renderItem: (item: T, index: number) => ReactNode;
  keyExtractor: (item: T) => string;
}

function List<T>({ items, renderItem, keyExtractor }: ListProps<T>) {
  return (
    <ul>
      {items.map((item, index) => (
        <li key={keyExtractor(item)}>{renderItem(item, index)}</li>
      ))}
    </ul>
  );
}

// 5. 条件类型
type NonNullable<T> = T extends null | undefined ? never : T;

// 6. 映射类型
type Readonly<T> = { readonly [P in keyof T]: T[P] };
type Optional<T> = { [P in keyof T]?: T[P] };
```

### 4.4 类型工具使用

```typescript
// ✅ 常用类型工具
import type { 
  ComponentProps, 
  ComponentPropsWithoutRef,
  ComponentPropsWithRef,
  ReactNode,
  ReactElement,
  MouseEvent,
  ChangeEvent,
  FormEvent 
} from 'react';

// 提取组件 Props
type ButtonProps = ComponentProps<typeof Button>;

// 排除某些属性
type InputPropsWithoutOnChange = Omit<ComponentProps<'input'>, 'onChange'>;

// 选取某些属性
type PickProps = Pick<ButtonProps, 'variant' | 'size'>;

// 部分属性可选
type PartialProps = Partial<ButtonProps>;

// 必填属性
type RequiredProps = Required<Pick<ButtonProps, 'onClick'>>;

// 返回类型
type ReturnType<T extends (...args: any[]) => any> = 
  T extends (...args: any[]) => infer R ? R : never;

// 参数类型
type Parameters<T extends (...args: any[]) => any> = 
  T extends (...args: infer P) => any ? P : never;
```

---

## 5. React/JSX规范

### 5.1 Hooks 十条规则

```typescript
/**
 * ============================================
 * React Hooks 使用规则
 * ============================================
 */

// 规则 1: 只在最顶层调用 Hooks
// ✅ 正确
function Component() {
  const [count, setCount] = useState(0);
  const [name, setName] = useState('');
  
  if (condition) {
    // 可以在这里使用，但 Hooks 声明必须在条件之前
  }
}

// ❌ 错误
function BadComponent() {
  if (condition) {
    const [state, setState] = useState(0);  // 错误！
  }
}

// 规则 2: 只在 React 函数中调用 Hooks
// ✅ 正确
function Component() {
  const [state, setState] = useState(0);
}

function useCustomHook() {
  const [state, setState] = useState(0);
}

// ❌ 错误
function regularFunction() {
  const [state, setState] = useState(0);  // 错误！
}

// 规则 3: useEffect 依赖数组必须完整
// ✅ 正确
function Component({ userId }) {
  const [user, setUser] = useState(null);
  
  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);  // 包含所有依赖
}

// ❌ 错误
function BadComponent({ userId }) {
  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, []);  // 缺少依赖！
}

// 规则 4: 使用函数式更新避免依赖问题
// ✅ 正确
function Counter() {
  const [count, setCount] = useState(0);
  
  useEffect(() => {
    const timer = setInterval(() => {
      setCount(c => c + 1);  // 函数式更新
    }, 1000);
    return () => clearInterval(timer);
  }, []);  // 不需要依赖 count
}

// 规则 5: 自定义 Hook 必须以 use 开头
// ✅ 正确
function useLocalStorage<T>(key: string, initialValue: T) {
  // ...
}

function useDebounce<T>(value: T, delay: number) {
  // ...
}

// ❌ 错误
function localStorageHook() {  // 错误！
  // ...
}

// 规则 6: useCallback 用于传递给子组件的函数
// ✅ 正确
function Parent() {
  const [count, setCount] = useState(0);
  
  const handleClick = useCallback(() => {
    setCount(c => c + 1);
  }, []);
  
  return <Child onClick={handleClick} />;
}

// 规则 7: useMemo 用于昂贵的计算
// ✅ 正确
function DataProcessor({ data }) {
  const processedData = useMemo(() => {
    return data
      .filter(item => item.active)
      .map(item => expensiveTransform(item))
      .sort((a, b) => b.score - a.score);
  }, [data]);
  
  return <Table data={processedData} />;
}

// 规则 8: 使用 useRef 存储可变值
// ✅ 正确
function Timer() {
  const intervalRef = useRef<NodeJS.Timeout | null>(null);
  
  useEffect(() => {
    intervalRef.current = setInterval(() => {}, 1000);
    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    };
  }, []);
}

// 规则 9: 避免在 useEffect 中直接使用 async
// ✅ 正确
useEffect(() => {
  const fetchData = async () => {
    const result = await fetchUser();
    setUser(result);
  };
  fetchData();
}, []);

// ❌ 错误
useEffect(async () => {  // useEffect 不能返回 Promise
  const result = await fetchUser();
}, []);

// 规则 10: 清理副作用
// ✅ 正确
useEffect(() => {
  const subscription = subscribe();
  return () => {
    subscription.unsubscribe();  // 清理
  };
}, []);
```

### 5.2 组件编写规范

```typescript
// ✅ 正确示例

// 1. 函数组件声明
interface GreetingProps {
  name: string;
  greeting?: string;
}

function Greeting({ name, greeting = 'Hello' }: GreetingProps) {
  return <h1>{greeting}, {name}!</h1>;
}

// 2. 使用 forwardRef
import { forwardRef } from 'react';

interface InputProps extends React.ComponentPropsWithoutRef<'input'> {
  label: string;
}

const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ label, className, ...props }, ref) => {
    return (
      <div className={className}>
        <label>{label}</label>
        <input ref={ref} {...props} />
      </div>
    );
  }
);

Input.displayName = 'Input';

// 3. 条件渲染
function StatusMessage({ status }: { status: Status }) {
  // 使用对象映射替代多个条件
  const messages: Record<Status, ReactNode> = {
    idle: <p>准备就绪</p>,
    loading: <LoadingSpinner />,
    success: <SuccessMessage />,
    error: <ErrorMessage />,
  };
  
  return messages[status] ?? null;
}

// 4. 列表渲染
function UserList({ users }: { users: User[] }) {
  return (
    <ul>
      {users.map((user) => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}

// 5. 事件处理
function Form() {
  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    // 处理提交
  };
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    console.log(e.target.value);
  };
  
  return (
    <form onSubmit={handleSubmit}>
      <input onChange={handleChange} />
    </form>
  );
}
```

### 5.3 JSX 编写规范

```typescript
// ✅ 正确示例

// 1. 属性顺序
<Component
  // 1. key
  key={item.id}
  // 2. ref
  ref={inputRef}
  // 3. 事件处理
  onClick={handleClick}
  onChange={handleChange}
  // 4. 状态属性
  disabled={isLoading}
  hidden={!isVisible}
  // 5. 数据属性
  data={userData}
  // 6. 其他属性
  className="btn-primary"
/>

// 2. 自闭合标签
<input type="text" />
<img src="image.png" alt="描述" />

// 3. 布尔属性简写
<button disabled>提交</button>
<Component visible />

// 4. 多行 JSX
<div
  className="flex items-center justify-between"
  onClick={handleClick}
>
  <span>内容</span>
</div>

// 5. 条件类名
<div className={cn(
  'base-class',
  isActive && 'active-class',
  size === 'lg' && 'large-class'
)} />

// ❌ 错误示例
// 属性过多不换行
<Component prop1="1" prop2="2" prop3="3" prop4="4" prop5="5" prop6="6" />

// 不必要的 Fragment
<><span>内容</span></>

// 内联函数
<button onClick={() => handleClick(id)} />  // 应该使用 useCallback
```

---

## 6. CSS/Tailwind规范

### 6.1 Tailwind 类名顺序规范

```typescript
/**
 * ============================================
 * Tailwind 类名顺序规范（headwind 顺序）
 * ============================================
 * 
 * 1. Layout (布局)
 * 2. Box Model (盒模型)
 * 3. Typography (排版)
 * 4. Visuals (视觉效果)
 * 5. Misc (其他)
 */

// ✅ 正确示例
function Component() {
  return (
    <div
      className={cn(
        // 1. Layout - 布局相关
        'relative flex items-center justify-between',
        'container mx-auto',
        'grid grid-cols-3 gap-4',
        
        // 2. Box Model - 盒模型
        'm-4 p-6',
        'w-full h-64',
        'min-h-screen max-w-4xl',
        'border-2 border-gray-200 rounded-lg',
        
        // 3. Typography - 排版
        'text-base font-medium text-gray-900',
        'text-center leading-relaxed',
        'truncate',
        
        // 4. Visuals - 视觉效果
        'bg-white shadow-lg',
        'hover:bg-gray-50 focus:ring-2',
        'transition-colors duration-200',
        
        // 5. Misc - 其他
        'cursor-pointer',
        'overflow-hidden',
        'z-10'
      )}
    />
  );
}

// 完整类名顺序表
const classNameOrder = [
  // Layout
  'display', 'position', 'top', 'right', 'bottom', 'left', 'z-index',
  'flex', 'flex-direction', 'flex-wrap', 'flex-grow', 'flex-shrink',
  'justify-content', 'align-items', 'align-content', 'align-self',
  'grid', 'grid-template', 'grid-column', 'grid-row', 'gap',
  'order', 'float', 'clear', 'object-fit', 'object-position',
  'overflow', 'overscroll', 'visibility',
  
  // Box Model
  'box-sizing', 'width', 'height', 'min-width', 'min-height',
  'max-width', 'max-height', 'margin', 'padding',
  'border', 'border-radius', 'outline',
  
  // Typography
  'font-family', 'font-size', 'font-weight', 'font-style',
  'letter-spacing', 'line-height', 'text-align', 'text-color',
  'text-decoration', 'text-transform', 'text-overflow',
  'white-space', 'word-break',
  
  // Visuals
  'background', 'background-color', 'background-image',
  'box-shadow', 'opacity', 'mix-blend-mode',
  'transform', 'transition', 'animation',
  'cursor', 'pointer-events', 'user-select',
  
  // Interactivity
  'hover:', 'focus:', 'active:', 'disabled:',
  'first:', 'last:', 'odd:', 'even:',
  'sm:', 'md:', 'lg:', 'xl:', '2xl:',
];
```

### 6.2 自定义属性规范

```typescript
// tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      // 颜色系统
      colors: {
        primary: {
          50: '#eff6ff',
          100: '#dbeafe',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
          900: '#1e3a8a',
        },
        // 语义化颜色
        success: '#22c55e',
        warning: '#f59e0b',
        error: '#ef4444',
        info: '#3b82f6',
      },
      
      // 字体系统
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        mono: ['Fira Code', 'monospace'],
      },
      
      // 字体大小
      fontSize: {
        '2xs': ['0.625rem', { lineHeight: '0.875rem' }],
        '3xl': ['1.875rem', { lineHeight: '2.25rem', letterSpacing: '-0.02em' }],
      },
      
      // 间距系统
      spacing: {
        '4.5': '1.125rem',
        '18': '4.5rem',
      },
      
      // 圆角
      borderRadius: {
        '4xl': '2rem',
      },
      
      // 阴影
      boxShadow: {
        'card': '0 2px 8px rgba(0, 0, 0, 0.08)',
        'dropdown': '0 4px 16px rgba(0, 0, 0, 0.12)',
      },
      
      // 动画
      animation: {
        'fade-in': 'fadeIn 0.2s ease-out',
        'slide-up': 'slideUp 0.3s ease-out',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
      },
      
      // z-index 层级
      zIndex: {
        'dropdown': 1000,
        'sticky': 1020,
        'fixed': 1030,
        'modal-backdrop': 1040,
        'modal': 1050,
        'popover': 1060,
        'tooltip': 1070,
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
};
```

### 6.3 CSS 变量规范

```css
/* styles/variables.css */
@layer base {
  :root {
    /* 颜色系统 */
    --color-primary-50: 239 246 255;
    --color-primary-500: 59 130 246;
    --color-primary-600: 37 99 235;
    
    /* 语义化颜色 */
    --color-background: 255 255 255;
    --color-foreground: 15 23 42;
    --color-muted: 241 245 249;
    --color-border: 226 232 240;
    
    /* 间距 */
    --space-1: 0.25rem;
    --space-2: 0.5rem;
    --space-4: 1rem;
    --space-8: 2rem;
    
    /* 圆角 */
    --radius-sm: 0.25rem;
    --radius-md: 0.375rem;
    --radius-lg: 0.5rem;
    
    /* 阴影 */
    --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
    --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
    
    /* 过渡 */
    --transition-fast: 150ms ease;
    --transition-normal: 250ms ease;
    
    /* z-index */
    --z-dropdown: 1000;
    --z-modal: 1050;
  }

  .dark {
    --color-background: 15 23 42;
    --color-foreground: 248 250 252;
    --color-muted: 30 41 59;
    --color-border: 51 65 85;
  }
}
```

---

## 7. 性能规范

### 7.1 性能优化 15 条准则

```typescript
/**
 * ============================================
 * 性能优化 15 条准则
 * ============================================
 */

// 准则 1: 使用 React.memo 避免不必要的重渲染
const ExpensiveComponent = React.memo(function ExpensiveComponent({ 
  data 
}: { data: Data }) {
  // 昂贵的渲染逻辑
  return <div>{/* ... */}</div>;
}, (prevProps, nextProps) => {
  // 自定义比较函数
  return prevProps.data.id === nextProps.data.id;
});

// 准则 2: 使用 useMemo 缓存昂贵的计算
function DataProcessor({ items }: { items: Item[] }) {
  const processedItems = useMemo(() => {
    return items
      .filter(item => item.active)
      .sort((a, b) => b.priority - a.priority)
      .map(item => expensiveTransform(item));
  }, [items]);
  
  return <List items={processedItems} />;
}

// 准则 3: 使用 useCallback 缓存函数引用
function Parent() {
  const [count, setCount] = useState(0);
  
  const handleClick = useCallback(() => {
    setCount(c => c + 1);
  }, []);
  
  return <Child onClick={handleClick} />;
}

// 准则 4: 虚拟化长列表
import { FixedSizeList } from 'react-window';

function VirtualizedList({ items }: { items: Item[] }) {
  return (
    <FixedSizeList
      height={500}
      itemCount={items.length}
      itemSize={50}
      width="100%"
    >
      {({ index, style }) => (
        <div style={style}>{items[index].name}</div>
      )}
    </FixedSizeList>
  );
}

// 准则 5: 图片懒加载
function LazyImage({ src, alt }: { src: string; alt: string }) {
  return (
    <img
      src={src}
      alt={alt}
      loading="lazy"
      decoding="async"
    />
  );
}

// 准则 6: 代码分割和懒加载
const HeavyComponent = lazy(() => import('./HeavyComponent'));

function App() {
  return (
    <Suspense fallback={<Loading />}>
      <HeavyComponent />
    </Suspense>
  );
}

// 准则 7: 路由级别代码分割
const Dashboard = lazy(() => import('./pages/Dashboard'));
const Settings = lazy(() => import('./pages/Settings'));

function Router() {
  return (
    <Routes>
      <Route path="/dashboard" element={<Dashboard />} />
      <Route path="/settings" element={<Settings />} />
    </Routes>
  );
}

// 准则 8: 使用 will-change 优化动画
// CSS
// .animate-element {
//   will-change: transform, opacity;
// }

// 准则 9: 避免内联函数和对象
// ❌ 错误
function BadComponent() {
  return <Child style={{ color: 'red' }} onClick={() => {}} />;
}

// ✅ 正确
const staticStyle = { color: 'red' };
function GoodComponent() {
  const handleClick = useCallback(() => {}, []);
  return <Child style={staticStyle} onClick={handleClick} />;
}

// 准则 10: 使用 CSS 动画代替 JS 动画
// ✅ 使用 CSS transform 和 opacity
// .animate {
//   transition: transform 0.3s ease;
//   transform: translateX(0);
// }
// .animate.active {
//   transform: translateX(100px);
// }

// 准则 11: 防抖和节流
import { debounce, throttle } from 'lodash-es';

function SearchInput() {
  const debouncedSearch = useMemo(
    () => debounce((query: string) => {
      searchAPI(query);
    }, 300),
    []
  );
  
  return (
    <input
      onChange={(e) => debouncedSearch(e.target.value)}
    />
  );
}

// 准则 12: 使用 Web Workers 处理复杂计算
// worker.ts
self.onmessage = (e) => {
  const result = heavyCalculation(e.data);
  self.postMessage(result);
};

// 组件中使用
function Component() {
  useEffect(() => {
    const worker = new Worker('./worker.ts');
    worker.postMessage(largeData);
    worker.onmessage = (e) => {
      setResult(e.data);
    };
    return () => worker.terminate();
  }, []);
}

// 准则 13: 预加载关键资源
// index.html
// <link rel="preload" href="/fonts/main.woff2" as="font" type="font/woff2" crossorigin>
// <link rel="prefetch" href="/about" />

// 准则 14: 使用 Service Worker 缓存
// service-worker.ts
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {
      return response || fetch(event.request);
    })
  );
});

// 准则 15: 监控性能指标
function PerformanceMonitor() {
  useEffect(() => {
    // Core Web Vitals
    new PerformanceObserver((list) => {
      for (const entry of list.getEntries()) {
        console.log('LCP:', entry.startTime);
      }
    }).observe({ entryTypes: ['largest-contentful-paint'] });
    
    // 自定义性能标记
    performance.mark('app-start');
    performance.measure('app-load', 'app-start');
  }, []);
  
  return null;
}
```

### 7.2 性能检查清单

| 检查项 | 工具 | 目标值 |
|--------|------|--------|
| First Contentful Paint (FCP) | Lighthouse | < 1.8s |
| Largest Contentful Paint (LCP) | Lighthouse | < 2.5s |
| Time to Interactive (TTI) | Lighthouse | < 3.8s |
| Total Blocking Time (TBT) | Lighthouse | < 200ms |
| Cumulative Layout Shift (CLS) | Lighthouse | < 0.1 |
| Bundle Size | webpack-bundle-analyzer | < 200KB (初始) |
| 图片大小 | - | < 100KB |
| API 响应时间 | DevTools | < 300ms |

---

## 8. 测试规范

### 8.1 测试完整要求

```typescript
/**
 * ============================================
 * 测试规范完整要求
 * ============================================
 */

// 1. 单元测试 - 组件测试
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Button } from './Button';

describe('Button', () => {
  // 渲染测试
  it('renders correctly', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button')).toBeInTheDocument();
  });
  
  // 属性测试
  it('renders with different variants', () => {
    const { rerender } = render(<Button variant="primary">Primary</Button>);
    expect(screen.getByRole('button')).toHaveClass('btn-primary');
    
    rerender(<Button variant="secondary">Secondary</Button>);
    expect(screen.getByRole('button')).toHaveClass('btn-secondary');
  });
  
  // 交互测试
  it('handles click events', async () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click</Button>);
    
    await userEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
  
  // 无障碍测试
  it('is accessible', () => {
    render(<Button disabled>Disabled</Button>);
    expect(screen.getByRole('button')).toBeDisabled();
  });
  
  // 快照测试
  it('matches snapshot', () => {
    const { container } = render(<Button>Snapshot</Button>);
    expect(container).toMatchSnapshot();
  });
});

// 2. Hook 测试
import { renderHook, act } from '@testing-library/react';
import { useCounter } from './useCounter';

describe('useCounter', () => {
  it('initializes with default value', () => {
    const { result } = renderHook(() => useCounter());
    expect(result.current.count).toBe(0);
  });
  
  it('increments count', () => {
    const { result } = renderHook(() => useCounter(10));
    
    act(() => {
      result.current.increment();
    });
    
    expect(result.current.count).toBe(11);
  });
});

// 3. 集成测试
import { renderWithProviders } from '@/tests/utils';
import { UserProfile } from './UserProfile';

describe('UserProfile Integration', () => {
  it('fetches and displays user data', async () => {
    // Mock API
    server.use(
      http.get('/api/user/1', () => {
        return HttpResponse.json({ id: '1', name: 'John' });
      })
    );
    
    renderWithProviders(<UserProfile userId="1" />);
    
    expect(screen.getByText(/loading/i)).toBeInTheDocument();
    
    await waitFor(() => {
      expect(screen.getByText('John')).toBeInTheDocument();
    });
  });
});

// 4. E2E 测试
// tests/e2e/login.spec.ts
import { test, expect } from '@playwright/test';

test('user can login', async ({ page }) => {
  await page.goto('/login');
  
  await page.fill('[data-testid="email-input"]', 'user@example.com');
  await page.fill('[data-testid="password-input"]', 'password');
  await page.click('[data-testid="login-button"]');
  
  await expect(page).toHaveURL('/dashboard');
  await expect(page.locator('text=Welcome')).toBeVisible();
});
```

### 8.2 测试覆盖率要求

| 类型 | 目标覆盖率 | 最低覆盖率 |
|------|-----------|-----------|
| 语句 (Statements) | 90% | 80% |
| 分支 (Branches) | 85% | 75% |
| 函数 (Functions) | 90% | 80% |
| 行 (Lines) | 90% | 80% |

### 8.3 测试文件组织

```
src/
├── components/
│   └── Button/
│       ├── Button.tsx
│       ├── Button.test.tsx        # 同目录测试文件
│       └── Button.stories.tsx     # Storybook 文档
├── hooks/
│   ├── useAuth.ts
│   └── useAuth.test.ts
└── utils/
    ├── formatters.ts
    └── formatters.test.ts

tests/
├── unit/                          # 单元测试
│   └── setup.ts
├── integration/                   # 集成测试
│   └── api.test.ts
├── e2e/                           # E2E 测试
│   └── auth.spec.ts
└── fixtures/                      # 测试数据
    └── users.ts
```

### 8.4 测试最佳实践

```typescript
/**
 * 测试最佳实践
 */

// 1. 使用 data-testid 作为稳定的测试选择器
<button data-testid="submit-button">提交</button>

// 2. 优先使用用户视角的查询
// ✅ 正确
screen.getByRole('button', { name: /submit/i });
screen.getByLabelText(/email/i);
screen.getByPlaceholderText(/enter email/i);

// ❌ 避免
screen.getByTestId('submit-button');  // 仅在必要时使用

// 3. 使用 userEvent 代替 fireEvent
// ✅ 正确
await userEvent.click(button);
await userEvent.type(input, 'text');

// ❌ 避免
fireEvent.click(button);
fireEvent.change(input, { target: { value: 'text' } });

// 4. 测试工具函数
// tests/utils.tsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { render } from '@testing-library/react';

export function renderWithProviders(
  ui: React.ReactElement,
  options = {}
) {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: { retry: false },
    },
  });
  
  return render(
    <QueryClientProvider client={queryClient}>
      {ui}
    </QueryClientProvider>,
    options
  );
}
```

---

## 9. 安全规范

### 9.1 安全规范检查清单

```typescript
/**
 * ============================================
 * 安全规范检查清单
 * ============================================
 */

// ✅ XSS 防护

// 1. 不要直接使用 dangerouslySetInnerHTML
// ❌ 危险
<div dangerouslySetInnerHTML={{ __html: userInput }} />

// ✅ 安全 - 使用 DOMPurify 净化
import DOMPurify from 'dompurify';

function SafeHTML({ html }: { html: string }) {
  const clean = DOMPurify.sanitize(html);
  return <div dangerouslySetInnerHTML={{ __html: clean }} />;
}

// 2. 用户输入转义
function escapeHtml(unsafe: string): string {
  return unsafe
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}

// 3. URL 验证
function isValidUrl(url: string): boolean {
  try {
    const parsed = new URL(url);
    return ['http:', 'https:'].includes(parsed.protocol);
  } catch {
    return false;
  }
}

// ✅ CSRF 防护

// 1. 使用 SameSite Cookie
// Set-Cookie: session=xxx; SameSite=Strict; Secure; HttpOnly

// 2. 添加 CSRF Token
async function fetchWithCSRF(url: string, options: RequestInit = {}) {
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
  
  return fetch(url, {
    ...options,
    headers: {
      ...options.headers,
      'X-CSRF-Token': csrfToken || '',
    },
  });
}

// ✅ 敏感信息处理

// 1. 环境变量使用
// .env
// VITE_API_URL=https://api.example.com  // 公开变量
// API_SECRET_KEY=xxx                    // 服务器端变量，不要以 VITE_ 开头

// 2. 不要在代码中硬编码密钥
// ❌ 错误
const API_KEY = 'sk-1234567890abcdef';

// ✅ 正确
const API_KEY = import.meta.env.VITE_API_KEY;

// 3. 日志脱敏
function sanitizeLog(data: unknown): unknown {
  if (typeof data === 'object' && data !== null) {
    const sensitiveKeys = ['password', 'token', 'secret', 'creditCard'];
    return Object.entries(data).reduce((acc, [key, value]) => {
      acc[key] = sensitiveKeys.some(sk => key.toLowerCase().includes(sk))
        ? '***'
        : sanitizeLog(value);
      return acc;
    }, {} as Record<string, unknown>);
  }
  return data;
}

// ✅ 依赖安全

// 1. 定期审计依赖
// npm audit
// yarn audit

// 2. 使用 lock 文件
// package-lock.json
// yarn.lock
// pnpm-lock.yaml

// 3. 限制依赖来源
// .npmrc
// registry=https://registry.npmjs.org/

// ✅ 内容安全策略 (CSP)

// index.html
// <meta http-equiv="Content-Security-Policy" 
//   content="
//     default-src 'self';
//     script-src 'self' 'unsafe-inline';
//     style-src 'self' 'unsafe-inline';
//     img-src 'self' data: https:;
//     connect-src 'self' https://api.example.com;
//   ">

// ✅ HTTPS 强制

// 1. 所有 API 请求使用 HTTPS
const API_BASE_URL = 'https://api.example.com';

// 2. HSTS 头
// Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```

### 9.2 安全检查清单

| 检查项 | 状态 | 说明 |
|--------|------|------|
| [ ] 输入验证 | 必须 | 所有用户输入都经过验证 |
| [ ] XSS 防护 | 必须 | 使用 DOMPurify 净化 HTML |
| [ ] CSRF Token | 必须 | 敏感操作使用 CSRF Token |
| [ ] HTTPS 强制 | 必须 | 全站 HTTPS |
| [ ] CSP 配置 | 推荐 | 配置内容安全策略 |
| [ ] 依赖审计 | 必须 | 定期运行 npm audit |
| [ ] 密钥管理 | 必须 | 密钥存储在环境变量 |
| [ ] 日志脱敏 | 必须 | 敏感信息不出现在日志 |
| [ ] CORS 配置 | 必须 | 正确配置跨域策略 |
| [ ] 会话安全 | 必须 | HttpOnly, Secure, SameSite |

---

## 10. 强制规则清单

### 10.1 强制规则（15+ 条）

```typescript
/**
 * ============================================
 * 强制规则清单
 * ============================================
 * 以下规则必须通过 ESLint/TypeScript 强制执行
 */

// 规则 1: 禁止使用 any
// ❌ 错误
type BadType = any;
const badVar: any = {};

// ✅ 正确
interface GoodType { /* ... */ }
const goodVar: unknown = {};

// ESLint: @typescript-eslint/no-explicit-any

// 规则 2: 函数行数限制
// 单个函数不超过 50 行
// 单个文件不超过 300 行

// ESLint: max-lines-per-function: ["error", 50]
// ESLint: max-lines: ["error", 300]

// 规则 3: 圈复杂度限制
// 函数圈复杂度不超过 10

// ESLint: complexity: ["error", 10]

// 规则 4: 禁止使用 console
// 生产代码中禁止 console.log

// ESLint: no-console: ["warn", { allow: ["error", "warn"] }]

// 规则 5: 必须使用严格相等
// ❌ 错误
if (a == b) {}
if (a != null) {}

// ✅ 正确
if (a === b) {}
if (a !== null) {}

// ESLint: eqeqeq: ["error", "always"]

// 规则 6: 必须使用分号
// ESLint: semi: ["error", "always"]

// 规则 7: 必须使用单引号
// ESLint: quotes: ["error", "single"]

// 规则 8: 缩进使用 2 个空格
// ESLint: indent: ["error", 2]

// 规则 9: 最大行长度 100
// ESLint: max-len: ["error", { code: 100 }]

// 规则 10: 必须使用 const/let，禁止使用 var
// ESLint: no-var: "error"

// 规则 11: 未使用的变量必须删除
// ESLint: @typescript-eslint/no-unused-vars: "error"

// 规则 12: 必须处理 Promise 错误
// ❌ 错误
fetchData();  // 未处理

// ✅ 正确
fetchData().catch(handleError);
await fetchData();  // 在 try-catch 中

// ESLint: @typescript-eslint/no-floating-promises: "error"

// 规则 13: 禁止使用 @ts-ignore
// ✅ 使用 @ts-expect-error 并提供说明
// @ts-expect-error: 第三方库类型定义不完整
const result = library.method();

// ESLint: @typescript-eslint/ban-ts-comment: "error"

// 规则 14: 必须显式声明函数返回类型
// ❌ 错误
function badFunction() {
  return 'string';
}

// ✅ 正确
function goodFunction(): string {
  return 'string';
}

// ESLint: @typescript-eslint/explicit-function-return-type: "error"

// 规则 15: 组件必须定义 displayName
const Component = forwardRef((props, ref) => {
  return <div />;
});
Component.displayName = 'Component';

// ESLint: react/display-name: "error"

// 规则 16: 禁止使用数组索引作为 key
// ❌ 错误
{items.map((item, index) => <div key={index} />)}

// ✅ 正确
{items.map((item) => <div key={item.id} />)}

// ESLint: react/no-array-index-key: "error"

// 规则 17: Hooks 规则
// - 只在函数组件或自定义 Hook 中调用
// - 只在最顶层调用
// ESLint: react-hooks/rules-of-hooks: "error"
// ESLint: react-hooks/exhaustive-deps: "error"

// 规则 18: 必须使用类型导入
// ❌ 错误
import { SomeType } from './types';

// ✅ 正确
import type { SomeType } from './types';

// ESLint: @typescript-eslint/consistent-type-imports: "error"

// 规则 19: 禁止使用魔术数字
// ❌ 错误
if (status === 404) {}

// ✅ 正确
const HTTP_NOT_FOUND = 404;
if (status === HTTP_NOT_FOUND) {}

// ESLint: no-magic-numbers: ["error", { ignore: [0, 1] }]

// 规则 20: 文件命名规范
// 组件: PascalCase.tsx
// 工具: camelCase.ts
// 常量: UPPER_SNAKE_CASE.ts
// ESLint: 配合文件名检查规则
```

### 10.2 ESLint 配置示例

```javascript
// .eslintrc.js
module.exports = {
  root: true,
  env: { browser: true, es2020: true },
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:react-hooks/recommended',
    'plugin:react/recommended',
    'plugin:jsx-a11y/recommended',
  ],
  ignorePatterns: ['dist', '.eslintrc.cjs'],
  parser: '@typescript-eslint/parser',
  plugins: ['react-refresh', '@typescript-eslint', 'import'],
  rules: {
    // TypeScript 规则
    '@typescript-eslint/no-explicit-any': 'error',
    '@typescript-eslint/no-unused-vars': 'error',
    '@typescript-eslint/explicit-function-return-type': 'error',
    '@typescript-eslint/consistent-type-imports': 'error',
    '@typescript-eslint/no-floating-promises': 'error',
    '@typescript-eslint/ban-ts-comment': 'error',
    
    // React 规则
    'react-hooks/rules-of-hooks': 'error',
    'react-hooks/exhaustive-deps': 'error',
    'react/display-name': 'error',
    'react/no-array-index-key': 'error',
    'react-refresh/only-export-components': 'warn',
    
    // 通用规则
    'no-console': ['warn', { allow: ['error', 'warn'] }],
    'no-var': 'error',
    'eqeqeq': ['error', 'always'],
    'semi': ['error', 'always'],
    'quotes': ['error', 'single'],
    'indent': ['error', 2],
    'max-len': ['error', { code: 100 }],
    'max-lines': ['error', 300],
    'max-lines-per-function': ['error', 50],
    'complexity': ['error', 10],
    'no-magic-numbers': ['error', { ignore: [0, 1, -1] }],
    
    // Import 规则
    'import/order': ['error', {
      groups: [
        'builtin',
        'external',
        'internal',
        'parent',
        'sibling',
        'index',
      ],
      'newlines-between': 'always',
    }],
  },
  settings: {
    react: {
      version: 'detect',
    },
  },
};
```

### 10.3 Prettier 配置示例

```javascript
// .prettierrc
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 100,
  "bracketSpacing": true,
  "arrowParens": "always",
  "endOfLine": "lf",
  "plugins": ["prettier-plugin-tailwindcss"]
}
```

### 10.4 TypeScript 配置示例

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@components/*": ["./src/components/*"],
      "@hooks/*": ["./src/hooks/*"],
      "@utils/*": ["./src/utils/*"],
      "@types/*": ["./src/types/*"]
    }
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
```

---

## 附录

### A. 代码审查清单

在提交代码前，请确认以下检查项：

- [ ] 代码通过 ESLint 检查（无错误）
- [ ] 代码通过 TypeScript 编译（无错误）
- [ ] 所有测试通过
- [ ] 测试覆盖率达标
- [ ] 代码审查已完成
- [ ] 文档已更新（如需要）
- [ ] 变更日志已更新（如需要）

### B. 提交信息规范

```
<type>(<scope>): <subject>

<body>

<footer>
```

类型（type）：
- `feat`: 新功能
- `fix`: 修复
- `docs`: 文档
- `style`: 格式（不影响代码运行的变动）
- `refactor`: 重构
- `perf`: 性能优化
- `test`: 测试
- `chore`: 构建过程或辅助工具的变动

示例：
```
feat(auth): add OAuth2 login support

- Implement Google OAuth2 flow
- Add token refresh mechanism
- Update user profile sync

Closes #123
```

### C. 版本号规范（SemVer）

格式：`MAJOR.MINOR.PATCH`

- `MAJOR`: 不兼容的 API 修改
- `MINOR`: 向下兼容的功能新增
- `PATCH`: 向下兼容的问题修复

---

*文档版本: 1.0.0*
*最后更新: 2024-01-15*
