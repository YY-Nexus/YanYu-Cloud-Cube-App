#!/usr/bin/env bash
# filepath: scripts/auto-fix-pnpm-lock-conflicts.sh

# 自动处理各种文件中的合并冲突，智能合并依赖和配置

set -euo pipefail

# 配置
LOCK_FILE="pnpm-lock.yaml"
BACKUP_DIR=".conflict-backups"
LOG_FILE="conflict-resolution.log"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日志函数
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$LOG_FILE"
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
    log "[INFO] $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    log "[WARN] $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    log "[ERROR] $1"
}

# 创建备份目录
create_backup_dir() {
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        log_info "创建备份目录: $BACKUP_DIR"
    fi
}

# 备份文件
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        local backup_file="$BACKUP_DIR/$(basename "$file").$(date +%Y%m%d_%H%M%S).bak"
        cp "$file" "$backup_file"
        log_info "备份文件: $file -> $backup_file"
    fi
}

# 检测操作系统并设置sed命令
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        SED_CMD="sed -i ''"
    else
        SED_CMD="sed -i"
    fi
}

# 修复pnpm-lock.yaml中的重复键和冲突
fix_pnpm_lockfile() {
    local file="$1"
    log_info "智能修复lockfile: $file"
    
    # 检查是否有明显的语法错误或重复键
    if grep -q "duplicated mapping key" <(pnpm install 2>&1) || 
       grep -q "<<<<<<< \|======\|>>>>>>> " "$file"; then
        log_warn "检测到严重的lockfile损坏，将重新生成"
        backup_file "$file"
        rm -f "$file"
        log_info "重新生成干净的lockfile..."
        if pnpm install; then
            log_info "成功重新生成lockfile"
        else
            log_error "重新生成lockfile失败"
            return 1
        fi
    elif command -v python3 >/dev/null 2>&1; then
        python3 scripts/fix-pnpm-lockfile.py "$file"
    else
        log_warn "Python3未找到，使用基础修复方法"
        remove_conflict_markers "$file"
    fi
}

# 删除冲突标记
remove_conflict_markers() {
    local file="$1"
    log_info "删除冲突标记: $file"
    
    eval "$SED_CMD '/^<<<<<<< /d;/^=======/d;/^>>>>>>> /d' \"$file\""
}

# 智能合并package.json依赖
merge_package_json_conflicts() {
    local file="$1"
    if [ ! -f "$file" ]; then
        return
    fi
    
    log_info "智能合并package.json依赖: $file"
    
    # 检查是否有冲突标记
    if grep -q "<<<<<<< \|======\|>>>>>>> " "$file"; then
        backup_file "$file"
        
        # 先简单移除冲突标记，保留所有内容
        remove_conflict_markers "$file"
        
        # 尝试验证和修复JSON
        if command -v python3 >/dev/null 2>&1; then
            python3 -c "
import json
import sys

try:
    with open('$file', 'r') as f:
        content = f.read()
    
    # 尝试解析JSON
    try:
        data = json.loads(content)
        # 如果解析成功，重新格式化并写回
        with open('$file', 'w') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print('成功修复package.json冲突')
    except json.JSONDecodeError:
        # 如果JSON无效，只移除冲突标记
        print('JSON格式无效，仅移除冲突标记')
        
except Exception as e:
    print(f'修复package.json失败: {e}')
    sys.exit(1)
"
        else
            log_warn "Python3不可用，仅移除冲突标记"
        fi
    fi
}

# 主要的冲突解决函数
resolve_conflicts() {
    local file="$1"
    local file_ext="${file##*.}"
    
    if [ ! -f "$file" ]; then
        log_warn "文件不存在: $file"
        return 1
    fi
    
    # 检查是否有冲突标记
    if ! grep -q "<<<<<<< \|======\|>>>>>>> " "$file"; then
        log_info "文件无冲突标记: $file"
        return 0
    fi
    
    log_info "发现冲突，开始处理: $file"
    backup_file "$file"
    
    case "$file_ext" in
        "yaml"|"yml")
            if [[ "$file" == *"pnpm-lock.yaml" ]]; then
                fix_pnpm_lockfile "$file"
            else
                remove_conflict_markers "$file"
            fi
            ;;
        "json")
            if [[ "$file" == *"package.json" ]]; then
                merge_package_json_conflicts "$file"
            else
                remove_conflict_markers "$file"
            fi
            ;;
        *)
            remove_conflict_markers "$file"
            ;;
    esac
    
    log_info "完成冲突处理: $file"
}

# 主函数
main() {
    log_info "开始自动冲突解决..."
    
    create_backup_dir
    detect_os
    
    # 处理主要的锁文件
    if [ -f "$LOCK_FILE" ]; then
        resolve_conflicts "$LOCK_FILE"
    else
        log_warn "未找到 $LOCK_FILE"
    fi
    
    # 处理工作区中的package.json文件
    find . -name "package.json" -not -path "./node_modules/*" -not -path "./$BACKUP_DIR/*" | while read -r pkg_file; do
        resolve_conflicts "$pkg_file"
    done
    
    # 处理其他常见的配置文件
    for config_file in tsconfig.json .eslintrc.json .eslintrc.cjs turbo.json renovate.json; do
        if [ -f "$config_file" ]; then
            resolve_conflicts "$config_file"
        fi
    done
    
    # 重新安装依赖以验证修复
    if [ -f "$LOCK_FILE" ] && command -v pnpm >/dev/null 2>&1; then
        log_info "重新安装依赖以验证修复..."
        if pnpm install; then
            log_info "依赖安装成功，冲突解决完成"
        else
            log_error "依赖安装失败，可能还有未解决的冲突"
            exit 1
        fi
    fi
    
    log_info "冲突解决完成！"
    log_info "备份文件位于: $BACKUP_DIR"
    log_info "日志文件: $LOG_FILE"
}

# 运行主函数
main "$@"