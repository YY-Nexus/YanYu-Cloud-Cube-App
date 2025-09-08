#!/usr/bin/env bash
# filepath: scripts/auto-fix-pnpm-lock-conflicts.sh

# 自动处理 pnpm-lock.yaml 文件中的合并冲突，保留下半部分内容（删除上半部分）

LOCK_FILE="${1:-pnpm-lock.yaml}"

if [ ! -f "$LOCK_FILE" ]; then
  echo "未找到 $LOCK_FILE"
  exit 1
fi

# 检查是否存在冲突标记
if ! grep -q "^<<<<<<< \|^======= \|^>>>>>>> " "$LOCK_FILE"; then
  echo "$LOCK_FILE 中未发现冲突标记，无需处理。"
  exit 0
fi

# 备份原文件
cp "$LOCK_FILE" "$LOCK_FILE.bak"

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
' "$LOCK_FILE" > "$TEMP_FILE"

# 替换原文件
mv "$TEMP_FILE" "$LOCK_FILE"

echo "已自动解决冲突：删除了冲突内容的上半部分，保留了下半部分。"
echo "原文件已备份为 $LOCK_FILE.bak"
echo "建议执行 pnpm install 重新整理依赖关系。"