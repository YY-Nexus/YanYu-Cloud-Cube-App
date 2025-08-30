#!/usr/bin/env bash
set -e

TEMPLATE_REPO="YY-Nexus/vercel-web-template"
BR_PREFIX="chore/apply-template"
TARGET_REPOS=(
Render
YYC_Content
YY-Mgmt
Docker_stack
YYC-CodeX
nextjs-ai-chatbot
YYC3-management
AI-platform
pbzz
YY-Medical
--hz
yyyp
YY-Chatbot-B2
YYC-0009
chanbot
YYC-Render
zhou-AI
AI-Learning-Platform
Mana-1
Integrations-Page
YY-AI
YYC-Learning-Hub
YYC-Smart-Business-Center
Cloud-JY
Home-Data-Service-Platform
NetTrack
YYC-DeepStack
MediNexus-
YYC3_AI
yy-nettrack
Install-Mixpanel-
YanYu-Cloud-Sharing-E-center
ZYOYO
YanYu-Cloud-DeepStack
music
YY-Y
YanYu-E
ZY-ZhiHu
v0-platform
JINlan
ly-cscp
95558api
YanYu-DeepStack
yycloud-c
Segment-ai-copilot
My-OS
limei
YY--
YY-1
Neuxs-AI-YiPin
md
yyy-fun
YanYu-Server
nextjs-template
Add-Webhook
YanYu-Developer-Tools
-API-
)

for R in "${TARGET_REPOS[@]}"; do
  echo "=== Processing $R ==="
  gh repo clone "YY-Nexus/$R" "__work/$R" -- --depth=1
  pushd "__work/$R" >/dev/null

  git checkout -b "${BR_PREFIX}"

  # 拉取模板文件
  gh repo clone "$TEMPLATE_REPO" __template -- --depth=1
  rsync -av --exclude='.git' __template/.github ./ || true
  rsync -av --exclude='.git' __template/.husky ./ || true
  rsync -av --exclude='.git' __template/tsconfig.base.json ./ || true
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
    echo "No changes in $R"
    popd >/dev/null
    continue
  fi
  git commit -m "chore: apply CI/CD template"
  git push origin "${BR_PREFIX}"
  gh pr create --title "chore: apply CI/CD template" --body "统一接入标准工作流与质量配置" || true
  popd >/dev/null
done