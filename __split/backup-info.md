# Repository Backup Information

## 备份状态

本文件记录了仓库拆分前的状态，以便在需要时可以恢复或参考。

### Git 状态

- **Commit Hash**: db334451ca69ecaf3f4f6ba2a6a3c2844cefa120
- **Branch**: copilot/prepare-for-split
- **Author**: copilot-swe-agent[bot]
- **Date**: Thu Nov 20 07:44:46 2025 +0000
- **Message**: Initial plan

### 仓库结构

#### Apps 目录
```
apps/
├── Supabase/    # 待拆分
├── ewm/         # 待拆分
├── markdown/    # 待拆分
└── web/         # 保留在主仓库
```

#### Packages 目录
```
packages/
├── config/
├── ui/
└── utils/
```

### 拆分范围确认

根据 `scripts/merge.txt` 文件：
1. Supabase
2. ewm
3. markdown

这些应用将被拆分为独立仓库。

### 备份说明

- 所有更改都通过 git commit 进行跟踪
- 可以通过 git log 查看完整历史
- 拆分前的完整状态可通过 git checkout 恢复
