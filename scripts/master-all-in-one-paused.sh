#!/usr/bin/env bash
# scripts/master-all-in-one-paused.sh
#
# 暂停版本的主自动化脚本 - 停用对外部仓库的所有CI/CD操作
# Paused version of master automation script - disables all CI/CD operations on external repositories

echo "=========================================="
echo "主自动化脚本 - 暂停模式"
echo "Master Automation Script - PAUSED MODE"
echo "=========================================="
echo ""
echo "当前模式：仅优先主仓库进行整套自动化运维审核"
echo "Current mode: Only prioritize main repository for full automated operations review"
echo ""
echo "已暂停的操作 (Paused operations):"
echo "1. ❌ 自动分类 (Auto classification)"
echo "2. ❌ 合并MERGE仓库到主仓 (Merge repos to main)"  
echo "3. ❌ KEEP仓库自动标准化 (Auto standardize KEEP repos)"
echo "4. ❌ KEEP仓库分支保护 (Branch protection for KEEP repos)"
echo "5. ❌ 自动归档ARCHIVE仓库 (Auto archive repos)"
echo ""
echo "可用操作 (Available operations):"
echo "- 运行 'scripts/disable-external-cicd.sh' 停用外部仓库CI/CD"
echo "- Run 'scripts/disable-external-cicd.sh' to disable external repo CI/CD"
echo ""
echo "- 运行 'scripts/enable-external-cicd.sh' 恢复外部仓库CI/CD"  
echo "- Run 'scripts/enable-external-cicd.sh' to restore external repo CI/CD"
echo ""
echo "- 运行 'scripts/master-all-in-one.sh' 恢复完整自动化（谨慎使用）"
echo "- Run 'scripts/master-all-in-one.sh' to restore full automation (use with caution)"
echo ""
echo "=========================================="
echo "当前专注：主仓库 YanYu-Cloud-Cube-App 的自动化运维审核"
echo "Current focus: Main repository YanYu-Cloud-Cube-App automation review"
echo "=========================================="

# 检查是否有参数要求强制执行原始脚本
if [ "$1" = "--force-original" ]; then
  echo ""
  echo "⚠️  警告：强制执行原始自动化脚本"
  echo "⚠️  Warning: Force executing original automation script"
  echo ""
  read -p "确认继续？这将影响所有外部仓库 (Continue? This will affect all external repos) [y/N]: " confirm
  if [[ $confirm =~ ^[Yy]$ ]]; then
    echo "执行原始脚本..."
    echo "Executing original script..."
    
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
  else
    echo "已取消执行"
    echo "Execution cancelled"
  fi
else
  echo ""
  echo "如需执行原始自动化脚本，请使用："
  echo "To execute original automation script, use:"
  echo "bash scripts/master-all-in-one-paused.sh --force-original"
fi