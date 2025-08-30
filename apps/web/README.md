# Web 应用

## 技术栈

- Next.js 14+
- TypeScript
- Turborepo Monorepo
- pnpm

## 生产部署

本应用通过 GitHub Actions 自动部署到 Vercel 平台，主分支变更、Release 发布均会触发生产环境部署。

### 工作流说明

- 自动安装依赖、构建
- 集成 Sentry sourcemaps 上传（如配置TOKEN）
- Vercel 自动拉取、构建、发布
- 部署完成后输出 Production URL

### 本地开发

```bash
pnpm install
pnpm dev
```

### 环境变量

请参考 `.env.example`，配置必要的API KEY及服务信息。

### 质量保障

- 自动化 CI/CD
- 分支保护
- 依赖自动升级（Renovate）
