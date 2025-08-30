#!/usr/bin/env bash
# scripts/enable-external-cicd.sh
#
# 重新启用所有外部仓库的CI/CD工作流（恢复操作）
# Re-enable CI/CD workflows in all external repositories (recovery operation)

set -e

KEEP_LIST="scripts/keep.txt"
ORG="YY-Nexus"
WORKFLOW_ENABLE_LOG="scripts/enabled-workflows.log"

echo "开始重新启用外部仓库CI/CD工作流..."
echo "Starting to re-enable external repository CI/CD workflows..."
echo "$(date): 开始批量启用外部仓库CI/CD" > "$WORKFLOW_ENABLE_LOG"

# 清理之前的日志内容，但保留时间戳
echo "启用的工作流日志:" >> "$WORKFLOW_ENABLE_LOG"
echo "Enabled workflows log:" >> "$WORKFLOW_ENABLE_LOG"
echo "========================" >> "$WORKFLOW_ENABLE_LOG"

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
    echo "$repo: 无工作流或无法访问" >> "$WORKFLOW_ENABLE_LOG"
    continue
  fi
  
  # 启用每个工作流
  echo "$workflows" | while read -r workflow_id; do
    if [ -n "$workflow_id" ]; then
      echo "  启用工作流 ID: $workflow_id"
      echo "  Enabling workflow ID: $workflow_id"
      
      # 尝试启用工作流
      if gh api -X PUT "/repos/$ORG/$repo/actions/workflows/$workflow_id/enable" 2>/dev/null; then
        echo "    ✓ 成功启用"
        echo "    ✓ Successfully enabled"
        echo "$repo: workflow-$workflow_id 已启用" >> "$WORKFLOW_ENABLE_LOG"
      else
        echo "    ✗ 启用失败（可能已经启用或权限不足）"
        echo "    ✗ Failed to enable (may already be enabled or insufficient permissions)"
        echo "$repo: workflow-$workflow_id 启用失败" >> "$WORKFLOW_ENABLE_LOG"
      fi
    fi
  done
  
  echo "  仓库 $repo 处理完成"
  echo "  Repository $repo processing completed"
  echo ""
  
done < "$KEEP_LIST"

echo "$(date): 批量启用外部仓库CI/CD完成" >> "$WORKFLOW_ENABLE_LOG"
echo "外部仓库CI/CD工作流启用完成！"
echo "External repository CI/CD workflow enabling completed!"
echo ""
echo "日志文件: $WORKFLOW_ENABLE_LOG"
echo "Log file: $WORKFLOW_ENABLE_LOG"
echo ""
echo "注意：此操作重新启用CI/CD工作流"
echo "Note: This operation re-enables CI/CD workflows"