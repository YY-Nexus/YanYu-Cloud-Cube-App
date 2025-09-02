# YanYu Cloud Cube App - Copilot Instructions

## 项目概述

这是一个基于 Vercel 部署的前端应用，采用 monorepo 架构，集成了可复用的 CI/CD、代码质量检查、自动修复与错误监控功能。

## 技术栈

- **前端框架**: React 18, Next.js 15
- **语言**: TypeScript 5.9
- **包管理**: pnpm 9.0
- **构建工具**: TurboRepo 2.0
- **代码质量**: ESLint 9, Prettier 3.6, Commitlint
- **测试**: Vitest 1.6
- **部署**: Vercel
- **Git 工具**: Husky, lint-staged

## 项目结构

```
├── apps/                    # 应用目录
│   ├── web/                # 主应用
│   ├── ewm/                # 二维码应用
│   ├── markdown/           # Markdown 应用
│   └── Supabase/           # Supabase 集成
├── packages/               # 共享包
│   ├── config/             # 配置包
│   ├── ui/                 # UI 组件库
│   └── utils/              # 工具函数
├── .github/                # GitHub 配置
│   ├── workflows/          # CI/CD 工作流
│   └── ISSUE_TEMPLATE/     # Issue 模板
├── docs/                   # 文档
├── infra/                  # 基础设施脚本
└── scripts/                # 工具脚本
```

## 开发指南

### 安装依赖

```bash
pnpm install
```

### 开发命令

- `pnpm dev` - 启动开发服务器 (并行运行所有应用)
- `pnpm build` - 构建所有项目
- `pnpm lint` - ESLint 检查 (最大警告数: 0)
- `pnpm lint:fix` - 自动修复 ESLint 问题
- `pnpm type-check` - TypeScript 类型检查
- `pnpm test` - 运行测试并生成覆盖率报告
- `pnpm test:watch` - 监听模式运行测试
- `pnpm format` - Prettier 格式化
- `pnpm release` - 语义化版本发布 (使用 commit-and-tag-version)

### 代码标准

1. **TypeScript**: 必须通过类型检查，无 TypeScript 错误
2. **ESLint**: 必须通过 lint 检查，最大警告数为 0
3. **Prettier**: 代码必须格式化
4. **Commitlint**: 提交信息必须符合 conventional commits 规范
5. **测试**: 新功能需要相应的测试覆盖

### 提交规范

使用 Conventional Commits 格式:

- `feat:` 新功能
- `fix:` 错误修复
- `docs:` 文档更新
- `style:` 代码样式更改
- `refactor:` 重构
- `test:` 测试相关
- `chore:` 构建过程或辅助工具的变动

### 分支策略

- **PR → Preview**: 通过 Vercel 自动部署预览环境
- **main → Production**: 满足质量门槛后部署到生产环境
- **Tag v\* → Release**: 正式发布 + Changelog + 生产部署

## Copilot 工作指南

### 代码修改原则

1. **最小化更改**: 只修改必要的代码，避免大规模重构
2. **保持一致性**: 遵循现有的代码风格和架构模式
3. **类型安全**: 确保 TypeScript 类型正确
4. **测试覆盖**: 为新功能添加测试

### 常见任务

#### 添加新组件

- 在 `packages/ui` 中创建可复用组件
- 在相应的 `apps/` 目录中创建应用特定组件
- 使用 TypeScript 接口定义 Props
- 添加适当的测试

#### 修复依赖问题

- 使用 `pnpm` 管理依赖
- 检查 `pnpm-lock.yaml` 是否需要更新
- 运行 `pnpm install` 确保依赖同步

#### 添加新应用

- 在 `apps/` 目录下创建新应用
- 更新 `pnpm-workspace.yaml` (如果需要)
- 配置 `turbo.json` 中的构建管道
- 添加相应的部署配置

#### 更新配置

- ESLint 配置: `.eslintrc.cjs`
- Prettier 配置: `.prettierrc`
- TypeScript 配置: `tsconfig.base.json`, `tsconfig.json`
- Commitlint 配置: `commitlint.config.cjs`
- TurboRepo 配置: `turbo.json`

### 调试指南

1. **构建失败**: 检查 TypeScript 错误和 ESLint 警告
2. **测试失败**: 运行 `pnpm test:watch` 进行调试
3. **类型错误**: 运行 `pnpm type-check` 检查类型问题
4. **依赖问题**: 删除 `node_modules` 和锁文件后重新安装

### 部署注意事项

- Vercel 配置在 `vercel.json`
- 构建输出目录: `dist/**`
- 环境变量配置需要在 Vercel 控制台设置
- 生产部署前确保所有 CI 检查通过

## 质量门槛

- ✅ TypeScript 编译无错误
- ✅ ESLint 检查通过 (0 警告)
- ✅ Prettier 格式化检查通过
- ✅ 测试覆盖率达标
- ✅ 提交信息符合规范
- ✅ 构建成功

## 联系信息

如有问题，请通过 GitHub Issues 或 PR 评论联系维护团队。
