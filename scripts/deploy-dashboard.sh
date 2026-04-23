#!/bin/bash
# 部署 Dashboard 监控仪表板

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${YELLOW}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }

echo "============================================================"
echo "  部署 OpenClaw Dashboard"
echo "============================================================"

# 1. 检查是否已存在
if [ -d "$HOME/git/openclaw-dashboard" ]; then
  info "Dashboard 已存在，跳过克隆"
else
  info "克隆 Dashboard 项目..."
  # 从本地复制（更快）
  if [ -d "/home/sbc/git/openclaw-dashboard" ]; then
    success "使用本地 Dashboard"
  else
    # 从 GitHub 克隆
    git clone https://github.com/subaochen/openclaw-dashboard.git "$HOME/git/openclaw-dashboard"
  fi
fi

# 2. 安装依赖
info "安装 Dashboard 依赖..."
cd "$HOME/git/openclaw-dashboard"
if [ -f "package.json" ]; then
  npm install --silent
  success "依赖安装完成"
else
  info "非 Node.js 项目，跳过 npm install"
fi

# 3. 配置环境变量
info "配置 Dashboard 环境变量..."
if ! grep -q "OPENCLAW_DASHBOARD" ~/.bashrc 2>/dev/null; then
  cat >> ~/.bashrc << 'EOF'

# OpenClaw Dashboard
export OPENCLAW_DASHBOARD="$HOME/git/openclaw-dashboard"
alias oc-dashboard='cd ~/git/openclaw-dashboard && npm start'
EOF
  success "环境变量已配置"
else
  info "环境变量已存在"
fi

# 4. 验证
info "验证 Dashboard..."
if [ -f "$HOME/git/openclaw-dashboard/dashboard/index.html" ]; then
  success "Dashboard 部署完成！"
  echo ""
  echo "🎯 下一步:"
  echo "   1. 重新加载环境变量：source ~/.bashrc"
  echo "   2. 启动 Dashboard: oc-dashboard"
  echo "   3. 访问：http://localhost:3000"
else
  echo "❌ Dashboard 部署失败，请检查日志"
  exit 1
fi
