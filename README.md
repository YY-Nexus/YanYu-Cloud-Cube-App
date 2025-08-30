# YanYu Cloud Cube App

基于 Vercel 部署的前端应用，集成可复用 CI/CD、代码质量、自动修复与错误监控。

## 快速开始

```bash
pnpm install
pnpm dev
```

## 分支策略

详见 docs/ci-cd.md

## 部署

```bash
pnpm install
pnpm dev
```

## 部署策略

- PR → Preview (Vercel)
- main → Production（满足质量门槛）
- Tag v* → 正式发布 + Changelog + Production 部署

## 目录结构

- apps/web: 主应用
- packages/*: 复用组件与工具
- .github/workflows: CI/CD 与复用 workflows
- infra/scripts: 部署与回滚辅助脚本
- docs: 文档
- architecture.md: 架构设计
- ci-cd.md: CI/CD 流程
- troubleshooting.md: 问题排查
- error-budget.md: 错误预算
