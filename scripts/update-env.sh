#!/bin/bash
# 更新环境变量

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${YELLOW}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }

echo "============================================================"
echo "  更新环境变量 (~/.bashrc)"
echo "============================================================"

# 备份现有配置
BACKUP_FILE="$HOME/.bashrc.backup.$(date +%Y%m%d-%H%M%S)"
cp ~/.bashrc "$BACKUP_FILE"
info "已备份 ~/.bashrc 到 $BACKUP_FILE"

# 添加 OpenClaw 配置
info "添加 OpenClaw 配置..."
cat >> ~/.bashrc << 'EOF'

# ============================================
# OpenClaw Tuning - 优化脚本配置
# ============================================

# 工作空间
export OPENCLAW_DIR="$HOME/.openclaw"
export OPENCLAW_WORKSPACE="$OPENCLAW_DIR/workspace"

# Dashboard
export OPENCLAW_DASHBOARD="$HOME/git/openclaw-dashboard"

# Skills
export OPENCLAW_SKILLS="$OPENCLAW_DIR/skills"

# Code Reviewer
export CODE_REVIEWER_WORKSPACE="$OPENCLAW_DIR/workspace-code-reviewer"

# 飞书配置
export FEISHU_APP_ID="cli_a94e22b02038dbb7"
# export FEISHU_APP_SECRET="xxx"  # 请手动填写

# ============================================
# 快捷命令
# ============================================

# 部署新项目
alias oc-deploy='node ~/.openclaw/skills/new-project/scripts/init-project.cjs'

# 启动 Dashboard
alias oc-dashboard='cd ~/git/openclaw-dashboard && npm start'

# 备份配置
alias oc-backup='bash ~/.openclaw/skills/new-project/scripts/backup-config.sh'

# 查看优化清单
alias oc-tuning-list='cat ~/git/openclaw-tuning/docs/OPTIMIZATION-LIST.md'

# 重新加载配置
alias oc-reload='source ~/.bashrc'

EOF

success "环境变量已更新"

echo ""
echo "🎯 下一步:"
echo "   重新加载环境变量：source ~/.bashrc"
echo ""
echo "📝 可用的快捷命令:"
echo "   oc-deploy      - 部署新项目"
echo "   oc-dashboard   - 启动 Dashboard"
echo "   oc-backup      - 备份配置"
echo "   oc-tuning-list - 查看优化清单"
echo "   oc-reload      - 重新加载配置"
