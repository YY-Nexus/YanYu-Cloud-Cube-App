# 自动冲突解决 - 快速开始

## 🚀 一键解决冲突

当遇到Git合并冲突时，只需运行：

```bash
./scripts/auto-resolve-git-conflicts.sh
```

## 📦 专门修复lockfile问题

当pnpm-lock.yaml损坏或有冲突时：

```bash
./scripts/auto-fix-pnpm-lock-conflicts.sh
```

## 🧪 验证功能

测试冲突解决是否正常工作：

```bash
./scripts/test-conflict-resolution.sh
```

## 🔄 在CI/CD中使用

项目已配置GitHub Actions，会自动：

- 检测冲突
- 解决冲突
- 验证修复
- 推送结果

## ⚡ 常用场景

### 场景1: 合并分支时遇到冲突

```bash
git merge feature-branch
# 出现冲突提示
./scripts/auto-resolve-git-conflicts.sh
git commit
```

### 场景2: Pull Request有lockfile冲突

```bash
git checkout feature-branch
git pull origin main
# 出现pnpm-lock.yaml冲突
./scripts/auto-fix-pnpm-lock-conflicts.sh
git add pnpm-lock.yaml
git commit -m "fix: resolve lockfile conflicts"
git push
```

### 场景3: 依赖版本冲突

```bash
# package.json有依赖版本冲突
./scripts/auto-resolve-git-conflicts.sh
# 会智能合并所有依赖
pnpm install  # 验证依赖正确
git add package.json pnpm-lock.yaml
git commit -m "chore: merge dependency conflicts"
```

## 🔍 检查结果

冲突解决后检查：

- 备份文件: `.conflict-backups/`
- 日志文件: `*.log`
- Git状态: `git status`

详细文档: [完整使用指南](docs/AUTO-CONFLICT-RESOLUTION.md)
