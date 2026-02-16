# Workspace 管理规范

## 目录结构标准

每个Workspace必须遵循以下目录结构：

```
my-project-workspace/
├── .workspace/                    # 工作空间元数据（隐藏目录）
│   ├── config.json               # 工作空间配置
│   ├── state.json                # 当前状态快照
│   ├── index.json                # 文件索引
│   └── sessions/                 # 会话历史
│       ├── session_001.json
│       └── session_002.json
│
├── canvas/                        # 画布文件目录
│   ├── overview.md               # 项目总览画布
│   ├── pages/                    # 页面画布
│   │   ├── home.md
│   │   └── dashboard.md
│   └── components/               # 组件画布
│       ├── button.md
│       └── card.md
│
├── docs/                          # 文档目录
│   ├── requirements.md           # 需求文档
│   ├── design-system.md          # 设计系统
│   └── decisions.md              # 决策记录
│
├── src/                           # 源代码（可选，可指向外部项目）
├── logs/                          # 修改日志
│   ├── CHANGELOG.md              # 主变更日志
│   └── archive/                  # 归档日志
│
└── README.md                      # 工作空间说明
```

## 配置文件规范

### config.json

```json
{
  "workspace": {
    "name": "my-project",
    "version": "1.0.0",
    "created_at": "2026-02-16T10:00:00Z",
    "updated_at": "2026-02-16T15:30:00Z"
  },
  "project": {
    "type": "webapp",
    "framework": "react",
    "ui_library": "tailwind",
    "source_path": "./src"
  },
  "agents": {
    "designer": {
      "enabled": true,
      "canvas_format": "mermaid"
    },
    "developer": {
      "enabled": true,
      "code_style": "functional"
    },
    "reviewer": {
      "enabled": true,
      "auto_check": true
    }
  },
  "logging": {
    "level": "detailed",
    "auto_save": true,
    "max_sessions": 100
  }
}
```

### state.json

```json
{
  "current_session": "session_003",
  "active_files": [
    "src/components/Button.tsx",
    "src/pages/Home.tsx"
  ],
  "pending_changes": [
    {
      "file": "src/components/Button.tsx",
      "type": "modify",
      "status": "draft"
    }
  ],
  "canvas_focus": {
    "page": "home",
    "component": "Button",
    "zoom": 100
  },
  "context": {
    "last_user_intent": "修改按钮样式",
    "current_task": "更新Button组件圆角",
    "references": ["docs/design-system.md#button"]
  }
}
```

## Workspace操作命令

### 初始化Workspace

```markdown
<!-- @workspace:init -->
## 初始化工作空间

**项目**: my-project  
**类型**: React Web应用  
**技术栈**: React + TypeScript + Tailwind CSS

### 目录结构
```
[生成的目录树]
```

### 初始配置
```json
[config.json内容]
```
<!-- @workspace:init:end -->
```

### 保存状态

```markdown
<!-- @workspace:save -->
## 状态保存: 2026-02-16 15:30

**会话**: session_003  
**操作**: 完成Button组件圆角修改

### 变更摘要
- 修改: src/components/Button.tsx
- 更新: canvas/components/button.md
- 记录: logs/CHANGELOG.md

### 快照
```json
{
  "files_hash": "a1b2c3d4",
  "canvas_state": "updated",
  "pending": []
}
```
<!-- @workspace:save:end -->
```

### 切换上下文

```markdown
<!-- @workspace:context -->
## 上下文切换

**从**: Button组件开发  
**到**: Dashboard页面布局

### 保留上下文
- Button组件配置（已完成）
- 设计系统变量

### 新上下文
- Dashboard网格布局
- 数据卡片组件
- 响应式断点
<!-- @workspace:context:end -->
```

## 会话管理

### 会话文件格式 (sessions/session_xxx.json)

```json
{
  "session_id": "session_003",
  "started_at": "2026-02-16T14:00:00Z",
  "ended_at": "2026-02-16T15:30:00Z",
  "user_requests": [
    {
      "timestamp": "2026-02-16T14:05:00Z",
      "content": "修改按钮为圆角样式",
      "intent": "ui_modify",
      "entities": {
        "component": "Button",
        "property": "borderRadius"
      }
    }
  ],
  "agent_actions": [
    {
      "timestamp": "2026-02-16T14:06:00Z",
      "agent": "designer",
      "action": "update_canvas",
      "target": "canvas/components/button.md",
      "details": "更新按钮样式图示"
    },
    {
      "timestamp": "2026-02-16T14:08:00Z",
      "agent": "developer",
      "action": "modify_code",
      "target": "src/components/Button.tsx",
      "details": "修改border-radius为12px"
    }
  ],
  "outputs": [
    {
      "type": "canvas",
      "path": "canvas/components/button.md"
    },
    {
      "type": "code",
      "path": "src/components/Button.tsx"
    },
    {
      "type": "log",
      "path": "logs/CHANGELOG.md"
    }
  ]
}
```

## 文件索引 (index.json)

```json
{
  "indexed_at": "2026-02-16T15:30:00Z",
  "files": {
    "canvas": {
      "overview": "canvas/overview.md",
      "pages": {
        "home": "canvas/pages/home.md",
        "dashboard": "canvas/pages/dashboard.md"
      },
      "components": {
        "button": "canvas/components/button.md",
        "card": "canvas/components/card.md"
      }
    },
    "docs": {
      "requirements": "docs/requirements.md",
      "design_system": "docs/design-system.md"
    },
    "logs": {
      "changelog": "logs/CHANGELOG.md"
    }
  },
  "relationships": [
    {
      "from": "canvas/components/button.md",
      "to": "src/components/Button.tsx",
      "type": "implements"
    },
    {
      "from": "docs/design-system.md",
      "to": "canvas/components/button.md",
      "type": "guides"
    }
  ]
}
```

## 最佳实践

1. **定期保存**: 每完成一个任务单元就执行workspace:save
2. **清晰命名**: 会话ID使用递增序号，文件命名语义化
3. **及时归档**: 超过50条的日志移至archive目录
4. **索引同步**: 文件增删后更新index.json
5. **状态快照**: 关键节点创建完整状态备份
