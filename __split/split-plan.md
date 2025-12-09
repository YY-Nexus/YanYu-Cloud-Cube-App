# Repository Split Plan

## 概述

本文档详细说明了仓库拆分的完整计划和步骤。

## 拆分目标

将 monorepo 中的以下应用拆分为独立仓库：

1. **Supabase** (`apps/Supabase/`)
2. **ewm** (`apps/ewm/`)
3. **markdown** (`apps/markdown/`)

## 拆分阶段

### 第一阶段：准备与配置 ✅

- [x] 确认拆分范围
- [x] 创建临时目录 `__split`
- [x] 备份主仓库当前状态
- [x] 文档化拆分计划

### 第二阶段：子仓库提取（待执行）

对每个应用执行：
1. 使用 `git subtree` 或 `git filter-branch` 提取历史
2. 创建独立的 git 仓库
3. 保留相关的 git 历史记录
4. 设置独立的配置文件

### 第三阶段：配置独立化（待执行）

对每个子仓库：
1. 复制必要的配置文件（package.json, tsconfig.json 等）
2. 调整依赖关系
3. 设置独立的 CI/CD 配置
4. 配置环境变量模板

### 第四阶段：主仓库清理（待执行）

1. 从主仓库移除已拆分的应用
2. 更新 workspace 配置
3. 更新文档和 README
4. 验证主仓库功能正常

### 第五阶段：验证与部署（待执行）

1. 验证每个子仓库独立运行
2. 测试构建和部署流程
3. 更新相关文档
4. 通知团队成员

## 技术细节

### 保留的文件

每个子仓库需要包含：
- 应用代码（apps/[app-name]/）
- package.json（独立配置）
- tsconfig.json
- CI/CD 配置文件
- README.md
- 环境变量示例（.env.example）

### Git 历史处理

- 保留与应用相关的提交历史
- 使用 `git filter-branch` 或 `git subtree split`
- 保持提交信息的完整性

## 注意事项

1. **依赖管理**：确保每个子仓库的依赖完整
2. **共享代码**：考虑将 packages/ 中的共享代码发布为 npm 包
3. **版本控制**：为每个子仓库设置独立的版本号
4. **CI/CD**：配置独立的部署流程

## 回滚方案

如果拆分过程中出现问题：
1. 使用备份的 commit hash 恢复
2. 参考 `backup-info.md` 中的状态信息
3. 重新评估拆分策略
