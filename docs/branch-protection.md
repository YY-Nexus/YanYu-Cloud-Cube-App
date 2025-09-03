# 分支保护与状态检查配置

## 当前配置状态

本仓库已启用以下分支保护规则：

### 主分支保护 (main)

- ✅ 要求 PR 审查
- ✅ 要求状态检查通过
- ✅ 强制分支更新
- ✅ 管理员也需遵循规则
- ✅ 删除分支保护

### 必需状态检查

- ✅ CI (GitHub Actions)
- ✅ Build 检查
- ✅ Lint 检查
- ✅ TypeScript 类型检查
- ✅ 测试覆盖率

### PR 要求

- 至少 1 个审查者批准
- 推送新提交时自动解除旧审查
- 代码所有者必须审查（如果有 CODEOWNERS 文件）

## 如何配置分支保护

### 通过 GitHub Web 界面

1. 进入仓库设置
2. 点击 "Branches"
3. 为 `main` 分支添加规则

### 通过 GitHub CLI（推荐）

```bash
# 示例配置命令
gh api -X PUT repos/YY-Nexus/YanYu-Cloud-Cube-App/branches/main/protection \
  --input scripts/templates/branch-protection.json
```

### 通过 API

```bash
curl -X PUT \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/YY-Nexus/YanYu-Cloud-Cube-App/branches/main/protection \
  -d @scripts/templates/branch-protection.json
```

## 状态检查配置

### 必需检查项

- `ci` - 主要的 CI 工作流
- `build-test` - 构建和测试任务
- `type-check` - TypeScript 类型检查
- `lint` - 代码规范检查

### 可选检查项

- `security-scan` - 安全扫描
- `dependency-review` - 依赖审查
- `performance-budget` - 性能预算检查

## 绕过保护的情况

管理员可以在紧急情况下绕过分支保护，但会记录在审计日志中。

## 最佳实践

1. **小批量提交**: 保持 PR 较小且专注
2. **描述性提交**: 使用清晰的提交信息
3. **及时审查**: 快速响应 PR 审查请求
4. **自动化优先**: 依赖 CI/CD 而非手动检查
5. **文档更新**: 重要变更应包含文档更新
