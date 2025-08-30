#!/usr/bin/env bash

MAIN_REPO="YanYu-Cloud-Cube-App"
MAIN_PATH="apps" # 或 packages，根据你的主仓结构
ORG="YY-Nexus"
WORKDIR="__merge"
mkdir -p $WORKDIR

while read repo; do
  echo "Merging $repo into $MAIN_REPO/$MAIN_PATH/$repo"
  gh repo clone "$ORG/$repo" "$WORKDIR/$repo" -- --depth=1
  cd "$WORKDIR/$repo"
  # 假如你只需要当前分支代码，直接复制
  mkdir -p "../../../$MAIN_REPO/$MAIN_PATH/$repo"
  rsync -av --exclude='.git' . "../../../$MAIN_REPO/$MAIN_PATH/$repo"
  cd ../../..
done < merge.txt

echo "请在主仓 $MAIN_REPO 的 $MAIN_PATH/ 目录检查合并结果并手动提交合并 commit。"