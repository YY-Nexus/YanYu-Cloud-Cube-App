#!/usr/bin/env bash
# filepath: scripts/auto-fix-pnpm-lock-conflicts.sh

# 自动处理 pnpm-lock.yaml 文件中的合并冲突，删除冲突内容上面的部分（保留传入的更改）

LOCK_FILE="pnpm-lock.yaml"

if [ ! -f "$LOCK_FILE" ]; then
  echo "未找到 $LOCK_FILE"
  exit 1
fi

# 备份原文件
cp "$LOCK_FILE" "$LOCK_FILE.bak"

# 检查是否存在冲突标记
if ! grep -q "<<<<<<< \|======= \|>>>>>>> " "$LOCK_FILE"; then
  echo "文件中未发现冲突标记"
  exit 0
fi

echo "正在解决合并冲突，保留传入的更改..."

# 创建临时文件
TEMP_FILE=$(mktemp)

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
' "$LOCK_FILE" > "$TEMP_FILE"

# 替换原文件
mv "$TEMP_FILE" "$LOCK_FILE"

# 统计解决的冲突数量
CONFLICTS_RESOLVED=$(grep -c "<<<<<<< \|======= \|>>>>>>> " "$LOCK_FILE.bak" || echo 0)
CONFLICTS_RESOLVED=$((CONFLICTS_RESOLVED / 3))

echo "已自动解决 $CONFLICTS_RESOLVED 个冲突，保留了传入的更改。"
echo "建议执行 pnpm install 重新整理依赖关系。"

# 验证结果中是否还有冲突标记
if grep -q "<<<<<<< \|======= \|>>>>>>> " "$LOCK_FILE"; then
  echo "警告：文件中仍存在冲突标记，请手动检查。"
  exit 1
fi

echo "冲突解决完成。"