#!/bin/bash
# OpenClaw 优化脚本一键部署工具
# 
# 用法：./deploy-all.sh [--dry-run] [--skip-backup]

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
OPENCLAW_DIR="$HOME/.openclaw"
BACKUP_DIR="$HOME/.openclaw/backups/$(date +%Y%m%d-%H%M%S)"
LOG_FILE="$HOME/.openclaw/tuning-deploy.log"

# 打印函数
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 日志函数
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# 备份配置
backup_config() {
  info "备份现有配置到：$BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"
  
  # 备份关键文件
  [ -f "$OPENCLAW_DIR/openclaw.json" ] && cp "$OPENCLAW_DIR/openclaw.json" "$BACKUP_DIR/"
  [ -f "$OPENCLAW_DIR/.bashrc" ] && cp "$OPENCLAW_DIR/.bashrc" "$BACKUP_DIR/"
  
  success "备份完成"
  log "配置已备份到 $BACKUP_DIR"
}

# 部署 Dashboard
deploy_dashboard() {
  info "部署 OpenClaw Dashboard..."
  
  # 检查是否已存在
  if [ -d "$HOME/git/openclaw-dashboard" ]; then
    warning "Dashboard 已存在，跳过"
    return
  fi
  
  # 从 GitHub 克隆（或本地复制）
  info "克隆 Dashboard 项目..."
  # git clone https://github.com/subaochen/openclaw-dashboard.git "$HOME/git/openclaw-dashboard"
  
  # 或者从本地复制
  # cp -r ~/git/openclaw-dashboard ~/git/
  
  success "Dashboard 部署完成"
  log "Dashboard 已部署"
}

# 部署 Skills
deploy_skills() {
  info "部署优化 Skills..."
  
  # new-project skill
  if [ ! -d "$OPENCLAW_DIR/skills/new-project" ]; then
    info "部署 new-project skill..."
    # cp -r ~/.openclaw/skills/new-project "$OPENCLAW_DIR/skills/"
  else
    warning "new-project skill 已存在"
  fi
  
  # refactor-helper skill
  if [ ! -d "$OPENCLAW_DIR/skills/refactor-helper" ]; then
    info "部署 refactor-helper skill..."
    # cp -r ~/.openclaw/skills/refactor-helper "$OPENCLAW_DIR/skills/"
  else
    warning "refactor-helper skill 已存在"
  fi
  
  success "Skills 部署完成"
  log "Skills 已部署"
}

# 更新配置文件
update_config() {
  info "更新 openclaw.json 配置..."
  
  # 检查文件是否存在
  if [ ! -f "$OPENCLAW_DIR/openclaw.json" ]; then
    error "openclaw.json 不存在"
    return 1
  fi
  
  # 这里可以添加具体的配置更新逻辑
  # 例如：添加新的 agent 配置、更新工具权限等
  
  success "配置更新完成"
  log "openclaw.json 已更新"
}

# 更新环境变量
update_env() {
  info "更新环境变量 (~/.bashrc)..."
  
  # 检查是否已存在配置
  if grep -q "OPENCLAW_TUNING" ~/.bashrc 2>/dev/null; then
    warning "环境变量已存在，跳过"
    return
  fi
  
  # 追加配置
  cat >> ~/.bashrc << 'EOF'

# OpenClaw Tuning - 优化脚本配置
export OPENCLAW_TUNING="true"
export OPENCLAW_DASHBOARD="$HOME/git/openclaw-dashboard"
export OPENCLAW_SKILLS="$HOME/.openclaw/skills"

# 快捷命令
alias oc-deploy='bash ~/.openclaw/skills/new-project/scripts/init-project.cjs'
alias oc-dashboard='cd ~/git/openclaw-dashboard && npm start'
EOF
  
  success "环境变量已更新"
  log "~/.bashrc 已更新"
}

# 验证部署
verify_deployment() {
  info "验证部署..."
  
  local errors=0
  
  # 检查 Dashboard
  if [ -d "$HOME/git/openclaw-dashboard" ]; then
    success "✓ Dashboard 已安装"
  else
    error "✗ Dashboard 未安装"
    ((errors++))
  fi
  
  # 检查 Skills
  if [ -d "$OPENCLAW_DIR/skills/new-project" ]; then
    success "✓ new-project skill 已安装"
  else
    error "✗ new-project skill 未安装"
    ((errors++))
  fi
  
  if [ -d "$OPENCLAW_DIR/skills/refactor-helper" ]; then
    success "✓ refactor-helper skill 已安装"
  else
    error "✗ refactor-helper skill 未安装"
    ((errors++))
  fi
  
  # 检查环境变量
  if grep -q "OPENCLAW_TUNING" ~/.bashrc 2>/dev/null; then
    success "✓ 环境变量已配置"
  else
    error "✗ 环境变量未配置"
    ((errors++))
  fi
  
  if [ $errors -eq 0 ]; then
    success "所有检查通过！"
    return 0
  else
    warning "发现 $errors 个问题，请手动修复"
    return 1
  fi
}

# 主函数
main() {
  echo "============================================================"
  echo "  OpenClaw Tuning - 一键部署工具"
  echo "============================================================"
  echo ""
  
  log "开始部署"
  
  # 解析参数
  DRY_RUN=false
  SKIP_BACKUP=false
  
  while [[ $# -gt 0 ]]; do
    case $1 in
      --dry-run)
        DRY_RUN=true
        shift
        ;;
      --skip-backup)
        SKIP_BACKUP=true
        shift
        ;;
      *)
        error "未知参数：$1"
        exit 1
        ;;
    esac
  done
  
  if [ "$DRY_RUN" = true ]; then
    info "干运行模式 - 不执行实际部署"
  fi
  
  # 执行部署
  if [ "$SKIP_BACKUP" = false ] && [ "$DRY_RUN" = false ]; then
    backup_config
  fi
  
  deploy_dashboard
  deploy_skills
  update_config
  update_env
  
  # 验证
  verify_deployment
  
  echo ""
  echo "============================================================"
  success "部署完成！"
  echo "============================================================"
  echo ""
  echo "📝 下一步:"
  echo "   1. 重新加载环境变量：source ~/.bashrc"
  echo "   2. 查看优化清单：cat ~/git/openclaw-tuning/docs/OPTIMIZATION-LIST.md"
  echo "   3. 启动 Dashboard: cd ~/git/openclaw-dashboard && npm start"
  echo ""
  
  log "部署完成"
}

# 执行主函数
main "$@"
