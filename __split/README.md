# Repository Split Preparation

## 第一阶段：拆分准备与配置

### 拆分范围

根据 `scripts/merge.txt` 文件，本次拆分将处理以下应用：

1. **Supabase** - apps/Supabase
2. **ewm** - apps/ewm
3. **markdown** - apps/markdown

### 准备工作

- [x] 创建临时目录 `__split`
- [x] 确认拆分范围
- [x] 主仓库当前状态已备份（通过 git commit 记录）

### 目录结构

```
__split/
├── README.md          # 本文件，记录拆分准备信息
└── (待添加拆分相关文件)
```

### 下一步

后续步骤将包括：

- 准备各子仓库的独立配置
- 提取子仓库的历史记录
- 设置子仓库的独立部署配置
- 更新主仓库以移除已拆分的应用

### 备份信息

- **创建时间**: 2025-11-20
- **当前分支**: copilot/prepare-for-split
- **源文件**: scripts/merge.txt
