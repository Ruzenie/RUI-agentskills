# 组件抽离规则与最佳实践

---

## 目录

1. [抽离触发阈值](#抽离触发阈值)
2. [四类抽离策略](#四类抽离策略)
3. [Props设计原则](#props设计原则)
4. [避免过度耦合指南](#避免过度耦合指南)
5. [回归验证检查清单](#回归验证检查清单)
6. [重构前后对比示例](#重构前后对比示例)

---

## 抽离触发阈值

### 1.1 代码行数阈值

| 组件类型 | 建议行数 | 强制抽离阈值 | 说明 |
|---------|---------|-------------|------|
| 函数组件 | 50-80行 | 150行 | 超过150行必须拆分 |
| 类组件 | 80-120行 | 200行 | 包含生命周期方法时 |
| 自定义Hook | 30-60行 | 100行 | 逻辑复杂度优先 |
| 工具函数 | 20-40行 | 80行 | 纯函数优先 |

### 1.2 复用次数阈值

| 复用场景 | 触发条件 | 抽离建议 |
|---------|---------|---------|
| 相同代码块 | 出现2次 | 考虑抽离为独立组件 |
| 相同代码块 | 出现3次+ | **必须抽离** |
| 相似逻辑 | 出现2次+ | 抽象为可配置组件 |
| 跨页面复用 | 出现1次 | 抽离到共享组件库 |

### 1.3 复杂度阈值

```typescript
// 复杂度评估指标
interface ComplexityThreshold {
  // 条件渲染分支数
  conditionalBranches: number;      // 阈值: > 5
  
  // useState/useReducer数量
  stateHooks: number;               // 阈值: > 4
  
  // useEffect/useLayoutEffect数量
  effectHooks: number;              // 阈值: > 5
  
  // 回调函数数量
  callbacks: number;                // 阈值: > 6
  
  // 嵌套层级深度
  nestingDepth: number;             // 阈值: > 4
}
```

### 1.4 职责单一性阈值

当一个组件满足以下任一条件时，应考虑抽离：

- [ ] 同时处理**数据获取**和**UI渲染**
- [ ] 同时管理**本地状态**和**全局状态**
- [ ] 包含**业务逻辑**和**通用UI**
- [ ] 渲染**多个不相关的视觉区域**

---

## 四类抽离策略

### 2.1 结构块 → Section子组件

**适用场景**：大型页面中独立的视觉区块

**判定标准**：
- 视觉上与其他区域有明显分隔
- 具有独立的标题或标识
- 功能上相对独立完整

**抽离规则**：

```typescript
// ❌ 抽离前：臃肿的页面组件
function ProductPage() {
  return (
    <div>
      {/* Header区域 - 50行 */}
      <header>...</header>
      
      {/* 产品信息区域 - 80行 */}
      <section>...</section>
      
      {/* 用户评价区域 - 60行 */}
      <section>...</section>
      
      {/* 相关推荐区域 - 40行 */}
      <section>...</section>
      
      {/* Footer区域 - 30行 */}
      <footer>...</footer>
    </div>
  );
}

// ✅ 抽离后：清晰的结构
function ProductPage() {
  return (
    <PageLayout>
      <ProductHeader product={product} />
      <ProductInfo product={product} />
      <UserReviews productId={product.id} />
      <RelatedProducts category={product.category} />
      <PageFooter />
    </PageLayout>
  );
}
```

**命名规范**：
- 使用领域名词：`ProductInfo`、`UserProfile`、`OrderSummary`
- 避免通用名称：`Section1`、`BlockA`、`Content`
- 体现层级关系：`ProductPage` → `ProductInfo` → `ProductPrice`

---

### 2.2 重复块 → 可复用组件

**适用场景**：相同或相似的UI元素多次出现

**判定标准**：
- 视觉上完全一致
- 结构相似但数据不同
- 交互行为一致

**抽离规则**：

```typescript
// ❌ 抽离前：重复代码
function UserList() {
  return (
    <div>
      {users.map(user => (
        <div className="user-card" key={user.id}>
          <img src={user.avatar} className="user-avatar" />
          <div className="user-info">
            <h3 className="user-name">{user.name}</h3>
            <p className="user-email">{user.email}</p>
          </div>
          <button className="user-action">关注</button>
        </div>
      ))}
    </div>
  );
}

function TeamList() {
  return (
    <div>
      {members.map(member => (
        <div className="user-card" key={member.id}>  {/* 重复结构 */}
          <img src={member.avatar} className="user-avatar" />
          <div className="user-info">
            <h3 className="user-name">{member.name}</h3>
            <p className="user-email">{member.role}</p>  {/* 仅数据字段不同 */}
          </div>
          <button className="user-action">邀请</button>  {/* 仅操作不同 */}
        </div>
      ))}
    </div>
  );
}

// ✅ 抽离后：可复用组件
interface UserCardProps {
  id: string;
  avatar: string;
  name: string;
  subtitle: string;
  actionLabel: string;
  onAction: (id: string) => void;
}

function UserCard({ 
  id, 
  avatar, 
  name, 
  subtitle, 
  actionLabel, 
  onAction 
}: UserCardProps) {
  return (
    <div className="user-card">
      <img src={avatar} alt={name} className="user-avatar" />
      <div className="user-info">
        <h3 className="user-name">{name}</h3>
        <p className="user-subtitle">{subtitle}</p>
      </div>
      <button 
        className="user-action" 
        onClick={() => onAction(id)}
      >
        {actionLabel}
      </button>
    </div>
  );
}

// 使用
function UserList() {
  return (
    <div>
      {users.map(user => (
        <UserCard
          key={user.id}
          id={user.id}
          avatar={user.avatar}
          name={user.name}
          subtitle={user.email}
          actionLabel="关注"
          onAction={handleFollow}
        />
      ))}
    </div>
  );
}
```

**可复用组件设计原则**：
1. **配置化优先**：通过props控制变体，而非创建多个组件
2. **组合优于继承**：使用children和render props实现灵活组合
3. **样式隔离**：使用CSS Modules或Styled Components避免样式污染

---

### 2.3 状态块 → 状态组件

**适用场景**：包含复杂状态管理的UI区域

**判定标准**：
- 使用3个及以上的useState/useReducer
- 状态仅在特定区域内使用
- 状态逻辑与UI渲染耦合

**抽离规则**：

```typescript
// ❌ 抽离前：状态与UI混杂
function ProductFilter() {
  const [category, setCategory] = useState('all');
  const [priceRange, setPriceRange] = useState([0, 1000]);
  const [sortBy, setSortBy] = useState('price');
  const [isExpanded, setIsExpanded] = useState(false);
  const [filters, setFilters] = useState<Filter[]>([]);
  
  const handleCategoryChange = (cat: string) => {
    setCategory(cat);
    updateFilters({ category: cat });
  };
  
  const handlePriceChange = (range: number[]) => {
    setPriceRange(range);
    updateFilters({ minPrice: range[0], maxPrice: range[1] });
  };
  
  // ... 更多处理函数
  
  return (
    <div className="filter-panel">
      {/* 50+ 行渲染代码 */}
    </div>
  );
}

// ✅ 抽离后：状态与UI分离
// 自定义Hook管理状态
function useProductFilter(onFilterChange: (filters: Filter) => void) {
  const [category, setCategory] = useState('all');
  const [priceRange, setPriceRange] = useState([0, 1000]);
  const [sortBy, setSortBy] = useState('price');
  const [isExpanded, setIsExpanded] = useState(false);
  
  const filters = useMemo(() => ({
    category,
    minPrice: priceRange[0],
    maxPrice: priceRange[1],
    sortBy
  }), [category, priceRange, sortBy]);
  
  useEffect(() => {
    onFilterChange(filters);
  }, [filters, onFilterChange]);
  
  return {
    category,
    setCategory,
    priceRange,
    setPriceRange,
    sortBy,
    setSortBy,
    isExpanded,
    toggleExpanded: () => setIsExpanded(v => !v)
  };
}

// UI组件只负责渲染
function ProductFilter({ onFilterChange }: { onFilterChange: (filters: Filter) => void }) {
  const filterState = useProductFilter(onFilterChange);
  
  return (
    <FilterPanel {...filterState} />
  );
}
```

**状态组件设计原则**：
1. **状态提升**：共享状态提升到最近公共祖先
2. **状态下沉**：专用状态下沉到使用组件
3. **单一数据源**：避免同一状态多处存储

---

### 2.4 逻辑块 → 自定义Hook

**适用场景**：可复用的业务逻辑或副作用

**判定标准**：
- 逻辑在多个组件中重复
- 逻辑与特定UI无关
- 包含副作用（API调用、订阅等）

**抽离规则**：

```typescript
// ❌ 抽离前：逻辑内嵌
function UserProfile({ userId }: { userId: string }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);
  
  useEffect(() => {
    let cancelled = false;
    
    async function fetchUser() {
      setLoading(true);
      setError(null);
      
      try {
        const response = await fetch(`/api/users/${userId}`);
        if (!response.ok) throw new Error('Failed to fetch');
        const data = await response.json();
        
        if (!cancelled) {
          setUser(data);
        }
      } catch (err) {
        if (!cancelled) {
          setError(err as Error);
        }
      } finally {
        if (!cancelled) {
          setLoading(false);
        }
      }
    }
    
    fetchUser();
    
    return () => { cancelled = true; };
  }, [userId]);
  
  // ... 渲染代码
}

// ✅ 抽离后：通用Hook
interface UseFetchOptions<T> {
  url: string;
  deps?: React.DependencyList;
  transform?: (data: unknown) => T;
}

interface UseFetchResult<T> {
  data: T | null;
  loading: boolean;
  error: Error | null;
  refetch: () => void;
}

function useFetch<T>({ url, deps = [], transform }: UseFetchOptions<T>): UseFetchResult<T> {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);
  
  const fetchData = useCallback(async () => {
    let cancelled = false;
    
    setLoading(true);
    setError(null);
    
    try {
      const response = await fetch(url);
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      
      const rawData = await response.json();
      const transformedData = transform ? transform(rawData) : rawData;
      
      if (!cancelled) {
        setData(transformedData as T);
      }
    } catch (err) {
      if (!cancelled) {
        setError(err as Error);
      }
    } finally {
      if (!cancelled) {
        setLoading(false);
      }
    }
    
    return () => { cancelled = true; };
  }, [url, transform]);
  
  useEffect(() => {
    const cleanup = fetchData();
    return () => {
      cleanup.then(cleanupFn => cleanupFn?.());
    };
  }, deps);
  
  return { data, loading, error, refetch: fetchData };
}

// 使用
function UserProfile({ userId }: { userId: string }) {
  const { data: user, loading, error } = useFetch<User>({
    url: `/api/users/${userId}`,
    deps: [userId]
  });
  
  // 简洁的渲染逻辑
}
```

**自定义Hook命名规范**：
- 必须以`use`开头：`useFetch`、`useLocalStorage`
- 体现功能：`useDebounce`而非`useDelay`
- 返回对象时保持结构一致

---

## Props设计原则

### 3.1 最小化原则

```typescript
// ❌ 过度传递
interface BadProps {
  user: User;                    // 传递整个对象
  config: AppConfig;             // 传递不相关的配置
  theme: Theme;                  // 应使用Context
  onUpdate: () => void;          // 未使用的回调
}

// ✅ 精确传递
interface GoodProps {
  userId: string;               // 只传递需要的ID
  userName: string;             // 只传递显示的字段
  avatarUrl?: string;           // 可选字段
  onFollow: (userId: string) => void;  // 具体的回调
}
```

### 3.2 类型完整性原则

```typescript
// ✅ 完整的类型定义
interface ButtonProps {
  // 必需props
  children: React.ReactNode;
  onClick: () => void;
  
  // 可选props
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  loading?: boolean;
  
  // 原生属性扩展
  className?: string;
  style?: React.CSSProperties;
  
  // ref转发
  ref?: React.Ref<HTMLButtonElement>;
}
```

### 3.3 默认值原则

```typescript
// ✅ 合理的默认值
function Button({
  children,
  onClick,
  variant = 'primary',    // 最常见的变体作为默认
  size = 'md',            // 中等尺寸作为默认
  disabled = false,
  loading = false,
  className = '',
  ...rest
}: ButtonProps) {
  // 组件实现
}
```

### 3.4 组合性原则

```typescript
// ✅ 支持组合的设计
interface CardProps {
  // 使用children而非固定结构
  children: React.ReactNode;
  
  // 可选的头部和底部
  header?: React.ReactNode;
  footer?: React.ReactNode;
  
  // 配置选项
  padding?: 'none' | 'sm' | 'md' | 'lg';
  shadow?: 'none' | 'sm' | 'md' | 'lg';
}

// 使用示例
<Card 
  header={<CardTitle>标题</CardTitle>}
  footer={<CardActions>操作</CardActions>}
>
  <CardContent>内容</CardContent>
</Card>
```

### 3.5 可扩展性原则

```typescript
// ✅ 支持HTML原生属性
interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  // 组件特有props
  label?: string;
  error?: string;
  helperText?: string;
  
  // 不覆盖原生属性名称
  // ❌ 错误：type: 'text' | 'password'
  // ✅ 正确：inputType: 'text' | 'password'
  inputType?: 'text' | 'password' | 'email';
}

function Input({ 
  label, 
  error, 
  helperText, 
  inputType = 'text',
  className,
  ...nativeProps   // 保留所有原生input属性
}: InputProps) {
  return (
    <div className={className}>
      {label && <label>{label}</label>}
      <input type={inputType} {...nativeProps} />
      {error && <span className="error">{error}</span>}
      {helperText && <span className="helper">{helperText}</span>}
    </div>
  );
}
```

---

## 避免过度耦合指南

### 4.1 数据耦合

```typescript
// ❌ 强数据耦合：组件依赖特定数据结构
function UserList({ users }: { users: User[] }) {
  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>
          {user.profile.name} - {user.profile.email}
        </li>
      ))}
    </ul>
  );
}

// ✅ 松耦合：通过props映射数据
interface UserListItem {
  id: string;
  primaryText: string;
  secondaryText?: string;
}

function UserList({ items }: { items: UserListItem[] }) {
  return (
    <ul>
      {items.map(item => (
        <li key={item.id}>
          {item.primaryText}
          {item.secondaryText && ` - ${item.secondaryText}`}
        </li>
      ))}
    </ul>
  );
}

// 使用处进行数据转换
<UserList 
  items={users.map(u => ({
    id: u.id,
    primaryText: u.profile.name,
    secondaryText: u.profile.email
  }))} 
/>
```

### 4.2 事件耦合

```typescript
// ❌ 强事件耦合：组件直接调用父级方法
function SaveButton({ onSave }: { onSave: () => void }) {
  const handleClick = () => {
    // 组件内部处理逻辑
    validateForm();
    // 直接调用父级保存
    onSave();
    // 更多内部逻辑
    showSuccessMessage();
  };
  
  return <button onClick={handleClick}>保存</button>;
}

// ✅ 松耦合：通过回调传递数据，不假设父级行为
function SaveButton({ 
  onSave,
  onValidate,
  onSuccess 
}: { 
  onSave: () => Promise<void>;
  onValidate?: () => boolean;
  onSuccess?: () => void;
}) {
  const [saving, setSaving] = useState(false);
  
  const handleClick = async () => {
    if (onValidate && !onValidate()) return;
    
    setSaving(true);
    try {
      await onSave();
      onSuccess?.();
    } finally {
      setSaving(false);
    }
  };
  
  return (
    <button onClick={handleClick} disabled={saving}>
      {saving ? '保存中...' : '保存'}
    </button>
  );
}
```

### 4.3 样式耦合

```typescript
// ❌ 强样式耦合：硬编码样式和类名
function Alert({ message }: { message: string }) {
  return (
    <div style={{ 
      padding: '16px', 
      backgroundColor: '#fee2e2',
      border: '1px solid #ef4444'
    }}>
      {message}
    </div>
  );
}

// ✅ 松耦合：通过props配置样式
interface AlertProps {
  message: string;
  variant?: 'info' | 'success' | 'warning' | 'error';
  className?: string;
}

function Alert({ 
  message, 
  variant = 'info',
  className 
}: AlertProps) {
  const variantStyles = {
    info: 'bg-blue-50 border-blue-400',
    success: 'bg-green-50 border-green-400',
    warning: 'bg-yellow-50 border-yellow-400',
    error: 'bg-red-50 border-red-400'
  };
  
  return (
    <div className={`p-4 border ${variantStyles[variant]} ${className}`}>
      {message}
    </div>
  );
}
```

### 4.4 上下文耦合

```typescript
// ❌ 强上下文耦合：直接使用全局状态
function UserAvatar() {
  const user = useContext(UserContext);  // 隐式依赖
  return <img src={user.avatar} />;
}

// ✅ 松耦合：通过props传递，或使用明确的Hook
interface UserAvatarProps {
  avatarUrl: string;
  name?: string;
  size?: 'sm' | 'md' | 'lg';
}

function UserAvatar({ 
  avatarUrl, 
  name,
  size = 'md' 
}: UserAvatarProps) {
  const sizeClasses = { sm: 'w-8 h-8', md: 'w-12 h-12', lg: 'w-16 h-16' };
  
  return (
    <img 
      src={avatarUrl} 
      alt={name}
      className={`rounded-full ${sizeClasses[size]}`}
    />
  );
}

// 包装组件处理上下文
function CurrentUserAvatar(props: Omit<UserAvatarProps, 'avatarUrl'>) {
  const user = useContext(UserContext);
  return <UserAvatar {...props} avatarUrl={user.avatar} name={user.name} />;
}
```

### 4.5 生命周期耦合

```typescript
// ❌ 强生命周期耦合：组件控制父级状态
function Modal({ isOpen, onClose }: { isOpen: boolean; onClose: () => void }) {
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';  // 副作用
    }
    return () => {
      document.body.style.overflow = 'auto';
    };
  }, [isOpen]);
  
  if (!isOpen) return null;
  
  return (
    <div onClick={onClose}>
      <div onClick={e => e.stopPropagation()}>
        {/* 内容 */}
      </div>
    </div>
  );
}

// ✅ 松耦合：副作用由专门的Hook处理
function useBodyScrollLock(locked: boolean) {
  useEffect(() => {
    if (!locked) return;
    
    const originalStyle = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    
    return () => {
      document.body.style.overflow = originalStyle;
    };
  }, [locked]);
}

function Modal({ isOpen, onClose, children }: ModalProps) {
  useBodyScrollLock(isOpen);
  
  if (!isOpen) return null;
  
  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={e => e.stopPropagation()}>
        {children}
      </div>
    </div>
  );
}
```

### 4.6 类型耦合

```typescript
// ❌ 强类型耦合：组件依赖具体类型
function ProductCard({ product }: { product: Product }) {
  return <div>{product.name}</div>;
}

// ✅ 松耦合：使用泛型和最小接口
interface CardItem {
  id: string;
  title: string;
  description?: string;
}

function ProductCard<T extends CardItem>({ 
  item,
  renderActions 
}: { 
  item: T;
  renderActions?: (item: T) => React.ReactNode;
}) {
  return (
    <div>
      <h3>{item.title}</h3>
      {item.description && <p>{item.description}</p>}
      {renderActions?.(item)}
    </div>
  );
}
```

### 4.7 路由耦合

```typescript
// ❌ 强路由耦合：组件内部处理导航
function ProductLink({ product }: { product: Product }) {
  const navigate = useNavigate();
  
  return (
    <a onClick={() => navigate(`/products/${product.id}`)}>
      {product.name}
    </a>
  );
}

// ✅ 松耦合：通过props传递链接
interface ProductLinkProps {
  product: Product;
  href: string;  // 由父级决定链接
  external?: boolean;
}

function ProductLink({ product, href, external }: ProductLinkProps) {
  return (
    <a 
      href={href}
      target={external ? '_blank' : undefined}
      rel={external ? 'noopener noreferrer' : undefined}
    >
      {product.name}
    </a>
  );
}
```

### 4.8 API耦合

```typescript
// ❌ 强API耦合：组件直接调用API
function UserList() {
  const [users, setUsers] = useState<User[]>([]);
  
  useEffect(() => {
    fetch('/api/users')
      .then(res => res.json())
      .then(setUsers);
  }, []);
  
  return <ul>{users.map(u => <li key={u.id}>{u.name}</li>)}</ul>;
}

// ✅ 松耦合：通过props传递数据获取逻辑
interface UserListProps {
  users: User[];
  loading?: boolean;
  error?: Error | null;
}

function UserList({ users, loading, error }: UserListProps) {
  if (loading) return <Loading />;
  if (error) return <Error message={error.message} />;
  
  return <ul>{users.map(u => <li key={u.id}>{u.name}</li>)}</ul>;
}

// 容器组件处理数据获取
function UserListContainer() {
  const { data: users, loading, error } = useFetch<User[]>({
    url: '/api/users'
  });
  
  return <UserList users={users || []} loading={loading} error={error} />;
}
```

### 4.9 状态耦合

```typescript
// ❌ 强状态耦合：组件管理不属于自己的状态
function FormInput({ 
  value, 
  onChange 
}: { 
  value: string; 
  onChange: (value: string) => void 
}) {
  const [localValue, setLocalValue] = useState(value);
  
  // 问题：同时存在本地状态和外部状态
  return (
    <input 
      value={localValue}
      onChange={e => {
        setLocalValue(e.target.value);
        onChange(e.target.value);
      }}
    />
  );
}

// ✅ 松耦合：明确是受控还是非受控
// 受控组件
function ControlledInput({ 
  value, 
  onChange,
  ...props
}: React.InputHTMLAttributes<HTMLInputElement> & {
  onChange: (value: string) => void;
}) {
  return (
    <input 
      {...props}
      value={value}
      onChange={e => onChange(e.target.value)}
    />
  );
}

// 非受控组件（带默认值）
function UncontrolledInput({
  defaultValue = '',
  onChange,
  ...props
}: React.InputHTMLAttributes<HTMLInputElement> & {
  defaultValue?: string;
  onChange?: (value: string) => void;
}) {
  const [value, setValue] = useState(defaultValue);
  
  return (
    <input
      {...props}
      value={value}
      onChange={e => {
        setValue(e.target.value);
        onChange?.(e.target.value);
      }}
    />
  );
}
```

### 4.10 依赖耦合

```typescript
// ❌ 强依赖耦合：组件依赖特定库的实现细节
function DatePicker({ value, onChange }: DatePickerProps) {
  const date = moment(value);  // 依赖moment.js
  
  return (
    <input 
      value={date.format('YYYY-MM-DD')}
      onChange={e => onChange(moment(e.target.value).toDate())}
    />
  );
}

// ✅ 松耦合：使用标准类型，内部处理转换
interface DatePickerProps {
  value: Date | null;
  onChange: (date: Date | null) => void;
  format?: string;
  minDate?: Date;
  maxDate?: Date;
}

function DatePicker({ 
  value, 
  onChange,
  format = 'yyyy-MM-dd',
  minDate,
  maxDate
}: DatePickerProps) {
  // 内部使用日期库，但对外暴露标准Date类型
  const formattedValue = value ? formatDate(value, format) : '';
  
  return (
    <input
      type="date"
      value={formattedValue}
      min={minDate ? formatDate(minDate, format) : undefined}
      max={maxDate ? formatDate(maxDate, format) : undefined}
      onChange={e => {
        const date = e.target.value ? parseDate(e.target.value) : null;
        onChange(date);
      }}
    />
  );
}
```

---

## 回归验证检查清单

### 5.1 功能完整性检查（5项）

| 序号 | 检查项 | 验证方法 | 通过标准 |
|-----|-------|---------|---------|
| 1 | 原有功能保留 | 功能测试 | 所有原有功能正常工作 |
| 2 | 状态管理正确 | 状态测试 | 状态更新逻辑与重构前一致 |
| 3 | 事件处理正常 | 交互测试 | 所有事件回调正确触发 |
| 4 | 数据流正确 | 数据测试 | 数据流向和转换逻辑正确 |
| 5 | 边界条件处理 | 边界测试 | 空值、异常值处理正确 |

### 5.2 性能检查（3项）

| 序号 | 检查项 | 验证方法 | 通过标准 |
|-----|-------|---------|---------|
| 6 | 渲染性能 | React DevTools Profiler | 渲染次数不增加 |
| 7 | 内存使用 | Memory Profiler | 无内存泄漏 |
| 8 | 包体积 | Bundle Analyzer | 无显著增加 |

### 5.3 代码质量检查（4项）

| 序号 | 检查项 | 验证方法 | 通过标准 |
|-----|-------|---------|---------|
| 9 | TypeScript类型完整 | tsc检查 | 无类型错误 |
| 10 | 代码规范 | ESLint | 无警告和错误 |
| 11 | 测试覆盖率 | 测试报告 | 覆盖率不下降 |
| 12 | 组件文档 | 文档检查 | Props文档完整 |

### 5.4 兼容性检查（3项）

| 序号 | 检查项 | 验证方法 | 通过标准 |
|-----|-------|---------|---------|
| 13 | 浏览器兼容 | 跨浏览器测试 | 主流浏览器正常 |
| 14 | 响应式布局 | 多设备测试 | 各断点显示正常 |
| 15 | 无障碍支持 | a11y检查 | 符合WCAG标准 |

### 5.5 检查清单使用模板

```markdown
## 回归验证报告

### 基本信息
- 重构组件: [组件名称]
- 重构日期: [日期]
- 验证人员: [姓名]

### 功能完整性
- [ ] 1. 原有功能保留
- [ ] 2. 状态管理正确
- [ ] 3. 事件处理正常
- [ ] 4. 数据流正确
- [ ] 5. 边界条件处理

### 性能检查
- [ ] 6. 渲染性能
- [ ] 7. 内存使用
- [ ] 8. 包体积

### 代码质量
- [ ] 9. TypeScript类型完整
- [ ] 10. 代码规范
- [ ] 11. 测试覆盖率
- [ ] 12. 组件文档

### 兼容性
- [ ] 13. 浏览器兼容
- [ ] 14. 响应式布局
- [ ] 15. 无障碍支持

### 问题记录
| 序号 | 问题描述 | 严重程度 | 处理状态 |
|-----|---------|---------|---------|
| 1 | | | |

### 结论
[通过/有条件通过/不通过]
```

---

## 重构前后对比示例

### 示例1：Dashboard页面重构

#### 重构前

```typescript
// Dashboard.tsx - 280行
function Dashboard() {
  const [users, setUsers] = useState([]);
  const [orders, setOrders] = useState([]);
  const [stats, setStats] = useState({});
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState('overview');
  const [dateRange, setDateRange] = useState([null, null]);
  const [searchQuery, setSearchQuery] = useState('');
  
  useEffect(() => {
    fetchDashboardData();
  }, [dateRange]);
  
  const fetchDashboardData = async () => {
    setLoading(true);
    const [usersRes, ordersRes, statsRes] = await Promise.all([
      fetch('/api/users'),
      fetch('/api/orders'),
      fetch('/api/stats')
    ]);
    setUsers(await usersRes.json());
    setOrders(await ordersRes.json());
    setStats(await statsRes.json());
    setLoading(false);
  };
  
  const filteredUsers = users.filter(u => 
    u.name.toLowerCase().includes(searchQuery.toLowerCase())
  );
  
  const handleUserAction = (userId, action) => {
    // 50行处理逻辑
  };
  
  const handleOrderAction = (orderId, action) => {
    // 40行处理逻辑
  };
  
  return (
    <div className="dashboard">
      {/* Header - 30行 */}
      <header>...</header>
      
      {/* Stats Cards - 40行 */}
      <div className="stats-grid">
        <div className="stat-card">...</div>
        <div className="stat-card">...</div>
        <div className="stat-card">...</div>
        <div className="stat-card">...</div>
      </div>
      
      {/* Tabs - 25行 */}
      <div className="tabs">...</div>
      
      {/* Overview Tab - 60行 */}
      {activeTab === 'overview' && (
        <div>...</div>
      )}
      
      {/* Users Tab - 80行 */}
      {activeTab === 'users' && (
        <div>
          <input 
            value={searchQuery}
            onChange={e => setSearchQuery(e.target.value)}
          />
          <table>...</table>
        </div>
      )}
      
      {/* Orders Tab - 70行 */}
      {activeTab === 'orders' && (
        <div>...</div>
      )}
    </div>
  );
}
```

#### 重构后

```typescript
// Dashboard.tsx - 45行
import { DashboardHeader } from './DashboardHeader';
import { StatsOverview } from './StatsOverview';
import { DashboardTabs } from './DashboardTabs';
import { useDashboardData } from './useDashboardData';

function Dashboard() {
  const { stats, loading, dateRange, setDateRange } = useDashboardData();
  const [activeTab, setActiveTab] = useState('overview');
  
  if (loading) return <DashboardSkeleton />;
  
  return (
    <div className="dashboard">
      <DashboardHeader 
        dateRange={dateRange}
        onDateRangeChange={setDateRange}
      />
      <StatsOverview stats={stats} />
      <DashboardTabs 
        activeTab={activeTab}
        onTabChange={setActiveTab}
      />
    </div>
  );
}

// useDashboardData.ts - 35行
export function useDashboardData() {
  const [data, setData] = useState({ users: [], orders: [], stats: {} });
  const [loading, setLoading] = useState(true);
  const [dateRange, setDateRange] = useState([null, null]);
  
  useEffect(() => {
    fetchData();
  }, [dateRange]);
  
  const fetchData = async () => {
    setLoading(true);
    const result = await dashboardAPI.fetchAll(dateRange);
    setData(result);
    setLoading(false);
  };
  
  return { ...data, loading, dateRange, setDateRange };
}

// DashboardTabs.tsx - 30行
import { OverviewTab } from './tabs/OverviewTab';
import { UsersTab } from './tabs/UsersTab';
import { OrdersTab } from './tabs/OrdersTab';

const tabs = [
  { id: 'overview', label: '概览', component: OverviewTab },
  { id: 'users', label: '用户', component: UsersTab },
  { id: 'orders', label: '订单', component: OrdersTab }
];

export function DashboardTabs({ activeTab, onTabChange }) {
  const ActiveComponent = tabs.find(t => t.id === activeTab)?.component;
  
  return (
    <div>
      <TabList tabs={tabs} activeTab={activeTab} onChange={onTabChange} />
      <div className="tab-content">
        {ActiveComponent && <ActiveComponent />}
      </div>
    </div>
  );
}

// UsersTab.tsx - 50行
import { useUsers } from './useUsers';
import { UserSearch } from './UserSearch';
import { UserTable } from './UserTable';

export function UsersTab() {
  const { users, loading, searchQuery, setSearchQuery } = useUsers();
  
  return (
    <div>
      <UserSearch value={searchQuery} onChange={setSearchQuery} />
      <UserTable users={users} loading={loading} />
    </div>
  );
}
```

**重构收益**：
- 主组件从280行减少到45行
- 逻辑清晰分离，每个文件职责单一
- 测试更容易，可以单独测试各个子组件
- 代码复用性提高

---

### 示例2：表单组件重构

#### 重构前

```typescript
// UserForm.tsx - 200行
function UserForm({ onSubmit, initialData }) {
  const [formData, setFormData] = useState(initialData || {});
  const [errors, setErrors] = useState({});
  const [touched, setTouched] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  
  const validate = () => {
    const newErrors = {};
    if (!formData.name) newErrors.name = '姓名必填';
    if (!formData.email) newErrors.email = '邮箱必填';
    else if (!/\S+@\S+\.\S+/.test(formData.email)) {
      newErrors.email = '邮箱格式不正确';
    }
    if (!formData.phone) newErrors.phone = '电话必填';
    // 更多验证规则...
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };
  
  const handleChange = (field, value) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    if (touched[field]) {
      validate();
    }
  };
  
  const handleBlur = (field) => {
    setTouched(prev => ({ ...prev, [field]: true }));
    validate();
  };
  
  const handleSubmit = async (e) => {
    e.preventDefault();
    setTouched({ name: true, email: true, phone: true });
    
    if (!validate()) return;
    
    setIsSubmitting(true);
    try {
      await onSubmit(formData);
    } finally {
      setIsSubmitting(false);
    }
  };
  
  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>姓名</label>
        <input
          value={formData.name || ''}
          onChange={e => handleChange('name', e.target.value)}
          onBlur={() => handleBlur('name')}
        />
        {touched.name && errors.name && <span>{errors.name}</span>}
      </div>
      
      <div>
        <label>邮箱</label>
        <input
          value={formData.email || ''}
          onChange={e => handleChange('email', e.target.value)}
          onBlur={() => handleBlur('email')}
        />
        {touched.email && errors.email && <span>{errors.email}</span>}
      </div>
      
      <div>
        <label>电话</label>
        <input
          value={formData.phone || ''}
          onChange={e => handleChange('phone', e.target.value)}
          onBlur={() => handleBlur('phone')}
        />
        {touched.phone && errors.phone && <span>{errors.phone}</span>}
      </div>
      
      <button type="submit" disabled={isSubmitting}>
        {isSubmitting ? '提交中...' : '提交'}
      </button>
    </form>
  );
}
```

#### 重构后

```typescript
// useForm.ts - 通用表单Hook - 60行
interface UseFormOptions<T> {
  initialValues: T;
  validate: (values: T) => Partial<Record<keyof T, string>>;
  onSubmit: (values: T) => Promise<void>;
}

export function useForm<T extends Record<string, any>>({
  initialValues,
  validate,
  onSubmit
}: UseFormOptions<T>) {
  const [values, setValues] = useState<T>(initialValues);
  const [errors, setErrors] = useState<Partial<Record<keyof T, string>>>({});
  const [touched, setTouched] = useState<Partial<Record<keyof T, boolean>>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  
  const runValidation = useCallback((vals: T) => {
    const validationErrors = validate(vals);
    setErrors(validationErrors);
    return Object.keys(validationErrors).length === 0;
  }, [validate]);
  
  const setFieldValue = useCallback((field: keyof T, value: any) => {
    setValues(prev => {
      const next = { ...prev, [field]: value };
      if (touched[field]) {
        runValidation(next);
      }
      return next;
    });
  }, [touched, runValidation]);
  
  const setFieldTouched = useCallback((field: keyof T) => {
    setTouched(prev => ({ ...prev, [field]: true }));
    runValidation(values);
  }, [values, runValidation]);
  
  const handleSubmit = useCallback(async (e: React.FormEvent) => {
    e.preventDefault();
    
    const allTouched = Object.keys(initialValues).reduce((acc, key) => ({
      ...acc, [key]: true
    }), {});
    setTouched(allTouched);
    
    if (!runValidation(values)) return;
    
    setIsSubmitting(true);
    try {
      await onSubmit(values);
    } finally {
      setIsSubmitting(false);
    }
  }, [values, initialValues, runValidation, onSubmit]);
  
  return {
    values,
    errors,
    touched,
    isSubmitting,
    setFieldValue,
    setFieldTouched,
    handleSubmit
  };
}

// FormField.tsx - 可复用表单项 - 35行
interface FormFieldProps {
  label: string;
  name: string;
  value: string;
  error?: string;
  touched?: boolean;
  onChange: (value: string) => void;
  onBlur: () => void;
  type?: string;
}

export function FormField({
  label,
  name,
  value,
  error,
  touched,
  onChange,
  onBlur,
  type = 'text'
}: FormFieldProps) {
  return (
    <div className="form-field">
      <label htmlFor={name}>{label}</label>
      <input
        id={name}
        name={name}
        type={type}
        value={value}
        onChange={e => onChange(e.target.value)}
        onBlur={onBlur}
        className={touched && error ? 'error' : ''}
      />
      {touched && error && <span className="error-text">{error}</span>}
    </div>
  );
}

// UserForm.tsx - 50行
import { useForm } from './useForm';
import { FormField } from './FormField';

interface UserFormData {
  name: string;
  email: string;
  phone: string;
}

const validateUser = (values: UserFormData) => {
  const errors: Partial<Record<keyof UserFormData, string>> = {};
  
  if (!values.name) errors.name = '姓名必填';
  if (!values.email) errors.email = '邮箱必填';
  else if (!/\S+@\S+\.\S+/.test(values.email)) {
    errors.email = '邮箱格式不正确';
  }
  if (!values.phone) errors.phone = '电话必填';
  
  return errors;
};

export function UserForm({ 
  onSubmit, 
  initialData 
}: { 
  onSubmit: (data: UserFormData) => Promise<void>;
  initialData?: Partial<UserFormData>;
}) {
  const form = useForm<UserFormData>({
    initialValues: {
      name: initialData?.name || '',
      email: initialData?.email || '',
      phone: initialData?.phone || ''
    },
    validate: validateUser,
    onSubmit
  });
  
  return (
    <form onSubmit={form.handleSubmit}>
      <FormField
        label="姓名"
        name="name"
        value={form.values.name}
        error={form.errors.name}
        touched={form.touched.name}
        onChange={value => form.setFieldValue('name', value)}
        onBlur={() => form.setFieldTouched('name')}
      />
      
      <FormField
        label="邮箱"
        name="email"
        type="email"
        value={form.values.email}
        error={form.errors.email}
        touched={form.touched.email}
        onChange={value => form.setFieldValue('email', value)}
        onBlur={() => form.setFieldTouched('email')}
      />
      
      <FormField
        label="电话"
        name="phone"
        type="tel"
        value={form.values.phone}
        error={form.errors.phone}
        touched={form.touched.phone}
        onChange={value => form.setFieldValue('phone', value)}
        onBlur={() => form.setFieldTouched('phone')}
      />
      
      <button type="submit" disabled={form.isSubmitting}>
        {form.isSubmitting ? '提交中...' : '提交'}
      </button>
    </form>
  );
}
```

**重构收益**：
- `useForm` Hook可在任何表单中复用
- `FormField`组件统一了表单字段的UI
- 验证逻辑独立，易于维护和扩展
- 表单组件从200行减少到50行

---

### 示例3：数据表格重构

#### 重构前

```typescript
// DataTable.tsx - 250行
function DataTable({ data, columns, onRowClick, onSort, onFilter }) {
  const [sortConfig, setSortConfig] = useState({ key: null, direction: 'asc' });
  const [filters, setFilters] = useState({});
  const [selectedRows, setSelectedRows] = useState(new Set());
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  
  // 排序逻辑 - 30行
  const sortedData = useMemo(() => {
    if (!sortConfig.key) return data;
    return [...data].sort((a, b) => {
      const aVal = a[sortConfig.key];
      const bVal = b[sortConfig.key];
      if (aVal < bVal) return sortConfig.direction === 'asc' ? -1 : 1;
      if (aVal > bVal) return sortConfig.direction === 'asc' ? 1 : -1;
      return 0;
    });
  }, [data, sortConfig]);
  
  // 过滤逻辑 - 40行
  const filteredData = useMemo(() => {
    return sortedData.filter(row => {
      return Object.entries(filters).every(([key, value]) => {
        if (!value) return true;
        return String(row[key]).toLowerCase().includes(String(value).toLowerCase());
      });
    });
  }, [sortedData, filters]);
  
  // 分页逻辑 - 25行
  const paginatedData = useMemo(() => {
    const start = (page - 1) * pageSize;
    return filteredData.slice(start, start + pageSize);
  }, [filteredData, page, pageSize]);
  
  const totalPages = Math.ceil(filteredData.length / pageSize);
  
  // 选择逻辑 - 35行
  const handleSelectAll = () => {
    if (selectedRows.size === paginatedData.length) {
      setSelectedRows(new Set());
    } else {
      setSelectedRows(new Set(paginatedData.map(row => row.id)));
    }
  };
  
  const handleSelectRow = (id) => {
    const newSelected = new Set(selectedRows);
    if (newSelected.has(id)) {
      newSelected.delete(id);
    } else {
      newSelected.add(id);
    }
    setSelectedRows(newSelected);
  };
  
  // 处理函数 - 40行
  const handleSort = (key) => {
    setSortConfig(prev => ({
      key,
      direction: prev.key === key && prev.direction === 'asc' ? 'desc' : 'asc'
    }));
    onSort?.(key);
  };
  
  const handleFilter = (key, value) => {
    setFilters(prev => ({ ...prev, [key]: value }));
    setPage(1);
    onFilter?.(key, value);
  };
  
  return (
    <div className="data-table">
      {/* 过滤栏 - 30行 */}
      <div className="table-filters">
        {columns.map(col => col.filterable && (
          <input
            key={col.key}
            placeholder={`过滤${col.title}`}
            onChange={e => handleFilter(col.key, e.target.value)}
          />
        ))}
      </div>
      
      {/* 表格 - 60行 */}
      <table>
        <thead>
          <tr>
            <th>
              <input 
                type="checkbox"
                checked={selectedRows.size === paginatedData.length}
                onChange={handleSelectAll}
              />
            </th>
            {columns.map(col => (
              <th key={col.key} onClick={() => col.sortable && handleSort(col.key)}>
                {col.title}
                {sortConfig.key === col.key && (
                  sortConfig.direction === 'asc' ? '↑' : '↓'
                )}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {paginatedData.map(row => (
            <tr 
              key={row.id}
              onClick={() => onRowClick?.(row)}
              className={selectedRows.has(row.id) ? 'selected' : ''}
            >
              <td>
                <input
                  type="checkbox"
                  checked={selectedRows.has(row.id)}
                  onChange={() => handleSelectRow(row.id)}
                />
              </td>
              {columns.map(col => (
                <td key={col.key}>
                  {col.render ? col.render(row[col.key], row) : row[col.key]}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
      
      {/* 分页 - 40行 */}
      <div className="pagination">
        <button onClick={() => setPage(1)} disabled={page === 1}>首页</button>
        <button onClick={() => setPage(p => p - 1)} disabled={page === 1}>上一页</button>
        <span>{page} / {totalPages}</span>
        <button onClick={() => setPage(p => p + 1)} disabled={page === totalPages}>下一页</button>
        <button onClick={() => setPage(totalPages)} disabled={page === totalPages}>末页</button>
        <select value={pageSize} onChange={e => setPageSize(Number(e.target.value))}>
          <option value={10}>10条/页</option>
          <option value={20}>20条/页</option>
          <option value={50}>50条/页</option>
        </select>
      </div>
    </div>
  );
}
```

#### 重构后

```typescript
// useTable.ts - 表格逻辑Hook - 80行
interface UseTableOptions<T> {
  data: T[];
  initialSort?: { key: keyof T; direction: 'asc' | 'desc' } | null;
  initialPageSize?: number;
}

export function useTable<T extends { id: string }>({
  data,
  initialSort = null,
  initialPageSize = 10
}: UseTableOptions<T>) {
  const [sortConfig, setSortConfig] = useState(initialSort);
  const [filters, setFilters] = useState<Record<string, string>>({});
  const [selectedRows, setSelectedRows] = useState<Set<string>>(new Set());
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(initialPageSize);
  
  const processedData = useMemo(() => {
    let result = [...data];
    
    // 过滤
    result = result.filter(row =>
      Object.entries(filters).every(([key, value]) => {
        if (!value) return true;
        return String(row[key as keyof T]).toLowerCase().includes(value.toLowerCase());
      })
    );
    
    // 排序
    if (sortConfig) {
      result.sort((a, b) => {
        const aVal = a[sortConfig.key];
        const bVal = b[sortConfig.key];
        if (aVal < bVal) return sortConfig.direction === 'asc' ? -1 : 1;
        if (aVal > bVal) return sortConfig.direction === 'asc' ? 1 : -1;
        return 0;
      });
    }
    
    return result;
  }, [data, filters, sortConfig]);
  
  const paginatedData = useMemo(() => {
    const start = (page - 1) * pageSize;
    return processedData.slice(start, start + pageSize);
  }, [processedData, page, pageSize]);
  
  const totalPages = Math.ceil(processedData.length / pageSize);
  
  const setSort = useCallback((key: keyof T) => {
    setSortConfig(prev => ({
      key,
      direction: prev?.key === key && prev.direction === 'asc' ? 'desc' : 'asc'
    }));
    setPage(1);
  }, []);
  
  const setFilter = useCallback((key: string, value: string) => {
    setFilters(prev => ({ ...prev, [key]: value }));
    setPage(1);
  }, []);
  
  const toggleSelectAll = useCallback(() => {
    setSelectedRows(prev => 
      prev.size === paginatedData.length
        ? new Set()
        : new Set(paginatedData.map(row => row.id))
    );
  }, [paginatedData]);
  
  const toggleSelectRow = useCallback((id: string) => {
    setSelectedRows(prev => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }, []);
  
  return {
    data: paginatedData,
    allData: processedData,
    sortConfig,
    selectedRows,
    page,
    pageSize,
    totalPages,
    setSort,
    setFilter,
    setPage,
    setPageSize,
    toggleSelectAll,
    toggleSelectRow
  };
}

// TableFilter.tsx - 30行
interface TableFilterProps {
  columns: Array<{ key: string; title: string; filterable?: boolean }>;
  onFilter: (key: string, value: string) => void;
}

export function TableFilter({ columns, onFilter }: TableFilterProps) {
  return (
    <div className="table-filters">
      {columns.filter(col => col.filterable).map(col => (
        <input
          key={col.key}
          placeholder={`过滤${col.title}`}
          onChange={e => onFilter(col.key, e.target.value)}
        />
      ))}
    </div>
  );
}

// TablePagination.tsx - 35行
interface TablePaginationProps {
  page: number;
  totalPages: number;
  pageSize: number;
  onPageChange: (page: number) => void;
  onPageSizeChange: (size: number) => void;
}

export function TablePagination({
  page,
  totalPages,
  pageSize,
  onPageChange,
  onPageSizeChange
}: TablePaginationProps) {
  return (
    <div className="pagination">
      <button onClick={() => onPageChange(1)} disabled={page === 1}>首页</button>
      <button onClick={() => onPageChange(page - 1)} disabled={page === 1}>上一页</button>
      <span>{page} / {totalPages}</span>
      <button onClick={() => onPageChange(page + 1)} disabled={page === totalPages}>下一页</button>
      <button onClick={() => onPageChange(totalPages)} disabled={page === totalPages}>末页</button>
      <select value={pageSize} onChange={e => onPageSizeChange(Number(e.target.value))}>
        <option value={10}>10条/页</option>
        <option value={20}>20条/页</option>
        <option value={50}>50条/页</option>
      </select>
    </div>
  );
}

// DataTable.tsx - 60行
import { useTable } from './useTable';
import { TableFilter } from './TableFilter';
import { TablePagination } from './TablePagination';

interface Column<T> {
  key: keyof T;
  title: string;
  sortable?: boolean;
  filterable?: boolean;
  render?: (value: any, row: T) => React.ReactNode;
}

interface DataTableProps<T> {
  data: T[];
  columns: Column<T>[];
  onRowClick?: (row: T) => void;
}

export function DataTable<T extends { id: string }>({
  data,
  columns,
  onRowClick
}: DataTableProps<T>) {
  const table = useTable<T>({ data });
  
  return (
    <div className="data-table">
      <TableFilter columns={columns} onFilter={table.setFilter} />
      
      <table>
        <thead>
          <tr>
            <th>
              <input 
                type="checkbox"
                checked={table.selectedRows.size === table.data.length && table.data.length > 0}
                onChange={table.toggleSelectAll}
              />
            </th>
            {columns.map(col => (
              <th 
                key={String(col.key)} 
                onClick={() => col.sortable && table.setSort(col.key)}
              >
                {col.title}
                {table.sortConfig?.key === col.key && (
                  table.sortConfig.direction === 'asc' ? '↑' : '↓'
                )}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {table.data.map(row => (
            <tr 
              key={row.id}
              onClick={() => onRowClick?.(row)}
              className={table.selectedRows.has(row.id) ? 'selected' : ''}
            >
              <td>
                <input
                  type="checkbox"
                  checked={table.selectedRows.has(row.id)}
                  onChange={() => table.toggleSelectRow(row.id)}
                />
              </td>
              {columns.map(col => (
                <td key={String(col.key)}>
                  {col.render 
                    ? col.render(row[col.key], row) 
                    : String(row[col.key])
                  }
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
      
      <TablePagination
        page={table.page}
        totalPages={table.totalPages}
        pageSize={table.pageSize}
        onPageChange={table.setPage}
        onPageSizeChange={table.setPageSize}
      />
    </div>
  );
}
```

**重构收益**：
- 表格逻辑完全抽离到`useTable` Hook
- 过滤和分页组件可独立复用
- 主组件从250行减少到60行
- 表格功能更容易测试和扩展

---

## 总结

组件抽离是React应用架构的核心技能。通过遵循本指南中的规则和最佳实践，可以：

1. **提高代码可维护性**：每个组件职责单一，易于理解和修改
2. **增强代码复用性**：抽离的组件和Hook可在多处使用
3. **改善测试体验**：小型组件更容易进行单元测试
4. **优化团队协作**：清晰的组件边界减少代码冲突

### 关键原则回顾

| 原则 | 说明 |
|-----|------|
| 单一职责 | 一个组件只做一件事 |
| 最小化Props | 只传递必要的props |
| 松耦合 | 组件间依赖最小化 |
| 可组合 | 支持灵活组合使用 |
| 可测试 | 易于编写单元测试 |

---

*文档版本: 1.0*
*最后更新: 2024年*
