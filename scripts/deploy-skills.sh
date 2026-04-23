#!/bin/bash
# 部署所有优化 Skills

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${YELLOW}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }

echo "============================================================"
echo "  部署 OpenClaw Skills"
echo "============================================================"

OPENCLAW_DIR="$HOME/.openclaw"

# 1. New Project Skill
info "部署 new-project skill..."
if [ ! -d "$OPENCLAW_DIR/skills/new-project" ]; then
  if [ -d "/home/sbc/.openclaw/skills/new-project" ]; then
    cp -r "/home/sbc/.openclaw/skills/new-project" "$OPENCLAW_DIR/skills/"
    success "new-project skill 已部署"
  fi
else
  info "new-project skill 已存在"
fi

# 2. Refactor Helper Skill
info "部署 refactor-helper skill..."
if [ ! -d "$OPENCLAW_DIR/skills/refactor-helper" ]; then
  if [ -d "/home/sbc/.openclaw/skills/refactor-helper" ]; then
    cp -r "/home/sbc/.openclaw/skills/refactor-helper" "$OPENCLAW_DIR/skills/"
    success "refactor-helper skill 已部署"
  fi
else
  info "refactor-helper skill 已存在"
fi

# 3. Agent Article Writer Skill
info "部署 agent-article-writer skill..."
if [ ! -d "$OPENCLAW_DIR/skills/agent-article-writer" ]; then
  if [ -d "/home/sbc/.openclaw/skills/agent-article-writer" ]; then
    cp -r "/home/sbc/.openclaw/skills/agent-article-writer" "$OPENCLAW_DIR/skills/"
    success "agent-article-writer skill 已部署"
  fi
else
  info "agent-article-writer skill 已存在"
fi

# 4. 配置环境变量
info "配置 Skills 环境变量..."
if ! grep -q "OPENCLAW_SKILLS" ~/.bashrc 2>/dev/null; then
  cat >> ~/.bashrc << 'EOF'

# OpenClaw Skills
export OPENCLAW_SKILLS="$HOME/.openclaw/skills"
alias oc-deploy='node ~/.openclaw/skills/new-project/scripts/init-project.cjs'
EOF
  success "环境变量已配置"
else
  info "环境变量已存在"
fi

echo ""
success "所有 Skills 部署完成！"
echo ""
echo "🎯 下一步:"
echo "   1. 重新加载环境变量：source ~/.bashrc"
echo "   2. 创建新项目：oc-deploy --name \"my-project\""
echo "   3. 查看 Skills: ls ~/.openclaw/skills/"
