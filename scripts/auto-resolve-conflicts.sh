#!/usr/bin/env bash
# filepath: scripts/auto-resolve-conflicts.sh

# 自动解决冲突，在冲突内容中，自动删除出图内容的上半部分
# Auto-resolve conflicts by automatically removing the upper part of conflicting content

# Don't exit on errors, handle them gracefully
set -u

# Function to show usage
show_usage() {
    echo "Usage: $0 [file-pattern]"
    echo "  file-pattern: Optional glob pattern for files to process (default: all files)"
    echo ""
    echo "Examples:"
    echo "  $0                     # Process all files with conflicts"
    echo "  $0 '*.yaml'           # Process only YAML files"
    echo "  $0 'pnpm-lock.yaml'   # Process only pnpm-lock.yaml"
    echo ""
    echo "This script automatically resolves merge conflicts by:"
    echo "  1. Removing the upper part (HEAD content) between <<<<<<< and ======="
    echo "  2. Keeping the lower part (incoming branch content) between ======= and >>>>>>>"
    echo "  3. Removing all conflict markers"
}

# Function to process a single file
process_file() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo "警告: 文件不存在: $file"
        return 1
    fi
    
    # Check if file has conflict markers
    if ! grep -q "^<<<<<<< \|^=======$\|^>>>>>>> " "$file"; then
        echo "跳过: $file (没有冲突标记)"
        return 0
    fi
    
    echo "处理冲突文件: $file"
    
    # Create backup
    cp "$file" "$file.conflict-backup"
    
    # Use awk to process the file and remove upper part of conflicts
    awk '
    BEGIN { in_conflict = 0; in_upper_part = 0; }
    
    # Start of conflict - begin upper part (to be removed)
    /^<<<<<<< / { 
        in_conflict = 1; 
        in_upper_part = 1; 
        next 
    }
    
    # Separator - end upper part, begin lower part (to be kept)
    /^=======$/ { 
        if (in_conflict) {
            in_upper_part = 0; 
        }
        next 
    }
    
    # End of conflict - end lower part
    /^>>>>>>> / { 
        in_conflict = 0; 
        in_upper_part = 0; 
        next 
    }
    
    # Print line only if not in upper part of conflict
    {
        if (!in_upper_part) {
            print
        }
    }
    ' "$file" > "$file.tmp"
    
    # Replace original file with processed version
    mv "$file.tmp" "$file"
    
    echo "✓ 已处理: $file (备份: $file.conflict-backup)"
}

# Main execution
main() {
    local file_pattern="${1:-*}"
    local processed_count=0
    local error_count=0
    
    echo "=== 自动冲突解决工具 ==="
    echo "文件模式: $file_pattern"
    echo "策略: 删除上半部分（HEAD内容），保留下半部分（合并分支内容）"
    echo ""
    
    # Handle help flag
    if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
        show_usage
        exit 0
    fi
    
    # Find files with conflicts
    echo "搜索包含冲突标记的文件..."
    
    # Use find with file pattern if specified, otherwise search all files
    if [[ "$file_pattern" == "*" ]]; then
        # Search all files recursively, excluding .git directory and backup files
        conflict_files=$(find . -type f -not -path "./.git/*" -not -name "*.conflict-backup" -exec grep -l "^<<<<<<< \|^=======$\|^>>>>>>> " {} \; 2>/dev/null || true)
    else
        # Search files matching pattern, excluding backup files
        conflict_files=$(find . -type f -name "$file_pattern" -not -path "./.git/*" -not -name "*.conflict-backup" -exec grep -l "^<<<<<<< \|^=======$\|^>>>>>>> " {} \; 2>/dev/null || true)
    fi
    
    if [[ -z "$conflict_files" ]]; then
        echo "没有找到包含冲突标记的文件。"
        exit 0
    fi
    
    echo "找到包含冲突的文件:"
    echo "$conflict_files"
    echo ""
    
    # Process each file
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            if process_file "$file"; then
                ((processed_count++))
            else
                ((error_count++))
            fi
        fi
    done <<< "$conflict_files"
    
    echo ""
    echo "=== 处理完成 ==="
    echo "成功处理: $processed_count 个文件"
    if [[ $error_count -gt 0 ]]; then
        echo "处理失败: $error_count 个文件"
    fi
    echo ""
    echo "建议执行以下命令验证结果:"
    echo "  git diff"
    echo "  git status"
    
    # For pnpm-lock.yaml specifically, suggest reinstall
    if echo "$conflict_files" | grep -q "pnpm-lock.yaml"; then
        echo "  pnpm install  # 重新整理依赖关系"
    fi
}

# Run main function with all arguments
main "$@"