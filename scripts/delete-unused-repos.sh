#!/usr/bin/env bash

EXCLUDE=("YanYu-Cloud-Cube-App" "YanYuCloudCube")

while read repo; do
  SKIP=0
  for e in "${EXCLUDE[@]}"; do
    [[ "$repo" == "$e" ]] && SKIP=1
  done
  if [[ $SKIP -eq 0 ]]; then
    echo "Deleting $repo"
    gh repo delete "YY-Nexus/$repo" --confirm
  else
    echo "Skip $repo"
  fi
done < delete.txt