#!/usr/bin/env bash
set -e

# 创建主目录结构
mkdir -p apps/web
mkdir -p packages/ui
mkdir -p packages/config
mkdir -p packages/utils
mkdir -p infra/scripts
mkdir -p .github/workflows
mkdir -p .github/actions/setup-node-pnpm
mkdir -p .github/actions/post-preview-comment
mkdir -p .github/ISSUE_TEMPLATE
mkdir -p .husky
mkdir -p docs

# 占位文件，防止目录被 git 忽略
touch apps/web/.keep
touch packages/ui/.keep
touch packages/config/.keep
touch packages/utils/.keep
touch infra/scripts/.keep
touch .github/actions/setup-node-pnpm/.keep
touch .github/actions/post-preview-comment/.keep

# 工作流文件
for wf in ci.yml deploy.yml preview-comment.yml auto-fix.yml lighthouse.yml reusable-ci.yml reusable-deploy.yml renovate-trigger.yml; do
  touch ".github/workflows/$wf"
done

# ISSUE_TEMPLATE
for tpl in bug_report.md feature_request.md incident.md; do
  touch ".github/ISSUE_TEMPLATE/$tpl"
done

# docs 文件
for doc in architecture.md ci-cd.md troubleshooting.md error-budget.md; do
  touch "docs/$doc"
done

# 根配置文件
touch vercel.json
touch turbo.json
touch package.json
touch pnpm-workspace.yaml
touch tsconfig.base.json
touch .eslintrc.cjs
touch .prettierrc
touch commitlint.config.cjs
touch .lintstagedrc.cjs
touch .husky/pre-commit
touch .husky/commit-msg
touch .nvmrc
touch .env.example

echo "已完整创建所有目录及占位文件，请根据实际内容补充每个文件。"