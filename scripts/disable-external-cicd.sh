#!/usr/bin/env bash
# scripts/disable-external-cicd.sh
# 
# 停用所有外部仓库的CI/CD工作流，仅保留主仓库的自动化运维
# Disable CI/CD workflows in all external repositories, keep only main repo automation

set -e

KEEP_LIST="scripts/keep.txt"
ORG="YY-Nexus"
WORKFLOW_DISABLE_LOG="scripts/disabled-workflows.log"

echo "开始停用外部仓库CI/CD工作流..."
echo "Starting to disable external repository CI/CD workflows..."
echo "$(date): 开始批量停用外部仓库CI/CD" > "$WORKFLOW_DISABLE_LOG"

# 清理之前的日志内容，但保留时间戳
echo "禁用的工作流日志:" >> "$WORKFLOW_DISABLE_LOG"
echo "Disabled workflows log:" >> "$WORKFLOW_DISABLE_LOG"
echo "========================" >> "$WORKFLOW_DISABLE_LOG"

while read -r repo; do
  # 移除引号
  repo=$(echo "$repo" | tr -d '"')
  
  if [ -z "$repo" ] || [[ "$repo" == \#* ]]; then
    continue
  fi
  
  echo "处理仓库: $repo"
  echo "Processing repository: $repo"
  
  # 获取该仓库的所有工作流
  workflows=$(gh api "/repos/$ORG/$repo/actions/workflows" --jq '.workflows[] | .id' 2>/dev/null || echo "")
  
  if [ -z "$workflows" ]; then
    echo "  仓库 $repo 没有工作流或无法访问"
    echo "  Repository $repo has no workflows or is inaccessible" 
    echo "$repo: 无工作流或无法访问" >> "$WORKFLOW_DISABLE_LOG"
    continue
  fi
  
  # 禁用每个工作流
  echo "$workflows" | while read -r workflow_id; do
    if [ -n "$workflow_id" ]; then
      echo "  禁用工作流 ID: $workflow_id"
      echo "  Disabling workflow ID: $workflow_id"
      
      # 尝试禁用工作流
      if gh api -X PUT "/repos/$ORG/$repo/actions/workflows/$workflow_id/disable" 2>/dev/null; then
        echo "    ✓ 成功禁用"
        echo "    ✓ Successfully disabled"
        echo "$repo: workflow-$workflow_id 已禁用" >> "$WORKFLOW_DISABLE_LOG"
      else
        echo "    ✗ 禁用失败（可能已经禁用或权限不足）"
        echo "    ✗ Failed to disable (may already be disabled or insufficient permissions)"
        echo "$repo: workflow-$workflow_id 禁用失败" >> "$WORKFLOW_DISABLE_LOG"
      fi
    fi
  done
  
  echo "  仓库 $repo 处理完成"
  echo "  Repository $repo processing completed"
  echo ""
  
done < "$KEEP_LIST"

echo "$(date): 批量停用外部仓库CI/CD完成" >> "$WORKFLOW_DISABLE_LOG"
echo "外部仓库CI/CD工作流禁用完成！"
echo "External repository CI/CD workflow disabling completed!"
echo ""
echo "日志文件: $WORKFLOW_DISABLE_LOG"
echo "Log file: $WORKFLOW_DISABLE_LOG"
echo ""
echo "注意：此操作仅停用CI/CD工作流，不影响仓库代码"
echo "Note: This operation only disables CI/CD workflows, does not affect repository code"