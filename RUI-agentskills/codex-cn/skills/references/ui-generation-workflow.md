# UI 生成工作流：四步生成法

---

## 文档信息

| 属性 | 值 |
|------|-----|
| 版本 | 1.0.0 |
| 作者 | Claude Code |
| 创建日期 | 2024 |
| 适用范围 | AI Agent UI 生成任务 |

---

## 目录

1. [概述](#概述)
2. [四步生成法详解](#四步生成法详解)
3. [输入/输出规范](#输入输出规范)
4. [与 Design Tokens 的结合](#与-design-tokens-的结合)
5. [常见模式](#常见模式)
6. [反模式](#反模式)
7. [完整示例](#完整示例)
8. [最佳实践](#最佳实践)

---

## 概述

### 什么是四步生成法

四步生成法是一种系统化的 UI 组件生成方法论，将复杂的 UI 创建过程分解为四个有序阶段：

```
┌─────────────────────────────────────────────────────────────────┐
│                      四步生成法流程图                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│   │  1. 结构规划  │───▶│  2. 视觉实现  │───▶│  3. 交互完善  │      │
│   │  Structure   │    │   Visual     │    │ Interaction  │      │
│   └──────────────┘    └──────────────┘    └──────────────┘      │
│          │                   │                   │               │
│          └───────────────────┴───────────────────┘               │
│                              │                                   │
│                              ▼                                   │
│                    ┌──────────────┐                              │
│                    │  4. 优化重构  │                              │
│                    │ Optimization │                              │
│                    └──────────────┘                              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 设计原则

| 原则 | 说明 |
|------|------|
| **单一职责** | 每个步骤只关注一个层面的问题 |
| **渐进增强** | 从基础到复杂，逐步完善 |
| **可回溯性** | 每个步骤的输出可作为调试依据 |
| **可验证性** | 每个步骤都有明确的验收标准 |

---

## 四步生成法详解

### 第一步：结构规划 (Structure Planning)

#### 目标
确定组件的 DOM 结构、组件树层级和状态设计。

#### 核心任务

1. **组件树设计**
   - 确定组件的父子关系
   - 划分容器组件和展示组件
   - 定义组件接口（Props）

2. **状态设计**
   - 识别状态类型（本地状态/全局状态）
   - 设计状态数据结构
   - 规划状态流转路径

3. **数据流规划**
   - 确定数据流向（单向/双向）
   - 设计事件传递机制

#### 输出规范

```json
{
  "step": "structure_planning",
  "version": "1.0.0",
  "component_tree": {
    "root": {
      "name": "ComponentName",
      "type": "container|presentational",
      "props": ["prop1", "prop2"],
      "children": [
        {
          "name": "ChildComponent",
          "type": "presentational",
          "props": ["childProp"]
        }
      ]
    }
  },
  "state_design": {
    "local_states": [
      {
        "name": "isOpen",
        "type": "boolean",
        "initial_value": false,
        "description": "控制弹窗显示状态"
      }
    ],
    "global_states": [],
    "derived_states": [
      {
        "name": "displayText",
        "dependencies": ["rawText", "maxLength"],
        "computation": "rawText.slice(0, maxLength)"
      }
    ]
  },
  "data_flow": {
    "direction": "unidirectional",
    "events": ["onClick", "onChange", "onSubmit"]
  }
}
```

#### 示例

```typescript
// 结构规划阶段的伪代码输出
interface ComponentStructure {
  // 组件树
  tree: {
    Modal: {
      children: ['ModalHeader', 'ModalBody', 'ModalFooter']
    }
  };
  
  // 状态定义
  states: {
    isVisible: boolean;      // 控制显示
    content: string;         // 内容数据
    isLoading: boolean;      // 加载状态
  };
  
  // Props 接口
  props: {
    title: string;
    onClose: () => void;
    onConfirm: () => Promise<void>;
  };
}
```

---

### 第二步：视觉实现 (Visual Implementation)

#### 目标
实现组件的视觉呈现，包括布局、样式和响应式设计。

#### 核心任务

1. **布局实现**
   - 选择布局方案（Flexbox/Grid/绝对定位）
   - 确定元素尺寸和间距
   - 处理对齐和分布

2. **样式应用**
   - 应用 Design Tokens
   - 实现主题适配
   - 处理视觉层次

3. **响应式设计**
   - 定义断点策略
   - 实现移动端适配
   - 处理不同屏幕尺寸

#### 输出规范

```json
{
  "step": "visual_implementation",
  "version": "1.0.0",
  "layout": {
    "strategy": "flexbox|grid|absolute",
    "structure": {
      "display": "flex",
      "flexDirection": "column",
      "gap": "16px",
      "padding": "24px"
    }
  },
  "styles": {
    "applied_tokens": [
      {
        "property": "backgroundColor",
        "token": "colors.background.primary",
        "value": "#ffffff"
      },
      {
        "property": "borderRadius",
        "token": "radii.medium",
        "value": "8px"
      }
    ],
    "custom_styles": {
      "boxShadow": "0 4px 12px rgba(0,0,0,0.1)"
    }
  },
  "responsive": {
    "breakpoints": {
      "mobile": "< 768px",
      "tablet": "768px - 1024px",
      "desktop": "> 1024px"
    },
    "adaptations": {
      "mobile": {
        "padding": "16px",
        "fontSize": "14px"
      }
    }
  }
}
```

#### 示例

```tsx
// 视觉实现阶段的代码输出
const VisualComponent = () => {
  return (
    <div 
      className="modal-container"
      style={{
        // 布局
        display: 'flex',
        flexDirection: 'column',
        gap: 'var(--spacing-md)',
        padding: 'var(--spacing-lg)',
        
        // 视觉样式
        backgroundColor: 'var(--color-bg-primary)',
        borderRadius: 'var(--radius-md)',
        boxShadow: 'var(--shadow-lg)',
        
        // 尺寸
        maxWidth: '500px',
        minHeight: '200px'
      }}
    >
      {/* 子组件 */}
    </div>
  );
};
```

---

### 第三步：交互完善 (Interaction Enhancement)

#### 目标
实现组件的交互功能，包括事件处理、状态管理和用户反馈。

#### 核心任务

1. **事件处理**
   - 绑定事件处理器
   - 实现事件委托
   - 处理事件冒泡

2. **状态管理**
   - 实现状态更新逻辑
   - 处理异步操作
   - 管理副作用

3. **用户反馈**
   - 实现加载状态
   - 添加动画效果
   - 处理错误提示

#### 输出规范

```json
{
  "step": "interaction_enhancement",
  "version": "1.0.0",
  "events": {
    "handlers": [
      {
        "event": "onClick",
        "target": "confirmButton",
        "handler": "handleConfirm",
        "debounce": 300,
        "preventDefault": true
      }
    ]
  },
  "state_management": {
    "transitions": [
      {
        "from": "idle",
        "to": "loading",
        "trigger": "SUBMIT_START"
      },
      {
        "from": "loading",
        "to": "success",
        "trigger": "SUBMIT_SUCCESS"
      },
      {
        "from": "loading",
        "to": "error",
        "trigger": "SUBMIT_ERROR"
      }
    ]
  },
  "feedback": {
    "loading": {
      "indicator": "spinner",
      "text": "处理中...",
      "disableInteraction": true
    },
    "success": {
      "animation": "fadeIn",
      "duration": 300,
      "message": "操作成功"
    },
    "error": {
      "animation": "shake",
      "duration": 500,
      "message": "操作失败，请重试"
    }
  }
}
```

#### 示例

```tsx
// 交互完善阶段的代码输出
const InteractiveComponent = () => {
  const [state, setState] = useState<'idle' | 'loading' | 'success' | 'error'>('idle');
  
  const handleConfirm = async () => {
    setState('loading');
    
    try {
      await onConfirm();
      setState('success');
      
      // 成功反馈
      toast.success('操作成功');
      
      // 延迟关闭
      setTimeout(() => {
        onClose();
      }, 1500);
      
    } catch (error) {
      setState('error');
      toast.error('操作失败，请重试');
    }
  };
  
  return (
    <div className={`modal state-${state}`}>
      {state === 'loading' && <LoadingSpinner />}
      <button 
        onClick={handleConfirm}
        disabled={state === 'loading'}
      >
        确认
      </button>
    </div>
  );
};
```

---

### 第四步：优化重构 (Optimization & Refactoring)

#### 目标
优化组件性能，提升代码可维护性。

#### 核心任务

1. **性能优化**
   - 实现 memoization
   - 优化重渲染
   - 延迟加载

2. **代码重构**
   - 提取可复用逻辑
   - 简化复杂组件
   - 提升可读性

3. **可访问性**
   - 添加 ARIA 属性
   - 支持键盘导航
   - 适配屏幕阅读器

#### 输出规范

```json
{
  "step": "optimization_refactoring",
  "version": "1.0.0",
  "performance": {
    "optimizations": [
      {
        "type": "memoization",
        "target": "expensiveComputation",
        "implementation": "useMemo"
      },
      {
        "type": "callback_memoization",
        "target": "eventHandlers",
        "implementation": "useCallback"
      },
      {
        "type": "component_memoization",
        "target": "ListItem",
        "implementation": "React.memo"
      }
    ],
    "metrics": {
      "before": {
        "render_time": "120ms",
        "bundle_size": "15KB"
      },
      "after": {
        "render_time": "45ms",
        "bundle_size": "12KB"
      }
    }
  },
  "refactoring": {
    "extracted_hooks": ["useModalState", "useAnimation"],
    "extracted_components": ["ModalHeader", "ModalFooter"],
    "code_quality": {
      "complexity_score": "A",
      "test_coverage": "85%"
    }
  },
  "accessibility": {
    "aria_attributes": {
      "role": "dialog",
      "aria-modal": "true",
      "aria-labelledby": "modal-title"
    },
    "keyboard_support": ["Escape", "Tab", "Enter"],
    "screen_reader": "fully_supported"
  }
}
```

#### 示例

```tsx
// 优化重构阶段的代码输出

// 1. 提取自定义 Hook
const useModalState = (initialOpen = false) => {
  const [isOpen, setIsOpen] = useState(initialOpen);
  
  const open = useCallback(() => setIsOpen(true), []);
  const close = useCallback(() => setIsOpen(false), []);
  const toggle = useCallback(() => setIsOpen(prev => !prev), []);
  
  return { isOpen, open, close, toggle };
};

// 2. 使用 React.memo 优化子组件
const ModalHeader = React.memo(({ title, onClose }: ModalHeaderProps) => {
  return (
    <header className="modal-header">
      <h2 id="modal-title">{title}</h2>
      <button 
        onClick={onClose}
        aria-label="关闭"
      >
        ×
      </button>
    </header>
  );
});

// 3. 优化后的主组件
const OptimizedModal = React.memo((props: ModalProps) => {
  const { isOpen, close } = useModalState(props.defaultOpen);
  
  // 使用 useMemo 缓存计算结果
  const modalClasses = useMemo(() => {
    return classNames('modal', {
      'modal--open': isOpen,
      'modal--animated': props.animated
    });
  }, [isOpen, props.animated]);
  
  // 键盘事件处理
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && isOpen) {
        close();
      }
    };
    
    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [isOpen, close]);
  
  if (!isOpen) return null;
  
  return (
    <div 
      className={modalClasses}
      role="dialog"
      aria-modal="true"
      aria-labelledby="modal-title"
    >
      <ModalHeader title={props.title} onClose={close} />
      {/* ... */}
    </div>
  );
});
```

---

## 输入/输出规范

### 完整输入规范

```json
{
  "ui_generation_request": {
    "version": "1.0.0",
    "request_id": "uuid-string",
    "timestamp": "2024-01-01T00:00:00Z",
    
    "requirements": {
      "component_type": "modal|form|list|card|navigation",
      "purpose": "组件用途描述",
      "target_platform": "web|mobile|desktop",
      "framework": "react|vue|angular|svelte"
    },
    
    "design_specifications": {
      "design_tokens_source": "path/to/tokens.json",
      "style_guide": "material|ant|custom",
      "theme": "light|dark|auto",
      "responsive_required": true
    },
    
    "functional_requirements": {
      "interactions": ["click", "hover", "drag", "swipe"],
      "animations": ["fade", "slide", "scale"],
      "accessibility_level": "A|AA|AAA"
    },
    
    "constraints": {
      "max_bundle_size": "20KB",
      "browser_support": ["chrome>=80", "firefox>=75", "safari>=13"],
      "performance_budget": {
        "first_paint": "1s",
        "time_to_interactive": "3s"
      }
    }
  }
}
```

### 完整输出规范

```json
{
  "ui_generation_result": {
    "version": "1.0.0",
    "request_id": "uuid-string",
    "timestamp": "2024-01-01T00:00:00Z",
    
    "steps_completed": ["structure", "visual", "interaction", "optimization"],
    
    "outputs": {
      "structure_planning": {
        "status": "completed",
        "output": { /* 结构规划输出 */ }
      },
      "visual_implementation": {
        "status": "completed",
        "output": { /* 视觉实现输出 */ }
      },
      "interaction_enhancement": {
        "status": "completed",
        "output": { /* 交互完善输出 */ }
      },
      "optimization_refactoring": {
        "status": "completed",
        "output": { /* 优化重构输出 */ }
      }
    },
    
    "deliverables": {
      "source_code": "path/to/component.tsx",
      "styles": "path/to/styles.css",
      "tests": "path/to/component.test.tsx",
      "documentation": "path/to/README.md"
    },
    
    "quality_metrics": {
      "performance_score": 95,
      "accessibility_score": 100,
      "test_coverage": 85,
      "bundle_size": "12KB"
    }
  }
}
```

---

## 与 Design Tokens 的结合

### Design Tokens 集成架构

```
┌─────────────────────────────────────────────────────────────────┐
│                    Design Tokens 集成架构                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐       │
│  │   Tokens    │────▶│  Pipeline   │────▶│   Platform  │       │
│  │   Source    │     │  Transform  │     │   Formats   │       │
│  └─────────────┘     └─────────────┘     └─────────────┘       │
│         │                   │                   │                │
│         ▼                   ▼                   ▼                │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐       │
│  │  colors.json│     │  Style Dict │     │  CSS Vars   │       │
│  │  spacing.yml│     │  Transform  │     │  JS Objects │       │
│  │  fonts.json │     │  Custom     │     │  SCSS Vars  │       │
│  └─────────────┘     └─────────────┘     └─────────────┘       │
│                                                                  │
│                              │                                   │
│                              ▼                                   │
│                    ┌─────────────────┐                          │
│                    │  UI Components  │                          │
│                    │  (Four Steps)   │                          │
│                    └─────────────────┘                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Tokens 在各步骤中的应用

#### 第一步：结构规划

```json
{
  "token_usage": {
    "spacing_scale": {
      "source": "tokens.spacing",
      "usage": "确定组件间距层级"
    },
    "size_scale": {
      "source": "tokens.sizing",
      "usage": "确定组件尺寸规范"
    }
  }
}
```

#### 第二步：视觉实现

```typescript
// 使用 CSS 变量引用 Tokens
const styles = {
  // 颜色
  backgroundColor: 'var(--color-background-primary)',
  textColor: 'var(--color-text-primary)',
  borderColor: 'var(--color-border-default)',
  
  // 间距
  padding: 'var(--spacing-md)',
  margin: 'var(--spacing-sm)',
  gap: 'var(--spacing-xs)',
  
  // 字体
  fontSize: 'var(--font-size-base)',
  fontWeight: 'var(--font-weight-medium)',
  lineHeight: 'var(--line-height-normal)',
  
  // 圆角
  borderRadius: 'var(--radius-md)',
  
  // 阴影
  boxShadow: 'var(--shadow-md)',
  
  // 过渡
  transition: 'var(--transition-fast)'
};
```

#### 第三步：交互完善

```typescript
// 使用 Tokens 定义动画
const animations = {
  // 时长
  duration: {
    fast: 'var(--duration-fast)',     // 150ms
    normal: 'var(--duration-normal)', // 300ms
    slow: 'var(--duration-slow)'      // 500ms
  },
  
  // 缓动函数
  easing: {
    easeIn: 'var(--ease-in)',
    easeOut: 'var(--ease-out)',
    easeInOut: 'var(--ease-in-out)',
    bounce: 'var(--ease-bounce)'
  }
};
```

#### 第四步：优化重构

```typescript
// 使用 Tokens 实现主题切换
const useTheme = () => {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');
  
  useEffect(() => {
    // 应用主题 CSS 变量
    const root = document.documentElement;
    const tokens = theme === 'light' ? lightTokens : darkTokens;
    
    Object.entries(tokens).forEach(([key, value]) => {
      root.style.setProperty(`--${key}`, value);
    });
  }, [theme]);
  
  return { theme, setTheme };
};
```

### Tokens 映射表

| Token 类别 | 变量名示例 | 应用场景 |
|-----------|-----------|---------|
| **Colors** | `--color-primary-500` | 主色调、按钮背景 |
| **Spacing** | `--spacing-md` | 组件内边距、外边距 |
| **Typography** | `--font-size-lg` | 标题、正文文字大小 |
| **Border Radius** | `--radius-sm` | 卡片、按钮圆角 |
| **Shadows** | `--shadow-lg` | 弹窗、下拉菜单阴影 |
| **Transitions** | `--duration-normal` | 悬停、展开动画时长 |
| **Z-Index** | `--z-index-modal` | 层级管理 |

---

## 常见模式

### 模式 1: 容器-展示分离模式

```typescript
// ✅ 正确：分离容器和展示组件

// Container Component - 处理逻辑
const UserListContainer = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);
  
  useEffect(() => {
    fetchUsers().then(setUsers);
  }, []);
  
  return <UserListView users={users} loading={loading} />;
};

// Presentational Component - 纯展示
interface UserListViewProps {
  users: User[];
  loading: boolean;
}

const UserListView = ({ users, loading }: UserListViewProps) => {
  if (loading) return <LoadingSpinner />;
  
  return (
    <ul className="user-list">
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
};
```

### 模式 2: 复合组件模式

```typescript
// ✅ 正确：使用复合组件提供灵活组合

const Modal = {
  Root: ModalRoot,
  Header: ModalHeader,
  Body: ModalBody,
  Footer: ModalFooter,
  CloseButton: ModalCloseButton
};

// 使用示例
<Modal.Root isOpen={isOpen} onClose={onClose}>
  <Modal.Header>
    <h2>标题</h2>
    <Modal.CloseButton />
  </Modal.Header>
  <Modal.Body>
    <p>内容</p>
  </Modal.Body>
  <Modal.Footer>
    <button>确认</button>
  </Modal.Footer>
</Modal.Root>
```

### 模式 3: 受控/非受控双模式

```typescript
// ✅ 正确：同时支持受控和非受控

interface InputProps {
  // 受控模式
  value?: string;
  onChange?: (value: string) => void;
  
  // 非受控模式
  defaultValue?: string;
}

const Input = ({ value, onChange, defaultValue }: InputProps) => {
  // 判断模式
  const isControlled = value !== undefined;
  
  // 非受控模式下使用内部状态
  const [internalValue, setInternalValue] = useState(defaultValue || '');
  
  const currentValue = isControlled ? value : internalValue;
  
  const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value;
    
    if (!isControlled) {
      setInternalValue(newValue);
    }
    
    onChange?.(newValue);
  };
  
  return <input value={currentValue} onChange={handleChange} />;
};
```

### 模式 4: Render Props 模式

```typescript
// ✅ 正确：使用 Render Props 提供自定义能力

interface ListProps<T> {
  items: T[];
  renderItem: (item: T, index: number) => ReactNode;
  keyExtractor: (item: T) => string;
}

const List = <T,>({ items, renderItem, keyExtractor }: ListProps<T>) => {
  return (
    <ul className="list">
      {items.map((item, index) => (
        <li key={keyExtractor(item)}>
          {renderItem(item, index)}
        </li>
      ))}
    </ul>
  );
};

// 使用示例
<List
  items={users}
  renderItem={(user) => <UserCard user={user} />}
  keyExtractor={(user) => user.id}
/>
```

### 模式 5: 高阶组件模式 (HOC)

```typescript
// ✅ 正确：使用 HOC 复用逻辑

// 权限检查 HOC
const withAuth = <P extends object>(
  WrappedComponent: ComponentType<P>
): FC<P & { requiredRole?: string }> => {
  return ({ requiredRole, ...props }) => {
    const { user, isLoading } = useAuth();
    
    if (isLoading) return <LoadingSpinner />;
    
    if (!user) {
      return <Navigate to="/login" />;
    }
    
    if (requiredRole && user.role !== requiredRole) {
      return <ForbiddenPage />;
    }
    
    return <WrappedComponent {...(props as P)} />;
  };
};

// 使用
const AdminPage = withAuth(AdminPageComponent);
```

### 模式 6: 自定义 Hook 模式

```typescript
// ✅ 正确：提取可复用逻辑到 Hook

// useForm Hook
const useForm = <T extends Record<string, any>>(initialValues: T) => {
  const [values, setValues] = useState<T>(initialValues);
  const [errors, setErrors] = useState<Partial<Record<keyof T, string>>>({});
  const [touched, setTouched] = useState<Partial<Record<keyof T, boolean>>>({});
  
  const setValue = useCallback(<K extends keyof T>(
    key: K,
    value: T[K]
  ) => {
    setValues(prev => ({ ...prev, [key]: value }));
  }, []);
  
  const handleChange = useCallback(<K extends keyof T>(
    key: K
  ) => (e: ChangeEvent<HTMLInputElement>) => {
    setValue(key, e.target.value as T[K]);
  }, [setValue]);
  
  const handleBlur = useCallback(<K extends keyof T>(
    key: K
  ) => () => {
    setTouched(prev => ({ ...prev, [key]: true }));
  }, []);
  
  const reset = useCallback(() => {
    setValues(initialValues);
    setErrors({});
    setTouched({});
  }, [initialValues]);
  
  return {
    values,
    errors,
    touched,
    setValue,
    handleChange,
    handleBlur,
    reset
  };
};
```

### 模式 7: 状态提升模式

```typescript
// ✅ 正确：将共享状态提升到共同父组件

// 父组件管理共享状态
const ParentComponent = () => {
  const [selectedId, setSelectedId] = useState<string | null>(null);
  
  return (
    <div className="parent">
      <Sidebar 
        selectedId={selectedId}
        onSelect={setSelectedId}
      />
      <MainContent 
        selectedId={selectedId}
      />
    </div>
  );
};

// 子组件只接收 props
const Sidebar = ({ selectedId, onSelect }: SidebarProps) => {
  return (
    <nav>
      {items.map(item => (
        <button
          key={item.id}
          className={selectedId === item.id ? 'active' : ''}
          onClick={() => onSelect(item.id)}
        >
          {item.name}
        </button>
      ))}
    </nav>
  );
};
```

### 模式 8: Context 状态共享模式

```typescript
// ✅ 正确：使用 Context 跨层级共享状态

// 创建 Context
interface ThemeContextType {
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

// Provider 组件
const ThemeProvider: FC<{ children: ReactNode }> = ({ children }) => {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');
  
  const toggleTheme = useCallback(() => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  }, []);
  
  const value = useMemo(() => ({
    theme,
    toggleTheme
  }), [theme, toggleTheme]);
  
  return (
    <ThemeContext.Provider value={value}>
      {children}
    </ThemeContext.Provider>
  );
};

// 自定义 Hook
const useTheme = () => {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
};
```

### 模式 9: 错误边界模式

```typescript
// ✅ 正确：使用错误边界捕获渲染错误

interface ErrorBoundaryState {
  hasError: boolean;
  error: Error | null;
}

class ErrorBoundary extends Component<
  { children: ReactNode; fallback?: ReactNode },
  ErrorBoundaryState
> {
  constructor(props: { children: ReactNode; fallback?: ReactNode }) {
    super(props);
    this.state = { hasError: false, error: null };
  }
  
  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error };
  }
  
  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    // 上报错误
    console.error('Error caught by boundary:', error, errorInfo);
    logErrorToService(error, errorInfo);
  }
  
  render() {
    if (this.state.hasError) {
      return this.props.fallback || <ErrorFallback error={this.state.error} />;
    }
    
    return this.props.children;
  }
}
```

### 模式 10: 懒加载模式

```typescript
// ✅ 正确：使用懒加载优化首屏性能

// 路由懒加载
const Dashboard = lazy(() => import('./pages/Dashboard'));
const Settings = lazy(() => import('./pages/Settings'));

const App = () => {
  return (
    <Router>
      <Suspense fallback={<PageLoader />}>
        <Routes>
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/settings" element={<Settings />} />
        </Routes>
      </Suspense>
    </Router>
  );
};

// 组件懒加载
const HeavyChart = lazy(() => import('./components/HeavyChart'));

const AnalyticsPage = () => {
  const [showChart, setShowChart] = useState(false);
  
  return (
    <div>
      <button onClick={() => setShowChart(true)}>
        加载图表
      </button>
      {showChart && (
        <Suspense fallback={<ChartSkeleton />}>
          <HeavyChart />
        </Suspense>
      )}
    </div>
  );
};
```

---

## 反模式

### 反模式 1: Props 钻取 (Prop Drilling)

```typescript
// ❌ 错误：通过多层组件传递 props

const GrandParent = () => {
  const [user, setUser] = useState<User>({ name: 'John' });
  
  return <Parent user={user} />;  // 只是为了传递给子组件
};

const Parent = ({ user }: { user: User }) => {
  return <Child user={user} />;   // 继续传递
};

const Child = ({ user }: { user: User }) => {
  return <GrandChild user={user} />;  // 继续传递
};

const GrandChild = ({ user }: { user: User }) => {
  return <div>{user.name}</div>;  // 终于使用
};

// ✅ 正确：使用 Context 或状态管理
const GrandParent = () => {
  return (
    <UserProvider>
      <Parent />
    </UserProvider>
  );
};

const GrandChild = () => {
  const { user } = useUser();  // 直接获取
  return <div>{user.name}</div>;
};
```

### 反模式 2: 巨型组件

```typescript
// ❌ 错误：单个组件包含过多逻辑

const MegaComponent = () => {
  // 20+ 个 state
  const [state1, setState1] = useState('');
  const [state2, setState2] = useState(0);
  // ... 更多 state
  
  // 30+ 个处理函数
  const handleSomething1 = () => { /* 50行代码 */ };
  const handleSomething2 = () => { /* 80行代码 */ };
  // ... 更多处理函数
  
  // 200+ 行 JSX
  return (
    <div>
      {/* 大量嵌套 JSX */}
    </div>
  );
};

// ✅ 正确：拆分为多个小组件
const MegaComponent = () => {
  return (
    <div>
      <HeaderSection />
      <ContentSection />
      <FooterSection />
    </div>
  );
};

// 每个子组件独立管理自己的状态和逻辑
```

### 反模式 3: 内联样式对象

```typescript
// ❌ 错误：在 JSX 中定义大量内联样式

const BadComponent = () => {
  return (
    <div
      style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '20px',
        margin: '10px',
        backgroundColor: '#f0f0f0',
        borderRadius: '8px',
        boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
        // ... 更多样式
      }}
    >
      {/* ... */}
    </div>
  );
};

// ✅ 正确：使用 CSS 类或 styled-components
const GoodComponent = () => {
  return (
    <div className="card-container">
      {/* ... */}
    </div>
  );
};

// 或使用 CSS-in-JS
const Container = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: var(--spacing-lg);
  background-color: var(--color-bg-secondary);
`;
```

### 反模式 4: 在渲染中创建函数

```typescript
// ❌ 错误：每次渲染都创建新函数

const BadComponent = ({ items }: { items: string[] }) => {
  return (
    <ul>
      {items.map((item, index) => (
        <li
          key={index}
          onClick={() => {  // ❌ 每次渲染都创建新函数
            console.log('Clicked:', item);
            handleItemClick(item);
          }}
        >
          {item}
        </li>
      ))}
    </ul>
  );
};

// ✅ 正确：使用 useCallback 或提取组件
const GoodComponent = ({ items }: { items: string[] }) => {
  const handleClick = useCallback((item: string) => {
    console.log('Clicked:', item);
    handleItemClick(item);
  }, []);
  
  return (
    <ul>
      {items.map((item) => (
        <ListItem 
          key={item}
          item={item}
          onClick={handleClick}
        />
      ))}
    </ul>
  );
};

const ListItem = React.memo(({ item, onClick }: ListItemProps) => {
  const handleClick = () => onClick(item);
  
  return <li onClick={handleClick}>{item}</li>;
});
```

### 反模式 5: 过度使用 useEffect

```typescript
// ❌ 错误：用 useEffect 处理应该由事件处理的事情

const BadForm = () => {
  const [email, setEmail] = useState('');
  const [isValid, setIsValid] = useState(false);
  
  // ❌ 不必要的 useEffect
  useEffect(() => {
    setIsValid(email.includes('@'));
  }, [email]);
  
  return <input value={email} onChange={e => setEmail(e.target.value)} />;
};

// ✅ 正确：使用派生状态
const GoodForm = () => {
  const [email, setEmail] = useState('');
  
  // ✅ 直接计算，无需 useEffect
  const isValid = email.includes('@');
  
  return <input value={email} onChange={e => setEmail(e.target.value)} />;
};

// ❌ 错误：用 useEffect 同步状态
const BadSync = ({ value }: { value: string }) => {
  const [internalValue, setInternalValue] = useState(value);
  
  useEffect(() => {
    setInternalValue(value);  // ❌ 不必要的同步
  }, [value]);
  
  return <div>{internalValue}</div>;
};

// ✅ 正确：直接使用 props
const GoodSync = ({ value }: { value: string }) => {
  return <div>{value}</div>;  // ✅ 直接使用
};
```

### 反模式 6: 忽略依赖数组

```typescript
// ❌ 错误：useEffect 缺少依赖

const BadEffect = ({ userId }: { userId: string }) => {
  const [user, setUser] = useState<User | null>(null);
  
  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, []);  // ❌ 缺少 userId 依赖
  
  return <div>{user?.name}</div>;
};

// ❌ 错误：useCallback 缺少依赖
const BadCallback = ({ multiplier }: { multiplier: number }) => {
  const calculate = useCallback((value: number) => {
    return value * multiplier;  // ❌ 使用了 multiplier 但未声明依赖
  }, []);  // ❌ 缺少 multiplier 依赖
  
  return <div>{calculate(10)}</div>;
};

// ✅ 正确：完整声明依赖
const GoodEffect = ({ userId }: { userId: string }) => {
  const [user, setUser] = useState<User | null>(null);
  
  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);  // ✅ 完整依赖
  
  return <div>{user?.name}</div>;
};

const GoodCallback = ({ multiplier }: { multiplier: number }) => {
  const calculate = useCallback((value: number) => {
    return value * multiplier;
  }, [multiplier]);  // ✅ 完整依赖
  
  return <div>{calculate(10)}</div>;
};
```

### 反模式 7: 状态更新不函数式

```typescript
// ❌ 错误：基于旧状态更新时使用当前值

const BadCounter = () => {
  const [count, setCount] = useState(0);
  
  const increment = () => {
    setCount(count + 1);  // ❌ 使用当前值
    setCount(count + 1);  // ❌ 两次更新结果相同
  };
  
  return <button onClick={increment}>{count}</button>;
};

// ✅ 正确：使用函数式更新
const GoodCounter = () => {
  const [count, setCount] = useState(0);
  
  const increment = () => {
    setCount(prev => prev + 1);  // ✅ 使用函数式更新
    setCount(prev => prev + 1);  // ✅ 正确增加 2
  };
  
  return <button onClick={increment}>{count}</button>;
};
```

### 反模式 8: 在条件语句中调用 Hook

```typescript
// ❌ 错误：在条件中调用 Hook

const BadComponent = ({ shouldFetch }: { shouldFetch: boolean }) => {
  if (shouldFetch) {
    const data = useFetchData();  // ❌ 条件调用 Hook
    return <div>{data}</div>;
  }
  
  const [count, setCount] = useState(0);  // ❌ Hook 调用顺序不一致
  return <div>{count}</div>;
};

// ✅ 正确：始终在顶层调用 Hook
const GoodComponent = ({ shouldFetch }: { shouldFetch: boolean }) => {
  const data = useFetchData();  // ✅ 始终调用
  const [count, setCount] = useState(0);  // ✅ 顺序一致
  
  if (!shouldFetch) {
    return <div>{count}</div>;
  }
  
  return <div>{data}</div>;
};
```

### 反模式 9: 过早优化

```typescript
// ❌ 错误：不必要的优化

const BadOptimization = ({ name }: { name: string }) => {
  // ❌ 简单计算不需要 useMemo
  const greeting = useMemo(() => {
    return `Hello, ${name}!`;
  }, [name]);
  
  // ❌ 内联函数不需要 useCallback
  const handleClick = useCallback(() => {
    console.log('Clicked');
  }, []);
  
  // ❌ 简单组件不需要 memo
  const MemoizedDiv = useMemo(() => {
    return <div>{greeting}</div>;
  }, [greeting]);
  
  return MemoizedDiv;
};

// ✅ 正确：只在需要时优化
const GoodComponent = ({ name }: { name: string }) => {
  // ✅ 简单计算直接执行
  const greeting = `Hello, ${name}!`;
  
  // ✅ 内联函数直接定义
  const handleClick = () => {
    console.log('Clicked');
  };
  
  return <div onClick={handleClick}>{greeting}</div>;
};

// ✅ 正确的优化场景
const GoodOptimization = ({ items }: { items: Item[] }) => {
  // ✅ 昂贵的计算使用 useMemo
  const sortedItems = useMemo(() => {
    return [...items].sort((a, b) => complexCompare(a, b));
  }, [items]);
  
  // ✅ 传递给子组件的回调使用 useCallback
  const handleItemClick = useCallback((id: string) => {
    // 处理点击
  }, []);
  
  return (
    <ul>
      {sortedItems.map(item => (
        <ListItem
          key={item.id}
          item={item}
          onClick={handleItemClick}
        />
      ))}
    </ul>
  );
};
```

### 反模式 10: 硬编码字符串和魔法数字

```typescript
// ❌ 错误：硬编码的字符串和数字

const BadComponent = () => {
  const [status, setStatus] = useState('idle');  // ❌ 硬编码
  
  if (status === 'loading') {  // ❌ 硬编码
    return <div>加载中...</div>;  // ❌ 硬编码
  }
  
  const handleTimeout = () => {
    setTimeout(() => {}, 5000);  // ❌ 魔法数字
  };
  
  return <div style={{ padding: 20 }}>内容</div>;  // ❌ 硬编码
};

// ✅ 正确：使用常量和配置

// constants.ts
export const STATUS = {
  IDLE: 'idle',
  LOADING: 'loading',
  SUCCESS: 'success',
  ERROR: 'error'
} as const;

export const TIMEOUT = {
  SHORT: 1000,
  MEDIUM: 3000,
  LONG: 5000
} as const;

// i18n.ts
export const messages = {
  loading: '加载中...',
  success: '操作成功',
  error: '操作失败'
};

// Component.tsx
const GoodComponent = () => {
  const [status, setStatus] = useState(STATUS.IDLE);
  
  if (status === STATUS.LOADING) {
    return <div>{messages.loading}</div>;
  }
  
  const handleTimeout = () => {
    setTimeout(() => {}, TIMEOUT.LONG);
  };
  
  return (
    <div style={{ padding: SPACING.MEDIUM }}>
      内容
    </div>
  );
};
```

---

## 完整示例

### 示例：完整的 Modal 组件实现

#### 第一步：结构规划

```typescript
// modal-structure.json
{
  "step": "structure_planning",
  "component_tree": {
    "root": {
      "name": "Modal",
      "type": "container",
      "props": [
        "isOpen",
        "onClose",
        "title",
        "children",
        "footer",
        "size",
        "closeOnOverlayClick"
      ],
      "children": [
        {
          "name": "ModalOverlay",
          "type": "presentational",
          "props": ["onClick"]
        },
        {
          "name": "ModalContent",
          "type": "presentational",
          "props": ["size"],
          "children": [
            {
              "name": "ModalHeader",
              "type": "presentational",
              "props": ["title", "onClose"]
            },
            {
              "name": "ModalBody",
              "type": "presentational",
              "props": ["children"]
            },
            {
              "name": "ModalFooter",
              "type": "presentational",
              "props": ["children"]
            }
          ]
        }
      ]
    }
  },
  "state_design": {
    "local_states": [
      {
        "name": "isClosing",
        "type": "boolean",
        "initial_value": false,
        "description": "控制关闭动画"
      }
    ],
    "derived_states": [
      {
        "name": "shouldRender",
        "dependencies": ["isOpen", "isClosing"],
        "computation": "isOpen || isClosing"
      }
    ]
  },
  "data_flow": {
    "direction": "unidirectional",
    "events": ["onClose", "onOverlayClick"]
  }
}
```

#### 第二步：视觉实现

```tsx
// Modal.styles.ts
import { css } from '@emotion/react';

export const overlayStyles = css`
  position: fixed;
  inset: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: var(--z-index-modal);
`;

export const contentStyles = (size: ModalSize) => css`
  background-color: var(--color-bg-primary);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-xl);
  max-height: 90vh;
  overflow: auto;
  
  /* 响应式尺寸 */
  width: ${{
    sm: '400px',
    md: '500px',
    lg: '600px',
    xl: '800px',
    full: '95vw'
  }[size]};
  
  /* 移动端适配 */
  @media (max-width: 768px) {
    width: 95vw;
    margin: var(--spacing-md);
  }
`;

export const headerStyles = css`
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--spacing-lg);
  border-bottom: 1px solid var(--color-border-default);
`;

export const bodyStyles = css`
  padding: var(--spacing-lg);
`;

export const footerStyles = css`
  display: flex;
  justify-content: flex-end;
  gap: var(--spacing-md);
  padding: var(--spacing-lg);
  border-top: 1px solid var(--color-border-default);
`;
```

#### 第三步：交互完善

```tsx
// Modal.tsx
import React, { useState, useEffect, useCallback } from 'react';
import { createPortal } from 'react-dom';
import { 
  overlayStyles, 
  contentStyles, 
  headerStyles, 
  bodyStyles, 
  footerStyles 
} from './Modal.styles';

// 类型定义
export type ModalSize = 'sm' | 'md' | 'lg' | 'xl' | 'full';

export interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: React.ReactNode;
  children: React.ReactNode;
  footer?: React.ReactNode;
  size?: ModalSize;
  closeOnOverlayClick?: boolean;
  showCloseButton?: boolean;
}

// 子组件
const ModalOverlay: React.FC<{ onClick?: () => void }> = ({ onClick }) => (
  <div css={overlayStyles} onClick={onClick} aria-hidden="true" />
);

const ModalHeader: React.FC<{
  title?: React.ReactNode;
  onClose?: () => void;
  showCloseButton?: boolean;
}> = React.memo(({ title, onClose, showCloseButton }) => (
  <div css={headerStyles}>
    {title && <h2 id="modal-title">{title}</h2>}
    {showCloseButton && onClose && (
      <button
        onClick={onClose}
        aria-label="关闭"
        css={css`
          background: none;
          border: none;
          font-size: 1.5rem;
          cursor: pointer;
          padding: var(--spacing-xs);
          &:hover {
            opacity: 0.7;
          }
        `}
      >
        ×
      </button>
    )}
  </div>
));

const ModalBody: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <div css={bodyStyles}>{children}</div>
);

const ModalFooter: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <div css={footerStyles}>{children}</div>
);

// 主组件
export const Modal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title,
  children,
  footer,
  size = 'md',
  closeOnOverlayClick = true,
  showCloseButton = true
}) => {
  const [isClosing, setIsClosing] = useState(false);
  
  // 派生状态
  const shouldRender = isOpen || isClosing;
  
  // 关闭处理
  const handleClose = useCallback(() => {
    setIsClosing(true);
    // 等待动画完成
    setTimeout(() => {
      setIsClosing(false);
      onClose();
    }, 300);
  }, [onClose]);
  
  // 遮罩点击处理
  const handleOverlayClick = useCallback(() => {
    if (closeOnOverlayClick) {
      handleClose();
    }
  }, [closeOnOverlayClick, handleClose]);
  
  // 键盘事件处理
  useEffect(() => {
    if (!isOpen) return;
    
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        handleClose();
      }
    };
    
    document.addEventListener('keydown', handleKeyDown);
    document.body.style.overflow = 'hidden';
    
    return () => {
      document.removeEventListener('keydown', handleKeyDown);
      document.body.style.overflow = '';
    };
  }, [isOpen, handleClose]);
  
  // 焦点管理
  useEffect(() => {
    if (!isOpen) return;
    
    const modalElement = document.getElementById('modal-content');
    const previouslyFocused = document.activeElement as HTMLElement;
    
    modalElement?.focus();
    
    return () => {
      previouslyFocused?.focus();
    };
  }, [isOpen]);
  
  if (!shouldRender) return null;
  
  const modalContent = (
    <div
      role="dialog"
      aria-modal="true"
      aria-labelledby={title ? 'modal-title' : undefined}
      css={css`
        position: fixed;
        inset: 0;
        z-index: var(--z-index-modal);
      `}
    >
      <ModalOverlay onClick={handleOverlayClick} />
      <div
        id="modal-content"
        tabIndex={-1}
        css={[
          contentStyles(size),
          css`
            position: relative;
            z-index: calc(var(--z-index-modal) + 1);
            animation: ${isClosing ? 'fadeOut' : 'fadeIn'} 0.3s ease;
          `
        ]}
      >
        <ModalHeader
          title={title}
          onClose={handleClose}
          showCloseButton={showCloseButton}
        />
        <ModalBody>{children}</ModalBody>
        {footer && <ModalFooter>{footer}</ModalFooter>}
      </div>
    </div>
  );
  
  return createPortal(modalContent, document.body);
};
```

#### 第四步：优化重构

```tsx
// useModal.ts - 提取自定义 Hook
import { useState, useCallback } from 'react';

interface UseModalOptions {
  defaultOpen?: boolean;
  onOpen?: () => void;
  onClose?: () => void;
}

export const useModal = (options: UseModalOptions = {}) => {
  const { defaultOpen = false, onOpen, onClose } = options;
  
  const [isOpen, setIsOpen] = useState(defaultOpen);
  
  const open = useCallback(() => {
    setIsOpen(true);
    onOpen?.();
  }, [onOpen]);
  
  const close = useCallback(() => {
    setIsOpen(false);
    onClose?.();
  }, [onClose]);
  
  const toggle = useCallback(() => {
    setIsOpen(prev => {
      const next = !prev;
      if (next) {
        onOpen?.();
      } else {
        onClose?.();
      }
      return next;
    });
  }, [onOpen, onClose]);
  
  return {
    isOpen,
    open,
    close,
    toggle
  };
};

// Modal.optimized.tsx - 优化后的组件
import React, { useMemo } from 'react';
import { Modal, ModalProps } from './Modal';
import { useModal } from './useModal';

// 使用 React.memo 优化
export const OptimizedModal = React.memo<ModalProps>((props) => {
  return <Modal {...props} />;
});

OptimizedModal.displayName = 'OptimizedModal';

// 复合组件模式
export const ModalCompound = {
  Root: OptimizedModal,
  useModal
};

// 使用示例
const ExampleUsage = () => {
  const { isOpen, open, close } = useModal();
  
  return (
    <>
      <button onClick={open}>打开弹窗</button>
      <OptimizedModal
        isOpen={isOpen}
        onClose={close}
        title="示例弹窗"
        footer={
          <>
            <button onClick={close}>取消</button>
            <button onClick={close}>确认</button>
          </>
        }
      >
        <p>这是弹窗内容</p>
      </OptimizedModal>
    </>
  );
};
```

---

## 最佳实践

### 1. 组件设计原则

| 原则 | 说明 | 示例 |
|------|------|------|
| **单一职责** | 一个组件只做一件事 | 将表单拆分为 Input、Label、Error 组件 |
| **可复用性** | 设计通用的组件接口 | 使用 render props 或 slots |
| **可测试性** | 便于单元测试 | 纯函数组件、清晰的 props 接口 |
| **可访问性** | 支持所有用户 | ARIA 属性、键盘导航 |

### 2. 状态管理建议

```
状态位置决策树：

                    ┌─────────────────┐
                    │  这个状态属于？  │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
        ┌─────────┐    ┌─────────┐    ┌─────────┐
        │ 本地状态 │    │ 共享状态 │    │ 全局状态 │
        └────┬────┘    └────┬────┘    └────┬────┘
             │              │              │
             ▼              ▼              ▼
        useState      提升到父组件    Context/Redux
        useReducer    或状态管理库
```

### 3. 性能优化检查清单

- [ ] 使用 `React.memo` 避免不必要的重渲染
- [ ] 使用 `useMemo` 缓存昂贵的计算
- [ ] 使用 `useCallback` 缓存传递给子组件的回调
- [ ] 使用 `useTransition` 处理非紧急更新
- [ ] 使用 `useDeferredValue` 延迟低优先级更新
- [ ] 实现虚拟列表处理大量数据
- [ ] 使用代码分割减少初始加载

### 4. 代码质量检查清单

- [ ] 组件有清晰的 Props 类型定义
- [ ] 使用 TypeScript 严格模式
- [ ] 组件有 displayName（用于调试）
- [ ] 复杂的逻辑提取到自定义 Hook
- [ ] 避免内联样式和魔法数字
- [ ] 添加适当的注释
- [ ] 编写单元测试

---

## 附录

### A. 工具函数

```typescript
// utils/classNames.ts
export const classNames = (
  ...classes: (string | boolean | undefined | null)[]
): string => {
  return classes.filter(Boolean).join(' ');
};

// utils/debounce.ts
export const debounce = <T extends (...args: any[]) => void>(
  fn: T,
  delay: number
): ((...args: Parameters<T>) => void) => {
  let timeoutId: ReturnType<typeof setTimeout>;
  
  return (...args: Parameters<T>) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => fn(...args), delay);
  };
};

// utils/throttle.ts
export const throttle = <T extends (...args: any[]) => void>(
  fn: T,
  limit: number
): ((...args: Parameters<T>) => void) => {
  let inThrottle = false;
  
  return (...args: Parameters<T>) => {
    if (!inThrottle) {
      fn(...args);
      inThrottle = true;
      setTimeout(() => {
        inThrottle = false;
      }, limit);
    }
  };
};
```

### B. 类型工具

```typescript
// types/utils.ts

// 提取组件 Props 类型
export type ComponentProps<T> = T extends React.ComponentType<infer P> 
  ? P 
  : never;

// 可选属性
export type Optional<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>;

// 必需属性
export type Required<T, K extends keyof T> = T & Required<Pick<T, K>>;

// 深度只读
export type DeepReadonly<T> = {
  readonly [P in keyof T]: T[P] extends object 
    ? DeepReadonly<T[P]> 
    : T[P];
};

// 事件处理器类型
export type EventHandler<E extends React.SyntheticEvent> = (
  event: E
) => void;
```

---

*文档版本: 1.0.0*
*最后更新: 2024*
