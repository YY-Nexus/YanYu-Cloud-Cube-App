# scripts 目录说明

本目录用于存放项目自动化管理脚本及辅助清单文件，方便团队协作和批量操作。

## ⚠️ 重要更新

**当前状态**: 所有外部仓库自动化已暂停，仅专注主仓库的自动化运维审核。

根据需求"停止所有仓库的CI/CD等副驾工作，仅优先此仓库进行整套自动化运维的审核"，主自动化脚本已切换到暂停模式。

## 主要脚本及用途

### 自动化控制脚本

- `master-all-in-one.sh` **（已修改）**  
  当前重定向到暂停模式，显示暂停状态和可用操作。

- `master-all-in-one-paused.sh` **（新增）**  
  暂停模式控制脚本，显示当前状态和可用操作选项。

- `master-all-in-one-original.sh` **（备份）**  
  原始主自动化脚本的备份，用于恢复完整功能。

### 外部CI/CD控制脚本

- `disable-external-cicd.sh` **（新增）**  
  批量禁用所有外部仓库的GitHub Actions工作流。

- `enable-external-cicd.sh` **（新增）**  
  批量重新启用所有外部仓库的GitHub Actions工作流。

### 原有功能脚本（当前已暂停）

- `merge-repos-to-main.sh`  
  按 `merge.txt` 清单，将指定仓库代码合并到主仓库的 `apps/` 目录。

- `standardize-keep-repos.sh`  
  对 `keep.txt` 清单中的仓库自动应用标准化模板（如 CI/CD、README、依赖等）。

- `branch-protect-keep.sh`  
  对 `keep.txt` 清单中的仓库主分支开启分支保护策略。

- `archive-unused-repos.sh`  
  按 `archive.txt` 清单归档不再维护的仓库。

- `compare-merge-result.sh`  
  自动对比 `merge.txt` 清单与 `apps/` 目录，输出已合并和未合并仓库列表。

- `apply-template.sh`  
  用于批量应用项目模板到指定仓库。

- `delete-unused-repos.sh`  
  批量删除不再维护的仓库。

### 测试脚本

- `test-automation-pause.sh` **（新增）**  
  测试自动化暂停功能的完整性。

## 辅助清单文件

- `merge.txt`  
  需合并到主仓库的仓库名列表。

- `keep.txt`  
  需保留并持续维护的仓库名列表。

- `archive.txt`  
  需归档或删除的仓库名列表。

- `inventory-marked.json`  
  仓库分类及标记的详细数据。

- `repos.json`  
  仓库基础信息清单。

## 临时目录

- `__merge/`  
  用于存放临时克隆的仓库代码，合并完成后可清理。

---

## 使用说明

1. 按需编辑清单文件（如 `merge.txt`）。
2. 运行对应脚本自动化处理。
3. 合并完成后，建议清理 `__merge` 目录。

---
