# YanYu Cloud Cube App

基于 Vercel 部署的前端应用，集成可复用 CI/CD、代码质量、自动修复与错误监控。

[![CI](https://github.com/YY-Nexus/YanYu-Cloud-Cube-App/actions/workflows/reusable-ci.yml/badge.svg)](https://github.com/YY-Nexus/YanYu-Cloud-Cube-App/actions/workflows/reusable-ci.yml)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=flat-square&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Next.js](https://img.shields.io/badge/Next.js-15.x-black?style=flat-square&logo=next.js)](https://nextjs.org/)
[![Tested with Vitest](https://img.shields.io/badge/tested%20with-vitest-729B1B?style=flat-square&logo=vitest)](https://vitest.dev/)

## 🚀 项目状态

- ✅ **Next.js 15.x LTS** - 已升级到最新稳定版本
- ✅ **TypeScript** - 全面启用类型安全
- ✅ **ESLint + Prettier** - 代码质量与格式化配置完整
- ✅ **Husky + lint-staged** - Git hooks 自动化检查
- ✅ **Vitest** - 现代测试框架，支持 TypeScript 和 JSX
- ✅ **标准 CI/CD** - GitHub Actions 工作流完整
- ✅ **环境变量规范** - .env.example 模板文件
- ✅ **分支保护** - 已配置质量门槛和状态检查

## 快速开始

```bash
pnpm install
pnpm dev
```

## 开发工具

- **冲突解决**: 使用 `pnpm fix-conflicts` 自动解决 Git 冲突
- **代码检查**: 使用 `pnpm lint` 进行代码质量检查
- **类型检查**: 使用 `pnpm type-check` 进行 TypeScript 验证
- **测试**: 使用 `pnpm test` 运行测试

### 冲突解决脚本

- `pnpm fix-conflicts` - 自动解决任意文件中的冲突
- `pnpm fix-pnpm-conflicts` - 专门解决 pnpm-lock.yaml 冲突

详细的冲突解决文档请参见 [docs/conflict-resolution.md](docs/conflict-resolution.md)

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
- Tag v\* → 正式发布 + Changelog + Production 部署

## 目录结构

- apps/web: 主应用
- packages/\*: 复用组件与工具
- .github/workflows: CI/CD 与复用 workflows
- infra/scripts: 部署与回滚辅助脚本
- docs: 文档
- architecture.md: 架构设计
- ci-cd.md: CI/CD 流程
- troubleshooting.md: 问题排查
- error-budget.md: 错误预算
