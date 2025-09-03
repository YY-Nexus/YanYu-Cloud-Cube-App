# YanYu Cloud Cube App

[![CI](https://github.com/YY-Nexus/YanYu-Cloud-Cube-App/actions/workflows/ci.yml/badge.svg)](https://github.com/YY-Nexus/YanYu-Cloud-Cube-App/actions/workflows/ci.yml)
[![Deploy](https://github.com/YY-Nexus/YanYu-Cloud-Cube-App/actions/workflows/deploy.yml/badge.svg)](https://github.com/YY-Nexus/YanYu-Cloud-Cube-App/actions/workflows/deploy.yml)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.9.2-blue)](https://www.typescriptlang.org/)
[![Next.js](https://img.shields.io/badge/Next.js-15.5.2-black)](https://nextjs.org/)
[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE)

基于 Vercel 部署的前端应用，集成可复用 CI/CD、代码质量、自动修复与错误监控。

## 🚀 快速开始

```bash
# 安装依赖
pnpm install

# 启动开发服务器
pnpm dev

# 构建项目
pnpm build

# 运行测试
pnpm test

# 代码检查
pnpm lint

# 类型检查
pnpm type-check

# 格式化代码
pnpm format
```

## 📦 项目结构

```
.
├── app/                    # 主应用
├── apps/                   # 微应用集合
│   ├── Supabase/          # Supabase 聊天应用
│   ├── ewm/               # EWM 应用
│   ├── markdown/          # Markdown 文档站
│   └── web/               # 主 Web 应用
├── packages/              # 共享包
├── scripts/               # 构建和部署脚本
├── .github/workflows/     # CI/CD 工作流
└── docs/                  # 项目文档
```

## 🛠 技术栈

- **框架**: Next.js 15.x LTS
- **语言**: TypeScript 5.9+
- **包管理器**: pnpm 9.x
- **构建工具**: Turbo
- **测试框架**: Vitest
- **代码质量**: ESLint + Prettier
- **Git Hooks**: Husky + lint-staged
- **CI/CD**: GitHub Actions
- **部署**: Vercel

## 🔧 开发工具

### 代码质量

- **ESLint**: 代码规范检查，配置了 TypeScript、React、Import 规则
- **Prettier**: 代码格式化，统一代码风格
- **TypeScript**: 类型检查，确保代码健壮性
- **Husky**: Git hooks，提交前自动检查
- **lint-staged**: 只对暂存文件进行检查

### 冲突解决

- `pnpm fix-conflicts` - 自动解决任意文件中的冲突
- `pnpm fix-pnpm-conflicts` - 专门解决 pnpm-lock.yaml 冲突

详细的冲突解决文档请参见 [docs/conflict-resolution.md](docs/conflict-resolution.md)

## 🌍 环境配置

项目根目录包含 `.env.example` 文件，复制并重命名为 `.env.local` 来配置本地环境变量：

```bash
cp .env.example .env.local
```

## 🚀 部署策略

- **PR** → Preview (Vercel)
- **main** → Production（满足质量门槛）
- **Tag v\*** → 正式发布 + Changelog + Production 部署

## 📚 文档

- [架构设计](docs/architecture.md)
- [CI/CD 流程](docs/ci-cd.md)
- [问题排查](docs/troubleshooting.md)
- [错误预算](docs/error-budget.md)

## 🤝 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📄 License

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。
