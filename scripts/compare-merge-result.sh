#!/usr/bin/env bash

MERGE_LIST="scripts/merge.txt"
APPS_DIR="apps"

echo "=== 合并结果对比 ==="
while read repo; do
  if [ -d "$APPS_DIR/$repo" ]; then
    echo "[已合并] $repo"
  else
    echo "[未合并] $repo"
  fi
done < "$MERGE_LIST"