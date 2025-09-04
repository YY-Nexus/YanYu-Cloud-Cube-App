# YanYu Cloud Cube App

![CI Status](https://github.com/YY-Nexus/YanYu-Cloud-Cube-App/workflows/CI/badge.svg)
![TypeScript](https://img.shields.io/badge/TypeScript-Ready-blue.svg)
![Next.js](https://img.shields.io/badge/Next.js-15.x-black.svg)
![Testing](https://img.shields.io/badge/Testing-Vitest-green.svg)

基于 Vercel 部署的前端应用，集成可复用 CI/CD、代码质量、自动修复与错误监控。

## 🚀 项目状态

### 标准化治理进度

- ✅ **Next.js 15.x LTS** - 已升级至最新版本
- ✅ **TypeScript** - 已启用，配置完善
- ✅ **ESLint + Prettier** - 代码质量工具已配置
- ✅ **Husky** - Git hooks 已设置
- ✅ **Vitest** - 测试框架已就绪
- ✅ **CI/CD** - 标准化工作流已实施
- ✅ **环境变量** - .env.example 已标准化
- 🔄 **分支保护** - 需要验证和完善

### 质量指标

- **Lint 警告**: 9 个 (主要是 TypeScript any 类型)
- **测试覆盖率**: 基础测试已配置
- **依赖安全**: 通过 Renovate 自动更新

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
