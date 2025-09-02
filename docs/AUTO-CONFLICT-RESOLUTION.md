# 自动冲突解决系统

本项目实现了一套完整的自动冲突解决系统，能够智能处理Git合并冲突，特别针对monorepo环境中的常见冲突场景。

## 🚀 功能特性

- **智能冲突检测**: 自动识别不同类型文件的冲突
- **文件类型特化处理**: 针对不同文件类型使用专门的解决策略
- **自动备份**: 所有修改前自动创建备份文件
- **CI/CD集成**: GitHub Actions自动化工作流
- **详细日志**: 完整的操作记录和状态追踪

## 📁 脚本组件

### 1. 主要脚本

#### `scripts/auto-fix-pnpm-lock-conflicts.sh`

- **功能**: 专门处理pnpm-lock.yaml和package.json冲突
- **特性**:
  - 跨平台兼容（macOS/Linux）
  - 智能重新生成损坏的lockfile
  - 依赖智能合并
  - 彩色日志输出

#### `scripts/auto-resolve-git-conflicts.sh`

- **功能**: 全面的Git合并冲突自动解决
- **支持文件类型**:
  - `pnpm-lock.yaml`: 重新生成
  - `package.json`: 智能依赖合并
  - JSON文件: 格式验证和修复
  - YAML文件: 冲突标记移除
  - Markdown文件: 保留所有版本
  - 代码文件: 保留HEAD版本

#### `scripts/fix-pnpm-lockfile.py`

- **功能**: Python实现的lockfile智能修复
- **特性**:
  - 重复包定义检测和移除
  - YAML语法验证
  - 冲突标记清理

### 2. 测试脚本

#### `scripts/test-conflict-resolution.sh`

- **功能**: 自动化测试冲突解决功能
- **测试覆盖**:
  - package.json冲突
  - pnpm-lock.yaml冲突
  - 配置文件冲突
  - 备份功能验证

## 🔧 使用方法

### 手动使用

```bash
# 修复pnpm lockfile冲突
./scripts/auto-fix-pnpm-lock-conflicts.sh

# 解决Git合并冲突
./scripts/auto-resolve-git-conflicts.sh

# 运行测试
./scripts/test-conflict-resolution.sh
```

### 在Git工作流中使用

```bash
# 在遇到合并冲突时
git merge feature-branch
# 如果出现冲突，自动解决
./scripts/auto-resolve-git-conflicts.sh
# 完成合并
git commit
```

### CI/CD自动化

项目配置了GitHub Actions工作流 `.github/workflows/auto-resolve-conflicts.yml`，会在以下情况自动运行：

- Push到main/develop分支
- 创建Pull Request
- 手动触发

## 📋 冲突解决策略

### 文件类型处理策略

| 文件类型                      | 解决策略 | 说明                                     |
| ----------------------------- | -------- | ---------------------------------------- |
| `pnpm-lock.yaml`              | 重新生成 | 删除损坏文件，运行`pnpm install`重新生成 |
| `package.json`                | 智能合并 | 合并dependencies, devDependencies等字段  |
| `*.json`                      | 格式修复 | 移除冲突标记，验证JSON格式               |
| `*.yaml`/`*.yml`              | 标记移除 | 简单移除Git冲突标记                      |
| `*.md`                        | 保留全部 | 保留两个版本，用标记分隔                 |
| `*.js`/`*.ts`/`*.jsx`/`*.tsx` | 保留HEAD | 默认使用HEAD版本                         |
| 其他文件                      | 标记移除 | 移除Git冲突标记                          |

### 特殊处理逻辑

#### pnpm-lock.yaml处理

```bash
# 检测损坏 -> 备份 -> 删除 -> 重新生成
if [损坏检测]; then
  backup_file pnpm-lock.yaml
  rm pnpm-lock.yaml
  pnpm install
fi
```

#### package.json依赖合并

```javascript
// 智能合并依赖
const merged = {
  ...ours,
  dependencies: { ...ours.dependencies, ...theirs.dependencies },
  devDependencies: { ...ours.devDependencies, ...theirs.devDependencies },
}
```

## 🗂️ 备份和日志

### 备份文件

- **位置**: `.conflict-backups/`
- **命名**: `原文件名.时间戳.bak`
- **保留**: 所有冲突解决前的原始文件

### 日志文件

- `conflict-resolution.log`: 基础冲突解决日志
- `auto-merge-resolution.log`: Git合并冲突解决日志

## ⚙️ 配置说明

### 环境依赖

- **必需**: `bash`, `git`
- **推荐**: `pnpm`, `node.js`, `python3`
- **可选**: `npm`, `yarn`

### 自定义配置

可以通过修改脚本开头的配置变量来调整行为：

```bash
# 在auto-fix-pnpm-lock-conflicts.sh中
BACKUP_DIR=".conflict-backups"  # 备份目录
LOG_FILE="conflict-resolution.log"  # 日志文件

# 在auto-resolve-git-conflicts.sh中
BACKUP_DIR=".conflict-backups"
LOG_FILE="auto-merge-resolution.log"
```

## 🧪 测试验证

运行完整测试套件：

```bash
# 运行所有测试
./scripts/test-conflict-resolution.sh

# 手动验证特定场景
echo '<<<<<<< HEAD
version1
=======
version2
>>>>>>> branch' > test.txt

./scripts/auto-resolve-git-conflicts.sh
```

## 🚨 故障排除

### 常见问题

1. **权限错误**

   ```bash
   chmod +x scripts/*.sh
   ```

2. **pnpm未安装**

   ```bash
   npm install -g pnpm@9.0.0
   ```

3. **Python脚本失败**
   - 确保Python3可用
   - 检查文件编码为UTF-8

4. **Git状态异常**
   ```bash
   git status
   git diff --name-only --diff-filter=U
   ```

### 安全考虑

- 所有操作都会创建备份文件
- 可以通过备份文件恢复原始状态
- CI环境中会上传备份文件作为artifacts

## 📝 贡献指南

### 添加新文件类型支持

1. 在 `auto-resolve-git-conflicts.sh` 中添加新的 `resolve_*_conflict` 函数
2. 在主要的 `case` 语句中添加文件类型判断
3. 添加相应的测试用例

### 改进冲突解决策略

1. 修改对应的解决函数
2. 更新测试用例
3. 更新文档说明

## 📊 监控和指标

GitHub Actions工作流会生成以下输出：

- 冲突解决成功率
- 处理的文件数量
- 备份文件统计
- 构建验证结果

可以通过Actions页面查看详细的执行日志和下载相关artifacts。
