#!/usr/bin/env bash
# filepath: scripts/auto-resolve-conflicts.sh

# 通用的自动冲突解决脚本，在冲突内容中自动删除上半部分，保留下半部分

show_usage() {
  echo "用法: $0 <文件路径>"
  echo "自动解决 Git 合并冲突，删除冲突内容的上半部分，保留下半部分"
  echo ""
  echo "参数:"
  echo "  文件路径    要处理的包含冲突标记的文件"
  echo ""
  echo "示例:"
  echo "  $0 pnpm-lock.yaml"
  echo "  $0 package.json"
  echo "  $0 src/config.ts"
}

if [ $# -eq 0 ]; then
  show_usage
  exit 1
fi

TARGET_FILE="$1"

if [ ! -f "$TARGET_FILE" ]; then
  echo "错误: 未找到文件 $TARGET_FILE"
  exit 1
fi

# 检查是否存在冲突标记
if ! grep -q "^<<<<<<< \|^======= \|^>>>>>>> " "$TARGET_FILE"; then
  echo "$TARGET_FILE 中未发现冲突标记，无需处理。"
  exit 0
fi

# 备份原文件
BACKUP_FILE="$TARGET_FILE.bak.$(date +%Y%m%d_%H%M%S)"
cp "$TARGET_FILE" "$BACKUP_FILE"

# 创建临时文件
TEMP_FILE=$(mktemp)

# 智能处理冲突：删除上半部分，保留下半部分
awk '
BEGIN { 
  in_conflict = 0
  skip_upper = 0
  conflict_count = 0
}
/^<<<<<<< / { 
  in_conflict = 1
  skip_upper = 1
  conflict_count++
  next 
}
/^=======/ { 
  if (in_conflict) {
    skip_upper = 0
  }
  next 
}
/^>>>>>>> / { 
  in_conflict = 0
  skip_upper = 0
  next 
}
{
  if (!skip_upper) {
    print
  }
}
END {
  if (conflict_count > 0) {
    print "# 处理了", conflict_count, "个冲突块" > "/dev/stderr"
  }
}
' "$TARGET_FILE" > "$TEMP_FILE"

# 替换原文件
mv "$TEMP_FILE" "$TARGET_FILE"

echo "✅ 已自动解决 $TARGET_FILE 中的冲突"
echo "📝 删除了冲突内容的上半部分，保留了下半部分"
echo "💾 原文件已备份为 $BACKUP_FILE"
echo ""
echo "建议后续操作:"
if [[ "$TARGET_FILE" == *"pnpm-lock.yaml"* ]]; then
  echo "  - 执行 pnpm install 重新整理依赖关系"
elif [[ "$TARGET_FILE" == *"package.json"* ]]; then
  echo "  - 检查依赖配置是否正确"
  echo "  - 执行 npm install 或 pnpm install"
else
  echo "  - 检查文件内容是否符合预期"
  echo "  - 运行相关测试确保功能正常"
fi