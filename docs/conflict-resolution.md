# 冲突解决脚本 / Conflict Resolution Script

## 概述 / Overview

`scripts/auto-resolve-conflicts.sh` 是一个自动解决 Git 冲突的工具，特别针对 pnpm-lock.yaml 等文件中的合并冲突。

`scripts/auto-resolve-conflicts.sh` is an automated Git conflict resolution tool, specifically designed for merge conflicts in files like pnpm-lock.yaml.

## 功能特点 / Features

- **智能冲突处理** / **Intelligent Conflict Handling**: 自动识别并解决标准 Git 冲突标记
- **格式异常处理** / **Malformed Conflict Handling**: 处理缺少分隔符或孤立结束标记的异常冲突
- **自动备份** / **Automatic Backup**: 处理前自动创建带时间戳的备份文件
- **跨平台兼容** / **Cross-platform Compatible**: 支持 Linux、macOS 和 Windows
- **详细日志** / **Detailed Logging**: 提供冲突解决过程的详细信息

## 使用方法 / Usage

### 基本用法 / Basic Usage

```bash
# 处理 pnpm-lock.yaml 文件（默认）
./scripts/auto-resolve-conflicts.sh

# 处理指定文件
./scripts/auto-resolve-conflicts.sh path/to/conflicted-file.txt
```

### 冲突解决策略 / Conflict Resolution Strategy

脚本采用以下策略解决冲突：

1. **保留 HEAD 内容**：保留当前分支（HEAD）的更改
2. **删除分支内容**：删除传入分支的更改
3. **删除冲突标记**：完全移除所有 Git 冲突标记

The script uses the following strategy to resolve conflicts:

1. **Keep HEAD content**: Preserve changes from the current branch (HEAD)
2. **Remove branch content**: Delete changes from the incoming branch
3. **Remove conflict markers**: Completely remove all Git conflict markers

### 示例 / Examples

#### 标准冲突 / Standard Conflict

处理前 / Before:

```
<<<<<<< HEAD
current branch content
=======
incoming branch content
>>>>>>> feature-branch
```

处理后 / After:

```
current branch content
```

#### 空 HEAD 冲突 / Empty HEAD Conflict

处理前 / Before:

```
<<<<<<< HEAD
=======
unwanted content to remove
>>>>>>> feature-branch
```

处理后 / After:

```

```

## 备份和恢复 / Backup and Recovery

脚本会自动创建备份文件，格式为：
The script automatically creates backup files with the format:

```
original-file.conflict-backup-YYYYMMDD_HHMMSS
```

如需恢复原文件：
To restore the original file:

```bash
cp original-file.conflict-backup-YYYYMMDD_HHMMSS original-file
```

## 注意事项 / Important Notes

- 脚本会自动处理格式异常的冲突（如缺少分隔符的冲突标记）
- 处理完成后建议运行相关的构建或安装命令（如 `pnpm install`）
- 请在提交前仔细检查解决的冲突是否符合预期

- The script automatically handles malformed conflicts (such as conflict markers without separators)
- After processing, it's recommended to run relevant build or install commands (like `pnpm install`)
- Please carefully review the resolved conflicts before committing

## 相关文件 / Related Files

- `scripts/auto-fix-pnpm-lock-conflicts.sh`: 原始的 pnpm-lock.yaml 冲突处理脚本
- `pnpm-lock.yaml.bak`: pnpm-lock.yaml 的备份文件，包含冲突标记

- `scripts/auto-fix-pnpm-lock-conflicts.sh`: Original pnpm-lock.yaml conflict handling script
- `pnpm-lock.yaml.bak`: Backup of pnpm-lock.yaml containing conflict markers
