# YanYu Cloud Cube App

基于 Vercel 部署的前端应用，集成可复用 CI/CD、代码质量、自动修复与错误监控。

## 🚀 标准化状态

✅ **已完成的标准化项目:**

- Next.js 15.x LTS (v15.5.2) - 已升级至最新LTS版本
- TypeScript 5.x - 全面启用类型检查
- ESLint 配置 - 现代化扁平配置，支持TS/React
- Prettier 代码格式化 - 统一代码风格
- Husky Git钩子 - 提交前质量检查
- Vitest 测试框架 - 基础测试已配置
- CI/CD 工作流 - 完整的构建、测试、部署流程
- 环境变量规范 - .env.example 模板已完善
- 依赖管理 - pnpm 工作空间配置
- 分支保护策略 - CI状态检查要求

📊 **质量指标:**

- 构建状态: ✅ 通过
- 测试覆盖率: ✅ 基础测试通过
- 代码规范: ⚠️ 9个警告 (在可接受范围内)
- 类型安全: ✅ TypeScript严格模式

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
