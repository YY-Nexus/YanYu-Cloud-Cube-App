# 项目架构

本项目采用 Turborepo 管理多应用、多包结构，主仓 YanYu-Cloud-Cube-App 负责聚合所有业务模块和核心工具。

## 目录结构

- `apps/`：主应用目录（如 web、admin 等）
- `packages/`：可复用的工具、UI组件、配置等
- `infra/`：基础设施脚本与自动化运维
- `docs/`：架构与治理文档

## 技术栈

- Next.js 14+
- TypeScript
- pnpm
- Turborepo
- GitHub Actions (CI/CD)
- Renovate (依赖自动升级)

## 流程说明

1. 所有代码分支强制走 PR 审核，自动化 CI/CD 校验。
2. 所有依赖自动升级由 Renovate Bot 控制，安全合并。
3. 所有应用与包均经过 lint、type-check、test 校验。
