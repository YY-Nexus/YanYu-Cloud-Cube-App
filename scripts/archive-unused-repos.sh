#!/usr/bin/env bash

EXCLUDE=("YanYu-Cloud-Cube-App" "YanYuCloudCube")   # 主仓+规划仓

while read repo; do
  SKIP=0
  for e in "${EXCLUDE[@]}"; do
    [[ "$repo" == "$e" ]] && SKIP=1
  done
  if [[ $SKIP -eq 0 ]]; then
    echo "Archiving $repo"
    gh repo archive "YY-Nexus/$repo"
  else
    echo "Skip $repo"
  fi
done < archive.txt