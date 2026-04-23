#!/bin/bash
# 部署飞书集成优化

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${YELLOW}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }

echo "============================================================"
echo "  部署飞书集成优化"
echo "============================================================"

# 1. 图片 Token 检查
info "检查图片 Token 检查模块..."
TOKEN_GUARD="$HOME/.openclaw/extensions/openclaw-lark/src/middleware/image-token-guard.js"
if [ -f "$TOKEN_GUARD" ]; then
  success "图片 Token 检查已部署"
else
  info "图片 Token 检查未部署，需要手动安装"
  echo "   请参考：~/.openclaw/extensions/openclaw-lark/IMAGE-TOKEN-GUARD.md"
fi

# 2. CNKI 插件错误处理
info "检查 CNKI 插件..."
CNKI_PLUGIN="$HOME/.openclaw/skills/cnki-thesis-review/"
if [ -d "$CNKI_PLUGIN" ]; then
  success "CNKI 插件已安装"
else
  info "CNKI 插件未安装"
fi

# 3. 配置环境变量
info "配置飞书环境变量..."
if ! grep -q "FEISHU_APP_ID" ~/.bashrc 2>/dev/null; then
  cat >> ~/.bashrc << 'EOF'

# 飞书开放平台配置
export FEISHU_APP_ID="cli_a94e22b02038dbb7"
# export FEISHU_APP_SECRET="xxx"  # 请手动填写
EOF
  success "飞书环境变量已配置（请手动填写 SECRET）"
else
  info "飞书环境变量已存在"
fi

echo ""
success "飞书集成优化部署完成！"
echo ""
echo "🎯 下一步:"
echo "   1. 重新加载环境变量：source ~/.bashrc"
echo "   2. 手动填写 FEISHU_APP_SECRET"
echo "   3. 重启 OpenClaw Gateway"
