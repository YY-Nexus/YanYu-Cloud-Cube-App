#!/usr/bin/env bash

# 1. 自动分类
bash scripts/classify-repos.sh

# 2. 合并MERGE仓库到主仓
bash scripts/merge-repos-to-main.sh

# 3. KEEP仓库自动标准化
bash scripts/standardize-keep-repos.sh

# 4. KEEP仓库分支保护
bash scripts/branch-protect-keep.sh

# 5. 自动归档ARCHIVE仓库（如需彻底删除请改用删除脚本）
bash scripts/archive-unused-repos.sh