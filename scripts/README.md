# scripts 目录说明

本目录用于存放项目自动化管理脚本及辅助清单文件，方便团队协作和批量操作。

## 主要脚本及用途

- `master-all-in-one.sh`  
  一键执行所有分类处理脚本，包括仓库分类、合并、标准化、分支保护和归档。

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
