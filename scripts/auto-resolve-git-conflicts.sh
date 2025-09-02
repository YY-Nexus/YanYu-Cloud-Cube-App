#!/usr/bin/env bash
# 全自动Git合并冲突解决脚本 - 专为CI/CD环境设计

set -euo pipefail

# 配置
BACKUP_DIR=".conflict-backups"
LOG_FILE="auto-merge-resolution.log"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
    log "[DEBUG] $1"
}

# 检查Git状态
check_git_status() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "当前目录不是Git仓库"
        exit 1
    fi
    
    # 检查是否有未解决的冲突
    if git diff --name-only --diff-filter=U | grep -q .; then
        log_info "发现未解决的合并冲突"
        return 0
    else
        log_info "没有发现未解决的冲突"
        return 1
    fi
}

# 获取冲突文件列表
get_conflict_files() {
    git diff --name-only --diff-filter=U
}

# 自动解决不同类型文件的冲突
resolve_file_conflict() {
    local file="$1"
    local file_ext="${file##*.}"
    local basename=$(basename "$file")
    
    log_info "解决冲突: $file (类型: $file_ext)"
    
    case "$basename" in
        "pnpm-lock.yaml")
            resolve_pnpm_lock_conflict "$file"
            ;;
        "package-lock.json")
            resolve_npm_lock_conflict "$file"
            ;;
        "yarn.lock")
            resolve_yarn_lock_conflict "$file"
            ;;
        "package.json")
            resolve_package_json_conflict "$file"
            ;;
        *)
            case "$file_ext" in
                "json")
                    resolve_json_conflict "$file"
                    ;;
                "yaml"|"yml")
                    resolve_yaml_conflict "$file"
                    ;;
                "md")
                    resolve_markdown_conflict "$file"
                    ;;
                "js"|"ts"|"jsx"|"tsx")
                    resolve_code_conflict "$file"
                    ;;
                *)
                    resolve_generic_conflict "$file"
                    ;;
            esac
            ;;
    esac
}

# 解决pnpm-lock.yaml冲突
resolve_pnpm_lock_conflict() {
    local file="$1"
    log_info "解决pnpm-lock.yaml冲突"
    
    # 备份文件
    backup_file "$file"
    
    # 删除文件并重新生成
    rm -f "$file"
    if command -v pnpm >/dev/null 2>&1; then
        log_info "重新生成pnpm-lock.yaml"
        pnpm install --lockfile-only
    else
        log_error "pnpm未安装，无法重新生成lockfile"
        return 1
    fi
}

# 解决package-lock.json冲突
resolve_npm_lock_conflict() {
    local file="$1"
    log_info "解决package-lock.json冲突"
    
    backup_file "$file"
    rm -f "$file"
    if command -v npm >/dev/null 2>&1; then
        npm install --package-lock-only
    else
        log_error "npm未安装"
        return 1
    fi
}

# 解决yarn.lock冲突
resolve_yarn_lock_conflict() {
    local file="$1"
    log_info "解决yarn.lock冲突"
    
    backup_file "$file"
    rm -f "$file"
    if command -v yarn >/dev/null 2>&1; then
        yarn install --frozen-lockfile=false
    else
        log_error "yarn未安装"
        return 1
    fi
}

# 解决package.json冲突
resolve_package_json_conflict() {
    local file="$1"
    log_info "解决package.json冲突 - 合并依赖"
    
    backup_file "$file"
    
    # 使用git show获取两个版本
    local ours_content=$(git show :2:"$file" 2>/dev/null || echo '{}')
    local theirs_content=$(git show :3:"$file" 2>/dev/null || echo '{}')
    
    # 使用Node.js脚本智能合并
    node -e "
    const fs = require('fs');
    
    try {
        const ours = JSON.parse('$ours_content');
        const theirs = JSON.parse('$theirs_content');
        
        // 合并依赖
        const merged = { ...ours };
        
        // 合并dependencies
        if (theirs.dependencies) {
            merged.dependencies = { ...merged.dependencies, ...theirs.dependencies };
        }
        
        // 合并devDependencies
        if (theirs.devDependencies) {
            merged.devDependencies = { ...merged.devDependencies, ...theirs.devDependencies };
        }
        
        // 合并peerDependencies
        if (theirs.peerDependencies) {
            merged.peerDependencies = { ...merged.peerDependencies, ...theirs.peerDependencies };
        }
        
        // 写回文件
        fs.writeFileSync('$file', JSON.stringify(merged, null, 2));
        console.log('package.json冲突已解决');
    } catch (error) {
        console.error('package.json合并失败:', error.message);
        // 回退到简单的冲突标记移除
        const content = fs.readFileSync('$file', 'utf8');
        const cleaned = content.replace(/^<<<<<<< .*$/gm, '')
                               .replace(/^=======$/gm, '')
                               .replace(/^>>>>>>> .*$/gm, '');
        fs.writeFileSync('$file', cleaned);
    }
    " || remove_conflict_markers "$file"
}

# 解决JSON文件冲突
resolve_json_conflict() {
    local file="$1"
    log_info "解决JSON文件冲突"
    
    backup_file "$file"
    remove_conflict_markers "$file"
    
    # 验证JSON格式
    if command -v node >/dev/null 2>&1; then
        node -e "
        const fs = require('fs');
        try {
            const content = fs.readFileSync('$file', 'utf8');
            const parsed = JSON.parse(content);
            fs.writeFileSync('$file', JSON.stringify(parsed, null, 2));
            console.log('JSON格式已验证和修复');
        } catch (error) {
            console.error('JSON格式无效:', error.message);
        }
        "
    fi
}

# 解决YAML文件冲突
resolve_yaml_conflict() {
    local file="$1"
    log_info "解决YAML文件冲突"
    
    backup_file "$file"
    remove_conflict_markers "$file"
}

# 解决Markdown文件冲突
resolve_markdown_conflict() {
    local file="$1"
    log_info "解决Markdown文件冲突 - 保留所有内容"
    
    backup_file "$file"
    
    # 对于Markdown文件，我们保留冲突的两个版本，用分隔符分开
    sed -i.tmp '
        s/^<<<<<<< HEAD$/\n**版本A (HEAD):**\n/g
        s/^<<<<<<< .*$/\n**版本A:**\n/g
        s/^=======$/\n\n**版本B:**\n/g
        s/^>>>>>>> .*$/\n/g
    ' "$file"
    rm -f "$file.tmp"
}

# 解决代码文件冲突
resolve_code_conflict() {
    local file="$1"
    log_info "解决代码文件冲突 - 保留HEAD版本"
    
    backup_file "$file"
    
    # 对于代码文件，默认保留HEAD版本
    git checkout --ours "$file"
}

# 解决通用文件冲突
resolve_generic_conflict() {
    local file="$1"
    log_info "解决通用文件冲突 - 移除冲突标记"
    
    backup_file "$file"
    remove_conflict_markers "$file"
}

# 移除冲突标记
remove_conflict_markers() {
    local file="$1"
    
    # 检测操作系统并使用相应的sed命令
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' '/^<<<<<<< /d;/^=======/d;/^>>>>>>> /d' "$file"
    else
        sed -i '/^<<<<<<< /d;/^=======/d;/^>>>>>>> /d' "$file"
    fi
}

# 备份文件
backup_file() {
    local file="$1"
    
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
    fi
    
    local backup_name="$(basename "$file").$(date +%Y%m%d_%H%M%S).bak"
    cp "$file" "$BACKUP_DIR/$backup_name"
    log_debug "备份文件: $file -> $BACKUP_DIR/$backup_name"
}

# 验证解决结果
verify_resolution() {
    # 检查是否还有冲突标记
    local remaining_conflicts=$(git diff --name-only --diff-filter=U | wc -l)
    
    if [ "$remaining_conflicts" -eq 0 ]; then
        log_info "所有冲突已解决"
        return 0
    else
        log_warn "仍有 $remaining_conflicts 个文件存在冲突"
        git diff --name-only --diff-filter=U
        return 1
    fi
}

# 主函数
main() {
    log_info "开始自动合并冲突解决..."
    
    # 检查Git状态
    if ! check_git_status; then
        log_info "没有冲突需要解决"
        exit 0
    fi
    
    # 获取冲突文件列表
    local conflict_files
    conflict_files=$(get_conflict_files)
    
    if [ -z "$conflict_files" ]; then
        log_info "没有找到冲突文件"
        exit 0
    fi
    
    log_info "发现以下冲突文件:"
    echo "$conflict_files" | while read -r file; do
        log_info "  - $file"
    done
    
    # 逐个解决冲突
    echo "$conflict_files" | while read -r file; do
        if [ -f "$file" ]; then
            resolve_file_conflict "$file"
            git add "$file"
        fi
    done
    
    # 验证解决结果
    if verify_resolution; then
        log_info "冲突解决完成，可以继续合并"
        log_info "运行 'git commit' 来完成合并"
    else
        log_error "冲突解决失败，需要手动检查"
        exit 1
    fi
    
    log_info "备份文件保存在: $BACKUP_DIR"
    log_info "详细日志: $LOG_FILE"
}

# 显示帮助信息
show_help() {
    cat << EOF
自动Git合并冲突解决脚本

用法:
    $0 [选项]

选项:
    -h, --help    显示此帮助信息
    
功能:
    - 自动检测和解决Git合并冲突
    - 智能处理不同文件类型的冲突
    - 自动备份原始文件
    - 支持package.json依赖合并
    - 重新生成锁文件(pnpm-lock.yaml等)
    - 详细的日志记录

支持的文件类型:
    - pnpm-lock.yaml: 重新生成
    - package.json: 智能依赖合并
    - JSON文件: 格式验证和修复
    - YAML文件: 冲突标记移除
    - Markdown文件: 保留所有版本
    - 代码文件: 保留HEAD版本
    - 其他文件: 移除冲突标记

EOF
}

# 处理命令行参数
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac