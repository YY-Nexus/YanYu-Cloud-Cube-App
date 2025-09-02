#!/usr/bin/env bash
# filepath: scripts/auto-resolve-conflicts.sh

# 自动解决任意文件中的Git合并冲突，删除冲突内容的上半部分，保留下半部分

# 显示使用说明
usage() {
    echo "用法: $0 [文件路径]"
    echo "自动解决指定文件中的Git合并冲突"
    echo "如果未指定文件，则默认处理 pnpm-lock.yaml"
    echo ""
    echo "示例:"
    echo "  $0                    # 处理 pnpm-lock.yaml"
    echo "  $0 package.json       # 处理 package.json"
    echo "  $0 src/config.ts      # 处理 src/config.ts"
    exit 1
}

# 解析参数
TARGET_FILE="pnpm-lock.yaml"
if [ $# -gt 1 ]; then
    usage
elif [ $# -eq 1 ]; then
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        usage
    fi
    TARGET_FILE="$1"
fi

# 检查文件是否存在
if [ ! -f "$TARGET_FILE" ]; then
    echo "错误：未找到文件 $TARGET_FILE"
    exit 1
fi

# 检查文件是否包含冲突标记
if ! grep -q "^<<<<<<<\|^=======\|^>>>>>>>" "$TARGET_FILE"; then
    echo "文件 $TARGET_FILE 中未发现冲突标记"
    exit 0
fi

# 备份原文件
BACKUP_FILE="${TARGET_FILE}.bak"
cp "$TARGET_FILE" "$BACKUP_FILE"
echo "已创建备份文件: $BACKUP_FILE"

# 统计冲突数量
CONFLICT_COUNT=$(grep -c "^<<<<<<<" "$TARGET_FILE")
echo "发现 $CONFLICT_COUNT 个冲突块"

# 使用 awk 脚本智能处理冲突：删除上半部分（HEAD到=======），保留下半部分（=======到>>>>>>>）
awk '
BEGIN { 
    in_conflict = 0
    upper_half = 0
    conflict_num = 0
}
/^<<<<<<< / { 
    in_conflict = 1
    upper_half = 1
    conflict_num++
    next 
}
/^=======$/ { 
    upper_half = 0
    next 
}
/^>>>>>>> / { 
    in_conflict = 0
    next 
}
{
    if (!in_conflict || !upper_half) {
        print
    }
}
END {
    if (conflict_num > 0) {
        printf "处理了 %d 个冲突\n", conflict_num > "/dev/stderr"
    }
}
' "$TARGET_FILE" > "${TARGET_FILE}.tmp"

# 替换原文件
mv "${TARGET_FILE}.tmp" "$TARGET_FILE"

echo "✅ 冲突解决完成！"
echo "🔧 策略：删除上半部分（通常是当前分支），保留下半部分（通常是传入分支）"
echo "📁 原文件已备份为: $BACKUP_FILE"

# 根据文件类型给出建议
case "$TARGET_FILE" in
    pnpm-lock.yaml)
        echo "💡 建议：执行 'pnpm install' 重新整理依赖关系"
        ;;
    package.json)
        echo "💡 建议：检查依赖版本并执行 'pnpm install'"
        ;;
    *.json)
        echo "💡 建议：验证JSON格式是否正确"
        ;;
    *.yaml|*.yml)
        echo "💡 建议：验证YAML格式是否正确"
        ;;
    *)
        echo "💡 建议：检查文件内容并测试相关功能"
        ;;
esac