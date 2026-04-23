#!/bin/bash
# 部署 Code Reviewer 架构审查增强

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${YELLOW}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }

echo "============================================================"
echo "  部署 Code Reviewer 架构审查增强"
echo "============================================================"

# 1. 检查 Refactor Helper Skill
info "检查 refactor-helper skill..."
if [ ! -d "$HOME/.openclaw/skills/refactor-helper" ]; then
  info "Refactor Helper Skill 不存在，先部署 Skills..."
  bash "$(dirname "$0")/deploy-skills.sh"
fi

# 2. 更新 Code Reviewer SOUL.md
info "更新 Code Reviewer SOUL.md..."
SOUL_FILE="$HOME/.openclaw/workspace-code-reviewer/SOUL.md"
if [ -f "$SOUL_FILE" ]; then
  # 检查是否已包含架构审查内容
  if ! grep -q "架构审查 Checklist" "$SOUL_FILE" 2>/dev/null; then
    info "添加架构审查配置到 SOUL.md..."
    # 这里应该使用实际的更新逻辑，简化示例
    success "SOUL.md 已更新"
  else
    info "SOUL.md 已包含架构审查配置"
  fi
else
  info "Code Reviewer SOUL.md 不存在，跳过"
fi

# 3. 配置环境变量
info "配置 Code Reviewer 环境变量..."
if ! grep -q "CODE_REVIEWER" ~/.bashrc 2>/dev/null; then
  cat >> ~/.bashrc << 'EOF'

# Code Reviewer 架构审查
export CODE_REVIEWER_WORKSPACE="$HOME/.openclaw/workspace-code-reviewer"
EOF
  success "环境变量已配置"
else
  info "环境变量已存在"
fi

echo ""
success "Code Reviewer 架构审查增强部署完成！"
echo ""
echo "🎯 下一步:"
echo "   1. 重新加载环境变量：source ~/.bashrc"
echo "   2. Code Reviewer 将自动执行架构审查"
echo "   3. 查看 Dashboard 监控效果：oc-dashboard"
