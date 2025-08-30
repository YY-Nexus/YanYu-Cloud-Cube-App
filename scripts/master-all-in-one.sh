#!/usr/bin/env bash

# 主自动化脚本已切换到暂停模式
# Master automation script has been switched to paused mode
#
# 停止所有仓库的CI/CD等副驾工作，仅优先此仓库进行整套自动化运维的审核
# Stop all repository CI/CD and auxiliary work, only prioritize this repository for full automated operations review

echo "🚫 主自动化脚本当前处于暂停状态"
echo "🚫 Master automation script is currently PAUSED"
echo ""
echo "原因：停止所有外部仓库CI/CD工作，专注主仓库自动化运维审核"
echo "Reason: Stop all external repository CI/CD work, focus on main repository automation review"
echo ""
echo "如需查看暂停期间的操作选项，请运行："
echo "To see available options during pause, run:"
echo "bash scripts/master-all-in-one-paused.sh"
echo ""
echo "如需恢复原始功能，请运行："
echo "To restore original functionality, run:"
echo "bash scripts/master-all-in-one-original.sh"

# 重定向到暂停版本脚本
exec bash scripts/master-all-in-one-paused.sh "$@"