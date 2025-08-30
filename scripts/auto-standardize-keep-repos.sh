# scripts/auto-standardize-keep-repos.sh
#!/usr/bin/env bash

KEEP_LIST="scripts/keep.txt"

while read repo; do
  echo "正在处理 $repo ..."
  # 1. 添加标准README
  cp scripts/templates/README.md ___clones/$repo/README.md
  # 2. 添加CI/CD工作流
  cp scripts/templates/ci.yml ___clones/$repo/.github/workflows/ci.yml
  # 3. 添加质量配置
  cp scripts/templates/.eslintrc.cjs ___clones/$repo/.eslintrc.cjs
  cp scripts/templates/.prettierrc ___clones/$repo/.prettierrc
  # 4. 添加renovate.json
  cp scripts/templates/renovate.json ___clones/$repo/renovate.json
  # 5. 自动开启分支保护（可用gh CLI或API）
  gh api -X PUT /repos/YY-Nexus/$repo/branches/main/protection --input scripts/templates/branch-protection.json
  # 6. 自动提交并推送PR或直接push
  cd ___clones/$repo
  git add .
  git commit -m "标准化：补全README、CI/CD、质量、依赖升级、分支保护"
  git push origin main
  # 或用gh pr create自动创建PR
  cd -
done < "$KEEP_LIST"