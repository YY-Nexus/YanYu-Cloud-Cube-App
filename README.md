# YanYu Cloud Cube App

基于 Vercel 部署的前端应用，集成全自动化 CI/CD、冲突解决、智能审核与持续集成系统。

## 🚀 自动化特性

### ⚡ 智能冲突解决

- 🔄 自动检测和解决 Git merge 冲突
- 📦 专门优化 pnpm-lock.yaml 冲突处理
- 🛡️ 智能备份，安全可靠
- 💬 PR 评论命令：`/fix-conflicts`

### 🎯 自动 CI/CD

- ✅ 多阶段质量检测（lint、test、build）
- 🔍 智能类型检查（信息性，不阻塞）
- 🤖 自动代码格式化和修复
- 📊 实时质量门禁报告

### 🧠 智能审核系统

- 🚦 自动审批小型变更（依赖更新、文档等）
- 🔀 条件满足时自动合并 PR
- 🛡️ 自动分支保护规则
- 💬 交互式 PR 命令支持

## 🛠️ 快速命令

### 开发命令

```bash
pnpm install          # 安装依赖
pnpm dev              # 开发服务器
pnpm lint             # 代码检查
pnpm test             # 运行测试
pnpm build            # 构建项目
```

### 冲突解决

```bash
pnpm fix-conflicts         # 自动解决一般冲突
pnpm fix-pnpm-conflicts   # 解决 pnpm-lock.yaml 冲突
```

### PR 评论命令

在任何 PR 评论中使用：

```bash
/autofix          # 自动修复 lint、格式和冲突
/fix-conflicts    # 仅解决冲突
```

## 📋 自动化工作流

```
📝 代码提交 → 🔍 冲突检测 → ✅ 质量检测 → 🤖 自动审核 → 🎯 智能合并
     ↓              ↓              ↓             ↓            ↓
  自动触发        自动解决       lint/test     生成报告     条件满足自动合并
```

### 自动合并条件

- ✅ 所有 CI 检查通过
- ✅ 有审批或是自动化 PR（dependabot、renovate、chore、docs）
- ❌ 无 "changes requested" 状态
- ❌ 无合并冲突

## 📚 完整文档

- [🔧 自动化指南](./docs/automation-guide.md) - 完整的自动化功能使用指南
- [🚀 CI/CD 详情](./docs/ci-cd.md) - 详细的 CI/CD 流程说明
- [⚡ 冲突解决](./docs/conflict-resolution.md) - 冲突解决系统详解

## 🏗️ 部署策略

- **PR** → Preview (Vercel) + 自动质量检测
- **main** → Production（满足质量门槛后自动部署）
- **Tag v\*** → 正式发布 + Changelog + Production 部署

## 📁 目录结构

```
├── apps/                    # 应用目录
│   ├── ewm/                # QR 码生成应用
│   ├── markdown/           # 文档站点
│   └── Supabase/           # Supabase 集成应用
├── packages/               # 复用组件与工具
├── .github/workflows/      # CI/CD 工作流
│   ├── ci.yml             # 主 CI 流程
│   ├── auto-review.yml    # 自动审核
│   ├── auto-fix.yml       # 自动修复
│   └── branch-protection.yml # 分支保护
├── scripts/               # 自动化脚本
│   ├── auto-resolve-conflicts.sh
│   └── auto-fix-pnpm-lock-conflicts.sh
├── docs/                  # 文档
│   ├── automation-guide.md
│   ├── ci-cd.md
│   └── conflict-resolution.md
└── tests/                 # 测试文件
```

## 🔧 问题排除

### 常见问题

1. **CI 失败**：检查 [自动化指南](./docs/automation-guide.md#故障排除)
2. **冲突解决失败**：使用 `/fix-conflicts` 命令或查看备份文件
3. **自动合并未触发**：确认 PR 满足自动合并条件

### 获取帮助

- 查看 [完整自动化指南](./docs/automation-guide.md)
- 在 PR 中使用 `/autofix` 快速修复问题
- 联系开发团队获取支持

---

🤖 **此项目采用全自动化 CI/CD 系统，大多数维护任务都是自动完成的！**
