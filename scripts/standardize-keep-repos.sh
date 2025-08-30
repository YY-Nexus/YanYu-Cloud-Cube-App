#!/usr/bin/env bash

TEMPLATE_REPO="YY-Nexus/vercel-web-template"
ORG="YY-Nexus"
WORKDIR="__work"
BR_PREFIX="chore/apply-template"

while read repo; do
  echo "Processing $repo..."
  gh repo clone "$ORG/$repo" "$WORKDIR/$repo" -- --depth=1
  pushd "$WORKDIR/$repo" >/dev/null

  git checkout -b "$BR_PREFIX"

  # 拉取模板文件，rsync标准化配置
  gh repo clone "$TEMPLATE_REPO" __template -- --depth=1
  rsync -av --exclude='.git' __template/.github ./ || true
  rsync -av --exclude='.git' __template/.husky ./ || true
  rsync -av --exclude='.git' __template/tsconfig.base.json ./ || true

  # 自动生成README
  if [ ! -f README.md ]; then
    DESC=$(jq -r '.description // "暂无描述"' package.json)
    echo "# $repo" > README.md
    echo "$DESC" >> README.md
    echo -e "\n## 快速开始\n\`\`\`bash\npnpm install\npnpm dev\n\`\`\`" >> README.md
    echo -e "\n## 自动化运维\n- 标准化CI/CD\n- 自动依赖升级\n- 分支保护" >> README.md
    git add README.md
  fi

  # 合并 package.json
  node - <<'NODE'
const fs = require('fs')
if (!fs.existsSync('package.json')) process.exit(0)
const tmpl = JSON.parse(fs.readFileSync('__template/package.json','utf8'))
const cur = JSON.parse(fs.readFileSync('package.json','utf8'))
cur.scripts = { ...tmpl.scripts, ...cur.scripts }
cur.devDependencies = { ...cur.devDependencies, ...tmpl.devDependencies }
if (!cur.packageManager) cur.packageManager = tmpl.packageManager
fs.writeFileSync('package.json', JSON.stringify(cur, null, 2))
NODE

  git add .
  if git diff --cached --quiet; then
    echo "No changes in $repo"
    popd >/dev/null
    continue
  fi
  git commit -m "chore: apply CI/CD template and auto README"
  git push origin "$BR_PREFIX"
  gh pr create --title "chore: apply CI/CD template and auto README" --body "自动标准化CI/CD、README、依赖、质量配置"
  popd >/dev/null
done < keep.txt