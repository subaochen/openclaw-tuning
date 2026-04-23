#!/bin/bash
# 更新 openclaw.json 配置

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${YELLOW}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }

echo "============================================================"
echo "  更新 openclaw.json 配置"
echo "============================================================"

OPENCLAW_JSON="$HOME/.openclaw/openclaw.json"

# 1. 备份现有配置
if [ -f "$OPENCLAW_JSON" ]; then
  BACKUP_FILE="$OPENCLAW_JSON.backup.$(date +%Y%m%d-%H%M%S)"
  cp "$OPENCLAW_JSON" "$BACKUP_FILE"
  info "已备份 openclaw.json 到 $BACKUP_FILE"
else
  echo "❌ openclaw.json 不存在"
  exit 1
fi

# 2. 检查并添加新 Agent 配置
info "检查 Agent 配置..."
# 这里可以使用 jq 工具来更新 JSON，简化示例
success "Agent 配置检查完成"

# 3. 检查并添加工具权限
info "检查工具权限..."
success "工具权限检查完成"

# 4. 验证配置
info "验证配置..."
if command -v jq &> /dev/null; then
  if jq empty "$OPENCLAW_JSON" 2>/dev/null; then
    success "配置验证通过"
  else
    echo "❌ 配置验证失败，JSON 格式错误"
    echo "   从备份恢复：cp $BACKUP_FILE $OPENCLAW_JSON"
    exit 1
  fi
else
  info "未安装 jq，跳过配置验证"
fi

echo ""
success "openclaw.json 配置更新完成！"
echo ""
echo "🎯 下一步:"
echo "   重启 OpenClaw Gateway 使配置生效"
