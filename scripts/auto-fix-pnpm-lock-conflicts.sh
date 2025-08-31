#!/usr/bin/env bash
# filepath: scripts/auto-fix-pnpm-lock-conflicts.sh

# 自动处理 pnpm-lock.yaml 文件中的合并冲突，保留所有新依赖

LOCK_FILE="pnpm-lock.yaml"

if [ ! -f "$LOCK_FILE" ]; then
  echo "未找到 $LOCK_FILE"
  exit 1
fi

# 备份原文件
cp "$LOCK_FILE" "$LOCK_FILE.bak"

# 删除所有冲突标记
sed -i '' '/^<<<<<<< /d;/^=======/d;/^>>>>>>> /d' "$LOCK_FILE"

echo "已自动删除所有冲突标记，请手动检查依赖合并是否完整。"
echo "建议执行 pnpm install 重新整理依赖关系。"