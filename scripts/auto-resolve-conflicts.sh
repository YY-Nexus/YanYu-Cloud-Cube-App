#!/usr/bin/env bash
# filepath: scripts/auto-resolve-conflicts.sh

# 自动处理任意文件中的合并冲突，删除冲突内容上面的部分（保留传入的更改）

usage() {
    echo "用法: $0 [文件路径]"
    echo "自动解决合并冲突，保留传入的更改（删除冲突内容上面的部分）"
    echo ""
    echo "参数:"
    echo "  文件路径    要处理的文件路径（可选，默认处理当前目录下所有冲突文件）"
    echo ""
    echo "选项:"
    echo "  -h, --help  显示帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 pnpm-lock.yaml     # 处理指定文件"
    echo "  $0                    # 处理所有冲突文件"
}

resolve_conflicts_in_file() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo "错误：文件 $file 不存在"
        return 1
    fi

    # 检查是否存在冲突标记
    if ! grep -q "<<<<<<< \|======= \|>>>>>>> " "$file"; then
        echo "文件 $file 中未发现冲突标记"
        return 0
    fi

    echo "正在解决文件 $file 中的合并冲突，保留传入的更改..."

    # 备份原文件
    cp "$file" "$file.conflict-backup"

    # 创建临时文件
    local temp_file=$(mktemp)

    # 使用 awk 脚本处理冲突解决
    awk '
    BEGIN {
        in_conflict = 0
        in_incoming = 0
    }

    # 遇到冲突开始标记
    /^<<<<<<< / {
        in_conflict = 1
        in_incoming = 0
        next
    }

    # 遇到分隔符，开始保留传入的内容
    /^======= *$/ {
        if (in_conflict) {
            in_incoming = 1
        }
        next
    }

    # 遇到冲突结束标记
    /^>>>>>>> / {
        in_conflict = 0
        in_incoming = 0
        next
    }

    # 如果不在冲突中，或者在传入内容部分，则输出该行
    {
        if (!in_conflict || in_incoming) {
            print $0
        }
    }
    ' "$file" > "$temp_file"

    # 替换原文件
    mv "$temp_file" "$file"

    # 统计解决的冲突数量
    local conflicts_resolved=$(grep -c "<<<<<<< \|======= \|>>>>>>> " "$file.conflict-backup" 2>/dev/null || echo 0)
    conflicts_resolved=$((conflicts_resolved / 3))

    echo "✓ 已自动解决 $conflicts_resolved 个冲突，保留了传入的更改。"

    # 验证结果中是否还有冲突标记
    if grep -q "<<<<<<< \|======= \|>>>>>>> " "$file"; then
        echo "⚠ 警告：文件 $file 中仍存在冲突标记，请手动检查。"
        return 1
    fi

    echo "✓ 文件 $file 冲突解决完成。"
    return 0
}

# 处理命令行参数
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
    exit 0
fi

# 如果指定了文件，只处理该文件
if [ $# -eq 1 ]; then
    file="$1"
    resolve_conflicts_in_file "$file"
    if [ $? -eq 0 ]; then
        echo ""
        echo "建议执行相应的命令重新整理项目状态："
        case "$file" in
            *pnpm-lock.yaml)
                echo "  pnpm install"
                ;;
            *package-lock.json)
                echo "  npm install"
                ;;
            *yarn.lock)
                echo "  yarn install"
                ;;
            *)
                echo "  根据文件类型执行相应的验证命令"
                ;;
        esac
    fi
    exit $?
fi

# 如果没有指定文件，查找所有冲突文件
echo "查找所有包含冲突标记的文件..."
conflict_files=$(git status --porcelain | grep "^UU\|^AA\|^DD" | cut -c4- 2>/dev/null)

if [ -z "$conflict_files" ]; then
    # 如果 git status 没有找到，尝试搜索所有文件中的冲突标记
    # 排除 node_modules, .git, dist, build 等目录
    conflict_files=$(find . -type f \( -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.md" -o -name "*.txt" \) \
        -not -path "./node_modules/*" \
        -not -path "./.git/*" \
        -not -path "./dist/*" \
        -not -path "./build/*" \
        -not -path "./.next/*" \
        -not -path "./coverage/*" \
        -exec grep -l "<<<<<<< \|======= \|>>>>>>> " {} \; 2>/dev/null)
fi

if [ -z "$conflict_files" ]; then
    echo "未找到包含冲突标记的文件。"
    exit 0
fi

echo "找到以下冲突文件："
echo "$conflict_files" | sed 's/^/  /'

failed_files=()
resolved_count=0

# 处理每个冲突文件
while IFS= read -r file; do
    if [ -n "$file" ]; then
        echo ""
        if resolve_conflicts_in_file "$file"; then
            resolved_count=$((resolved_count + 1))
        else
            failed_files+=("$file")
        fi
    fi
done <<< "$conflict_files"

echo ""
echo "处理完成："
echo "  成功解决: $resolved_count 个文件"
echo "  失败: ${#failed_files[@]} 个文件"

if [ ${#failed_files[@]} -gt 0 ]; then
    echo ""
    echo "需要手动处理的文件："
    printf '  %s\n' "${failed_files[@]}"
    exit 1
fi

echo ""
echo "✓ 所有冲突已自动解决！"
echo "建议运行项目构建命令验证解决结果。"