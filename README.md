# YanYu Cloud Cube App

基于 Vercel 部署的前端应用，集成可复用 CI/CD、代码质量、自动修复与错误监控。

[![CI Status](https://github.com/YY-Nexus/YanYu-Cloud-Cube-App/actions/workflows/ci.yml/badge.svg)](https://github.com/YY-Nexus/YanYu-Cloud-Cube-App/actions/workflows/ci.yml)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.9.2-blue)](https://www.typescriptlang.org/)
[![Next.js](https://img.shields.io/badge/Next.js-15.5.2-black)](https://nextjs.org/)

## 🎯 标准化仓库治理状态

| 任务项              | 状态 | 说明                   |
| ------------------- | ---- | ---------------------- |
| ✅ Next.js 15.x LTS | 完成 | 已升级到 15.5.2        |
| ✅ TypeScript 启用  | 完成 | 支持 JSX 和 React 类型 |
| ✅ ESLint/Prettier  | 完成 | 代码质量和格式化配置   |
| ✅ Husky Git Hooks  | 完成 | 预提交检查和格式化     |
| ✅ Vitest 基础测试  | 完成 | 单元测试框架配置       |
| ✅ 标准化 CI/CD     | 完成 | 自动化构建、测试、部署 |
| ✅ 环境变量规范     | 完成 | .env.example 模板文件  |
| ✅ 分支保护机制     | 完成 | 自动化分支保护配置     |

## 快速开始

```bash
# 安装依赖
pnpm install

# 复制环境变量模板
cp .env.example .env.local

# 启动开发服务器
pnpm dev
```

## 开发工具

### 代码质量

- **代码检查**: `pnpm lint` 进行 ESLint 代码质量检查
- **格式化**: `pnpm format` 使用 Prettier 格式化代码
- **类型检查**: `pnpm type-check` 进行 TypeScript 验证
- **测试**: `pnpm test` 运行 Vitest 单元测试

### 冲突解决

- `pnpm fix-conflicts` - 自动解决任意文件中的冲突
- `pnpm fix-pnpm-conflicts` - 专门解决 pnpm-lock.yaml 冲突

详细的冲突解决文档请参见 [docs/conflict-resolution.md](docs/conflict-resolution.md)

## 技术栈

- **框架**: Next.js 15.5.2 (App Router)
- **语言**: TypeScript 5.9.2
- **包管理**: pnpm 9.0.0
- **代码质量**: ESLint + Prettier + Husky
- **测试**: Vitest + @testing-library/jest-dom
- **构建工具**: Turbo (Monorepo)
- **部署**: Vercel

## 应用说明

- **apps/Supabase**: Supabase 集成应用
- **apps/ewm**: EWM 管理应用
- **apps/markdown**: Nextra 文档站点
- **apps/web**: 主 Web 应用

## 部署策略

- **PR** → Preview 环境 (Vercel)
- **main** → Production 环境（满足质量门槛）
- **Tag v\*** → 正式发布 + Changelog + Production 部署

## 目录结构

```
├── apps/           # 各个应用
├── packages/       # 共享组件与工具
├── .github/        # CI/CD 工作流
├── docs/           # 项目文档
├── scripts/        # 自动化脚本
└── test/           # 测试配置
```

## 环境变量

复制 `.env.example` 到 `.env.local` 并配置以下变量：

- `NEXT_PUBLIC_SUPABASE_URL` - Supabase 项目 URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Supabase 匿名密钥
- `REPLICATE_API_KEY` - Replicate AI API 密钥
- 更多变量请参考 `.env.example`

## 质量保证

- **Pre-commit hooks**: 自动代码格式化和检查
- **CI/CD**: 自动化测试、构建、部署
- **分支保护**: 强制代码审查和状态检查
- **依赖更新**: Renovate 自动依赖升级

## 文档

- [CI/CD 设计说明](docs/ci-cd.md)
- [架构设计](docs/architecture.md)
- [问题排查](docs/troubleshooting.md)
- [错误预算](docs/error-budget.md)
