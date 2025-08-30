#!/usr/bin/env bash

# 批量为所有 package.json 补全 packageManager 字段
# 默认值为 pnpm@9.0.0

find . -name "package.json" | while read file; do
  # 检查是否已包含 packageManager 字段
  if ! grep -q '"packageManager"' "$file"; then
    # 在 name 字段后插入 packageManager
    sed -i '' '0,/\"name\":/s//&\n  \"packageManager\": \"pnpm@9.0.0\",/' "$file"
    echo "已补全 packageManager 字段到 $file"
  else
    echo "$file 已有 packageManager 字段，跳过"
  fi
done