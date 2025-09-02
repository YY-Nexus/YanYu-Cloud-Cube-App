#!/usr/bin/env bash
# filepath: scripts/auto-fix-pnpm-lock-conflicts.sh

# 自动处理 pnpm-lock.yaml 文件中的合并冲突，删除冲突内容中上面的部分，保留下面的部分

LOCK_FILE="pnpm-lock.yaml"

if [ ! -f "$LOCK_FILE" ]; then
  echo "未找到 $LOCK_FILE"
  exit 1
fi

# 备份原文件
cp "$LOCK_FILE" "$LOCK_FILE.bak"

# 删除冲突内容中上面的部分，保留下面的部分（删除 <<<<<<< 到 ======= 之间的内容）
# 使用 awk 进行更精确的处理
awk '
BEGIN { in_conflict = 0; in_upper = 0 }
/^<<<<<<< / { in_conflict = 1; in_upper = 1; next }
/^=======$/ { in_upper = 0; next }
/^>>>>>>> / { in_conflict = 0; in_upper = 0; next }
!(in_conflict && in_upper) { print }
' "$LOCK_FILE" > "$LOCK_FILE.tmp" && mv "$LOCK_FILE.tmp" "$LOCK_FILE"

echo "已自动删除冲突内容中上面的部分，保留下面的部分。"
echo "建议执行 pnpm install 重新整理依赖关系。"