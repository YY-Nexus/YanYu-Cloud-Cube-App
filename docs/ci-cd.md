# CI/CD 设计说明 - Enhanced

## 目标

通过自动化的 CI/CD 流程，提高代码质量，缩短交付周期，降低人工错误。新增自动冲突解决、智能审核和完整的持续集成能力。

## 流程

### 1. 代码提交与冲突解决

- **代码提交**：开发者将代码提交到 Git 仓库
- **自动冲突检测**：CI 自动检测 merge 冲突
- **自动冲突解决**：使用 `scripts/auto-resolve-conflicts.sh` 自动解决常见冲突（如 pnpm-lock.yaml）
- **手动命令**：开发者可使用 `/fix-conflicts` 命令触发冲突解决

### 2. 持续集成 (CI)

触发条件：代码提交后自动触发 CI 流程

**阶段 1：冲突解决**

- 检测 merge 冲突
- 自动运行冲突解决脚本
- 为开发者提供冲突警告

**阶段 2：质量检测**

- 代码检查（Lint）- 必须通过
- 单元测试 - 必须通过
- 构建测试 - 必须通过
- 类型检查 - 信息性检查（当前不阻塞，待修复）

### 3. 自动审核系统

**质量门禁报告**

- 自动生成质量检测报告
- 在 PR 中显示所有检查状态
- 提供可用命令提示

**智能审核**

- 自动审批小型变更（依赖更新、文档、格式修复）
- 自动审批来自 dependabot、renovate 的 PR
- 自动审批 chore/docs 类型的提交

**交互式命令**

- `/autofix` - 自动修复 lint 和格式问题
- `/fix-conflicts` - 自动解决冲突
- 支持在 PR 评论中使用

### 4. 自动合并

**合并条件**

- 所有必要检查通过
- 有审批或是自动化 PR
- 无 "changes requested" 评审
- 无合并冲突

**合并策略**

- 使用 squash merge
- 自动生成提交信息
- 合并后自动清理分支

### 5. 分支保护

**主分支保护**

- 要求 PR 审核
- 要求状态检查通过
- 禁止强制推送
- 禁止直接删除

## 工具与技术栈

### CI/CD 平台

- **GitHub Actions**：核心 CI/CD 平台
- **Workflows**：
  - `ci.yml` - 主要的 CI 流程
  - `auto-review.yml` - 自动审核和质量门禁
  - `auto-fix.yml` - 自动修复 lint/format/conflicts
  - `branch-protection.yml` - 分支保护和自动合并

### 部署平台

- **Vercel**：前端应用部署

### 冲突解决

- **auto-resolve-conflicts.sh**：通用冲突解决脚本
- **auto-fix-pnpm-lock-conflicts.sh**：pnpm 锁文件专用脚本
- **Python 处理脚本**：处理复杂的冲突标记

### 包管理

- **pnpm**：包管理器
- **Renovate**：依赖自动更新
- **Dependabot**：GitHub 原生依赖更新

## 质量门槛

### 必须通过（阻塞合并）

- ✅ 所有测试用例必须通过
- ✅ 代码检查（Lint）必须通过
- ✅ 构建必须成功

### 信息性检查（不阻塞）

- ⚠️ TypeScript 类型检查（当前有已知问题）

### 自动化检查

- 🔄 自动冲突解决
- 🔄 自动代码格式化
- 🔄 自动依赖更新

## 使用指南

### 开发者命令

在 PR 评论中使用以下命令：

```bash
# 自动修复 lint、格式和冲突
/autofix

# 仅解决冲突
/fix-conflicts
```

### 本地命令

```bash
# 解决冲突
pnpm fix-conflicts

# 解决 pnpm-lock.yaml 冲突
pnpm fix-pnpm-conflicts

# 手动 lint 修复
pnpm lint:fix

# 格式化代码
pnpm format
```

### PR 标签

- `auto-merge` - 添加此标签启用自动合并
- 系统自动识别：`dependabot/`, `renovate/`, `chore/autofix`, `chore:`, `docs:` 开头的 PR

## 监控与通知

### 质量报告

- 每个 PR 自动生成质量门禁报告
- 实时更新检查状态
- 提供命令使用提示

### 自动通知

- 冲突解决完成通知
- 自动修复完成通知
- 自动合并成功/失败通知
- 质量检查失败警告

## 故障排除

### 常见问题

**1. TypeScript 类型检查失败**

- 当前已知问题，不会阻塞 CI
- 将在后续迭代中修复

**2. 冲突解决失败**

- 检查冲突类型是否支持
- 手动解决复杂冲突
- 使用 `/fix-conflicts` 重试

**3. 自动合并失败**

- 检查分支保护规则
- 确认所有检查通过
- 查看合并冲突

### 脚本调试

```bash
# 调试冲突解决脚本
bash -x scripts/auto-resolve-conflicts.sh [file]

# 查看备份文件
ls -la *.conflict-backup-*
```

## 未来改进

### 计划中的功能

- [ ] 修复 TypeScript 类型检查问题
- [ ] 增强冲突解决算法
- [ ] 添加更多自动化测试
- [ ] 集成代码质量度量
- [ ] 添加性能测试自动化

### 扩展计划

- [ ] 多环境部署自动化
- [ ] 回滚机制
- [ ] A/B 测试集成
- [ ] 安全扫描集成
