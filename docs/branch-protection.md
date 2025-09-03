# 分支保护与状态检查配置指南

本文档说明如何为 YanYu-Cloud-Cube-App 仓库启用分支保护和状态检查，完成标准化仓库治理的最后一步。

## 快速开始

### 自动化脚本

1. **检查当前状态**：

   ```bash
   ./check-branch-protection.sh
   ```

2. **启用分支保护**：
   ```bash
   ./enable-branch-protection.sh
   ```

### 前置条件

需要以下条件之一：

- GitHub CLI (`gh`) 已安装并已认证
- 设置了 `GH_TOKEN` 环境变量（个人访问令牌）
- 仓库管理员权限

## 保护规则配置

### 必需状态检查

- ✅ **CI 工作流必须通过**
  - 状态检查名称：`CI`
  - 对应工作流：`.github/workflows/ci.yml`
  - 包含：代码检查、类型检查、测试、构建

### Pull Request 要求

- ✅ **需要代码审查**：至少 1 个批准
- ✅ **忽略过期审查**：新提交时重新审查
- ✅ **要求解决对话**：合并前解决所有讨论

### 管理员限制

- ✅ **管理员也需遵守规则**
- ✅ **禁止强制推送**
- ✅ **禁止删除分支**

## 手动配置步骤

如果脚本执行失败，可通过 GitHub 网页界面手动配置：

1. 访问 [分支设置页面](https://github.com/YY-Nexus/YanYu-Cloud-Cube-App/settings/branches)

2. 点击 "Add rule" 为 `main` 分支添加保护规则

3. 配置以下选项：
   ```
   ☑️ Require status checks to pass before merging
   ☑️ Require branches to be up to date before merging
   ☑️ Status checks that are required:
       - CI
   ☑️ Require pull request reviews before merging
   ☑️ Required number of reviewers before merging: 1
   ☑️ Dismiss stale pull request approvals when new commits are pushed
   ☑️ Require conversation resolution before merging
   ☑️ Include administrators
   ☑️ Restrict pushes that create files
   ```

## API 配置

### 完整的 API 调用示例

```bash
curl -X PUT \
  -H "Authorization: token $GH_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/YY-Nexus/YanYu-Cloud-Cube-App/branches/main/protection \
  -d '{
    "required_status_checks": {
      "strict": true,
      "contexts": ["CI"]
    },
    "enforce_admins": true,
    "required_pull_request_reviews": {
      "required_approving_review_count": 1,
      "dismiss_stale_reviews": true,
      "require_code_owner_reviews": false,
      "require_last_push_approval": false
    },
    "restrictions": null,
    "allow_force_pushes": false,
    "allow_deletions": false,
    "block_creations": false,
    "required_conversation_resolution": true
  }'
```

## 验证配置

启用后，验证配置是否正确：

```bash
# 检查保护状态
./check-branch-protection.sh

# 或者直接 API 调用
curl -H "Authorization: token $GH_TOKEN" \
  https://api.github.com/repos/YY-Nexus/YanYu-Cloud-Cube-App/branches/main/protection
```

## 故障排除

### 常见错误

1. **权限不足**：

   ```
   Status: 403 Forbidden
   ```

   解决：确保具有仓库管理员权限

2. **状态检查不存在**：

   ```
   Required status check "CI" not found
   ```

   解决：确保 CI 工作流已运行至少一次

3. **GitHub Token 无效**：
   ```
   Status: 401 Unauthorized
   ```
   解决：重新生成个人访问令牌

### 检查 CI 工作流

确保 CI 工作流正常运行：

```bash
# 检查工作流状态
gh run list --repo YY-Nexus/YanYu-Cloud-Cube-App

# 触发 CI 运行（如果需要）
git commit --allow-empty -m "chore: trigger CI for branch protection"
git push origin main
```

## 标准化完成检查清单

完成分支保护配置后，所有标准化任务应该都已完成：

- [x] 升级 Next.js 至 15.x LTS
- [x] 启用 TypeScript
- [x] 补齐 .eslintrc / .prettierrc / Husky
- [x] 添加 Vitest 基本测试
- [x] 引入标准 CI/CD 工作流
- [x] 补充 .env.example / 规范变量
- [x] **开启分支保护与状态检查** ← 当前任务
- [x] README 更新（状态说明）

## 相关文件

- `enable-branch-protection.sh` - 自动启用分支保护
- `check-branch-protection.sh` - 检查保护状态
- `.github/workflows/ci.yml` - CI 工作流配置
- `docs/ci-cd.md` - CI/CD 流程说明
