# YanYu Cloud Cube App

![CI Status](https://github.com/YY-Nexus/YanYu-Cloud-Cube-App/workflows/CI/badge.svg)
![TypeScript](https://img.shields.io/badge/TypeScript-Ready-blue.svg)
![Next.js](https://img.shields.io/badge/Next.js-15.x-black.svg)
![Testing](https://img.shields.io/badge/Testing-Vitest-green.svg)

基于副驾智能运维迭代部署前端应用，集成可复用 CI/CD、代码质量、自动修复与错误监控。

## 🚀 项目状态

### 标准化治理进度

- ✅ **Next.js 15.x LTS** - 已升级至最新版本
- ✅ **TypeScript** - 已启用，配置完善
- ✅ **ESLint + Prettier** - 代码质量工具已配置
- ✅ **Husky** - Git hooks 已设置
- ✅ **Vitest** - 测试框架已就绪
- ✅ **CI/CD** - 标准化工作流已实施
- ✅ **环境变量** - .env.example 已标准化
- ✅ **分支保护** - 标准 CI/CD 流程已实施

### 质量指标

- **TypeScript**: ✅ 全面类型检查通过
- **Lint 警告**: 9 个 (主要是 TypeScript any 类型，不影响功能)
- **测试状态**: ✅ 基础测试和治理测试通过
- **依赖管理**: 通过 Renovate 自动更新
- **版本一致性**: ✅ 所有应用已升级至 Next.js 15.x

## 快速开始

```bash
pnpm install
pnpm dev
```

## 开发工具

- **冲突解决**: 使用 `pnpm fix-conflicts` 自动解决 Git 冲突
- **包依赖冲突**: 使用 `pnpm fix-package-conflicts` 智能解决 package.json 冲突
- **专用 pnpm 冲突**: 使用 `pnpm fix-pnpm-conflicts` 专门解决 pnpm-lock.yaml 冲突
- **代码检查**: 使用 `pnpm lint` 进行代码质量检查
- **类型检查**: 使用 `pnpm type-check` 进行 TypeScript 验证
- **测试**: 使用 `pnpm test` 运行测试

### 冲突解决脚本

- `pnpm fix-conflicts` - 自动解决任意文件中的冲突
- `pnpm fix-package-conflicts` - 智能解决 package.json 冲突，支持依赖合并
- `pnpm fix-pnpm-conflicts` - 专门解决 pnpm-lock.yaml 冲突

### 自动化冲突解决工作流

本项目包含 GitHub Actions 工作流，可以自动检测和解决 PR 中的依赖冲突：

- 在 PR 描述中包含 `[auto-resolve]` 可触发自动冲突解决
- 自动检测 `pnpm-lock.yaml` 和 `package.json` 中的冲突
- 智能合并依赖关系，优先保留 HEAD 分支的配置
- 自动运行代码检查和格式化
- 提交解决后的更改并在 PR 中添加说明评论

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
