#!/usr/bin/env bash
set -e

if [ -z "$VERCEL_TOKEN" ] || [ -z "$PROD_ALIAS" ]; then
  echo "Need VERCEL_TOKEN and PROD_ALIAS env."
  exit 1
fi

echo "Fetching deployments..."
# 获取最近两次部署
DEPLOYMENTS=$(vercel list --token "$VERCEL_TOKEN" --limit 5 | grep "$PROD_ALIAS" -B1 | awk '{print $1}' | head -n 2)
TARGET=$(echo "$DEPLOYMENTS" | tail -n 1)

if [ -z "$TARGET" ]; then
  echo "No previous deployment found."
  exit 1
fi

echo "Rolling back to $TARGET ..."
vercel alias set "$TARGET" "$PROD_ALIAS" --token "$VERCEL_TOKEN"
echo "Rollback complete."
