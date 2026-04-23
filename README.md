# OpenClaw Tuning - 优化脚本集合

🚀 **一键部署 OpenClaw 所有优化，避免重复配置**

---

## 🎯 项目目标

1. **集中管理** - 收集所有 OpenClaw 优化脚本
2. **一键部署** - 新环境快速复用，避免手动配置
3. **版本控制** - 记录每次优化的时间和内容
4. **易于移植** - 升级/迁移时一键恢复

---

## 📦 包含的优化

### 1. Dashboard 监控仪表板
- **功能**: 缓存命中率监控 + Code Reviewer 架构审查监控
- **位置**: `~/git/openclaw-dashboard/`
- **部署**: 自动克隆 + 配置环境变量

### 2. New Project Skill
- **功能**: 自动创建新项目（GitHub + 飞书表格 + SOUL 文件）
- **位置**: `~/.openclaw/skills/new-project/`
- **部署**: 复制 Skill 文件 + 更新配置

### 3. Code Reviewer 增强
- **功能**: 架构审查 + 重构建议
- **位置**: `~/.openclaw/workspace-code-reviewer/`
- **部署**: 更新 SOUL.md + 创建 refactor-helper skill

### 4. 飞书集成优化
- **功能**: 图片 Token 检查 + 消息优化
- **位置**: `~/.openclaw/extensions/openclaw-lark/`
- **部署**: 更新扩展配置

### 5. 环境变量配置
- **功能**: API Keys + 工具路径 + 快捷命令
- **位置**: `~/.bashrc`
- **部署**: 追加配置

---

## 🚀 快速开始

### 一键部署所有优化

```bash
cd ~/git/openclaw-tuning
./scripts/deploy-all.sh
```

### 部署后

```bash
# 1. 重新加载环境变量
source ~/.bashrc

# 2. 验证部署
./scripts/deploy-all.sh --verify

# 3. 启动 Dashboard
oc-dashboard

# 4. 创建新项目
oc-deploy --name "my-project"
```

---

## 📋 部署脚本

### deploy-all.sh - 一键部署所有

```bash
./scripts/deploy-all.sh [选项]

选项:
  --dry-run       干运行，不实际部署
  --skip-backup   跳过备份
  --verify        只验证，不部署
```

### deploy-dashboard.sh - 只部署 Dashboard

```bash
./scripts/deploy-dashboard.sh
```

### deploy-skills.sh - 只部署 Skills

```bash
./scripts/deploy-skills.sh
```

### backup-config.sh - 备份配置

```bash
./scripts/backup-config.sh
```

---

## 📁 项目结构

```
openclaw-tuning/
├── README.md                    # 本文件
├── package.json                 # Node.js 配置
├── scripts/
│   ├── deploy-all.sh            # 一键部署所有
│   ├── deploy-dashboard.sh      # 部署 Dashboard
│   ├── deploy-skills.sh         # 部署 Skills
│   └── backup-config.sh         # 备份配置
├── configs/
│   ├── openclaw.json.example    # 配置示例
│   └── .bashrc.example          # 环境变量示例
├── docs/
│   ├── OPTIMIZATION-LIST.md     # 优化清单
│   ├── DEPLOYMENT-GUIDE.md      # 部署指南
│   └── TROUBLESHOOTING.md       # 故障排查
└── logs/
    └── deploy.log               # 部署日志
```

---

## 🔧 快捷命令

部署后自动添加以下别名：

```bash
# 部署新项目
oc-deploy --name "xyz"

# 启动 Dashboard
oc-dashboard

# 备份配置
oc-backup

# 查看优化清单
oc-tuning-list
```

---

## 📊 优化清单

详见：[docs/OPTIMIZATION-LIST.md](docs/OPTIMIZATION-LIST.md)

| 优化名称 | 日期 | 类型 | 状态 |
|---------|------|------|------|
| Dashboard 监控 | 2026-04-23 | 监控 | ✅ 已部署 |
| New Project Skill | 2026-04-23 | 工具 | ✅ 已部署 |
| Code Reviewer 增强 | 2026-04-23 | 审查 | ✅ 已部署 |

---

## 🐛 故障排查

### 问题 1: 环境变量未生效

**解决**:
```bash
source ~/.bashrc
```

### 问题 2: Dashboard 无法启动

**解决**:
```bash
cd ~/git/openclaw-dashboard
npm install
npm start
```

### 问题 3: Skill 不工作

**解决**:
```bash
# 检查 Skill 是否存在
ls -la ~/.openclaw/skills/new-project/

# 重新加载 OpenClaw
openclaw restart
```

---

## 📝 更新日志

### 2026-04-23
- ✅ 创建项目
- ✅ 添加 deploy-all.sh 脚本
- ✅ 部署 Dashboard
- ✅ 部署 New Project Skill
- ✅ 部署 Code Reviewer 增强

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

## 📄 License

MIT
