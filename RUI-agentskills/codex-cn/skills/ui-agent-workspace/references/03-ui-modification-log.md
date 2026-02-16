# UI 修改记录协议

## 概述

UI修改记录协议定义了如何结构化、标准化地记录每一次UI变更。所有修改必须以Markdown格式记录，包含完整的上下文信息。

## 日志文件位置

- **主日志**: `logs/CHANGELOG.md`
- **归档日志**: `logs/archive/CHANGELOG_YYYY-MM.md`
- **临时记录**: `.workspace/sessions/session_xxx.json`

## 修改类型定义

| 类型代码 | 含义 | 适用场景 |
|----------|------|----------|
| `add` | 新增 | 新组件、新页面、新样式 |
| `remove` | 删除 | 移除组件、清理样式 |
| `modify` | 修改 | 样式调整、布局变更 |
| `refactor` | 重构 | 代码结构优化，外观不变 |
| `fix` | 修复 | 修复UI问题 |
| `update` | 更新 | 依赖升级导致的变更 |

## 记录格式规范

### 标准修改条目

```markdown
<!-- @ui-modify:{id} -->
### [{类型}] {简短描述}

**修改ID**: mod_{timestamp}_{sequence}  
**时间**: YYYY-MM-DD HH:MM  
**会话**: session_xxx  
**Agent**: {agent_name}

#### 用户意图
> {用户原始请求或意图描述}

#### 影响范围
- **文件**: `src/components/Button.tsx`
- **组件**: Button
- **样式**: border-radius, padding
- **布局**: 无

#### 视觉变更

**修改前**:
```
┌─────────────────┐
│     按钮        │  ← 直角，4px圆角
└─────────────────┘
```

**修改后**:
```
┌─────────────────┐
╭─────────────────╮
│     按钮        │  ← 圆角，12px圆角
╰─────────────────╯
└─────────────────┘
```

#### 代码变更

**Before**:
```tsx
// src/components/Button.tsx (Line 15-18)
const buttonStyles = {
  borderRadius: '4px',
  padding: '8px 16px'
};
```

**After**:
```tsx
// src/components/Button.tsx (Line 15-18)
const buttonStyles = {
  borderRadius: '12px',  // ← 修改: 4px → 12px
  padding: '10px 20px'   // ← 修改: 同步调整内边距
};
```

#### 设计决策
- **原因**: 用户要求更现代的圆角风格
- **参考**: Material Design 3 规范
- **权衡**: 圆角增大可能减少按钮的"可点击"感知，通过阴影补偿

#### 验证状态
- [x] 画布已更新
- [x] 代码已实现
- [x] 视觉检查通过
- [ ] 响应式测试

#### 关联引用
- 画布: [canvas/components/button.md](canvas/components/button.md)
- 设计系统: [docs/design-system.md#button](docs/design-system.md#button)
<!-- @ui-modify:{id}:end -->
```

## 特殊场景记录

### 批量修改

```markdown
<!-- @ui-modify:batch -->
### [batch] 统一调整间距系统

**修改ID**: mod_20260216_001_batch  
**涉及文件**: 12个

#### 批量规则
```
原值      →    新值
4px       →    4px   (保持)
8px       →    8px   (保持)
12px      →    16px  (调整)
16px      →    16px  (保持)
20px      →    24px  (调整)
```

#### 影响文件清单
| 文件 | 原值 | 新值 | 组件 |
|------|------|------|------|
| Button.tsx | 12px | 16px | Button |
| Card.tsx | 20px | 24px | Card |
| ... | ... | ... | ... |

#### 批量原因
统一使用4的倍数作为间距基准，提升设计一致性。
<!-- @ui-modify:batch:end -->
```

### 回滚记录

```markdown
<!-- @ui-modify:rollback -->
### [rollback] 回滚: 按钮圆角修改

**回滚ID**: rollback_20260216_002  
**回滚目标**: mod_20260216_001  
**原因**: 圆角过大，与整体风格不符

#### 回滚内容
- 恢复 `borderRadius: '12px'` → `'4px'`
- 恢复 `padding: '10px 20px'` → `'8px 16px'`

#### 经验教训
圆角调整需考虑整体设计语言一致性，建议先在小范围测试。
<!-- @ui-modify:rollback:end -->
```

### 实验性修改

```markdown
<!-- @ui-modify:experimental -->
### [experimental] 尝试: 玻璃拟态效果

**实验ID**: exp_20260216_003  
**状态**: 草稿 / 待评审

#### 实验内容
为Card组件添加玻璃拟态（Glassmorphism）效果。

#### 预期效果
```
┌─────────────────────────────┐
│  ████████████████████████   │ ← 背景模糊
│  █                      █   │
│  █     卡片内容          █   │
│  █                      █   │
│  ████████████████████████   │
└─────────────────────────────┘
```

#### 技术方案
```css
.glass-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}
```

#### 评审意见
- [ ] 性能影响评估
- [ ] 浏览器兼容性检查
- [ ] 无障碍访问验证
<!-- @ui-modify:experimental:end -->
```

## 自动化标记

### 状态标记

```markdown
<!-- @status:draft -->     <!-- 草稿状态 -->
<!-- @status:review -->    <!-- 待评审 -->
<!-- @status:approved -->  <!-- 已批准 -->
<!-- @status:implemented --> <!-- 已实现 -->
<!-- @status:verified -->  <!-- 已验证 -->
```

### 优先级标记

```markdown
<!-- @priority:critical -->  <!-- 阻塞性问题 -->
<!-- @priority:high -->      <!-- 重要 -->
<!-- @priority:medium -->    <!-- 一般 -->
<!-- @priority:low -->       <!-- 可延后 -->
```

### 影响范围标记

```markdown
<!-- @scope:global -->      <!-- 全局影响 -->
<!-- @scope:page -->        <!-- 页面级 -->
<!-- @scope:component -->   <!-- 组件级 -->
<!-- @scope:style -->       <!-- 仅样式 -->
```

## 日志组织

### CHANGELOG.md 结构

```markdown
# 修改日志

## [未发布]

### 2026-02-16
<!-- 当日修改按时间倒序排列 -->

#### 15:30 - [modify] 调整按钮圆角
...

#### 14:20 - [add] 新增Card组件
...

### 2026-02-15
...

## [1.0.0] - 2026-02-10
### 发布版本归档
...
```

## 最佳实践

1. **即时记录**: 修改完成后立即记录，不要批量补录
2. **完整上下文**: 包含"为什么"而不仅是"做了什么"
3. **视觉化**: 用ASCII/Mermaid展示视觉变化
4. **可追溯**: 每个修改都有唯一ID，便于回滚
5. **关联引用**: 链接到相关画布、设计文档
6. **状态明确**: 使用状态标记清晰表达当前进度
