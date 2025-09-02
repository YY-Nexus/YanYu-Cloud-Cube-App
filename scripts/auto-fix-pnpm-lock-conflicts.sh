#!/usr/bin/env bash
# filepath: scripts/auto-fix-pnpm-lock-conflicts.sh

# 自动处理 pnpm-lock.yaml 文件中的合并冲突，自动删除冲突内容的上半部分，保留下半部分

LOCK_FILE="pnpm-lock.yaml"

if [ ! -f "$LOCK_FILE" ]; then
  echo "未找到 $LOCK_FILE"
  exit 1
fi

# 备份原文件
cp "$LOCK_FILE" "$LOCK_FILE.bak"

# 使用 awk 脚本智能处理冲突：删除上半部分（HEAD到=======），保留下半部分（=======到>>>>>>>）
awk '
BEGIN { in_conflict = 0; upper_half = 0 }
/^<<<<<<< / { 
  in_conflict = 1
  upper_half = 1
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
' "$LOCK_FILE" > "$LOCK_FILE.tmp"

# 替换原文件
mv "$LOCK_FILE.tmp" "$LOCK_FILE"

echo "已自动解决冲突：删除了冲突内容的上半部分，保留了下半部分。"
echo "冲突解决策略：保留下半部分内容（通常是传入分支的更新版本）"
echo "建议执行 pnpm install 重新整理依赖关系。"