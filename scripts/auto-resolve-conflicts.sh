#!/usr/bin/env bash
#
# 自动合并脚本：删除冲突块的上半部分 (<<<<<<< 与 ======= 之间的内容)，保留下半部分
# 即：保留“下方版本” (通常是当前合并进来的分支内容)
#
# Automatic merge helper:
# For every Git conflict block:
#   <<<<<<< HEAD (or branch A)
#       (UPPER PART)   <-- will be discarded
#   =======
#       (LOWER PART)   <-- will be KEPT
#   >>>>>>> other
#
# 使用场景：你确定要统一采用冲突中“下半部分”版本时。
#

set -euo pipefail

# Color output support
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
  echo -e "${RED}❌ $1${NC}" >&2
}

usage() {
  cat <<'EOF'
用法:
  auto-resolve-conflicts.sh <文件1> [文件2 ...]
说明:
  解析文件中的 Git 合并冲突块，自动删除上半部分，保留下半部分内容。

示例:
  ./scripts/auto-resolve-conflicts.sh pnpm-lock.yaml
  ./scripts/auto-resolve-conflicts.sh package.json src/config.ts

可选环境变量:
  DRY_RUN=1   只输出将生成的结果，不覆盖原文件
  NO_BACKUP=1 不生成 .bak 备份文件

退出码:
  0 成功 (即使没有发现冲突也算成功)
  1 发生错误 (文件不存在 / 处理失败)

EOF
}

if [ $# -eq 0 ]; then
  usage
  exit 1
fi

# 处理单个文件
process_file() {
  local file="$1"

  if [ ! -f "$file" ]; then
    log_error "跳过：未找到文件 $file"
    return 1
  fi

  # Check for any Git conflict markers
  if ! grep -q "<<<<<<< \|>>>>>>> \|=======" "$file" 2>/dev/null; then
    log_info "文件 $file 中未发现冲突标记，跳过。"
    echo "No conflict markers found in $file"
    return 0
  fi

  local backup=
  if [ "${NO_BACKUP:-0}" != "1" ]; then
    backup="$file.bak.$(date +%Y%m%d_%H%M%S)"
    cp "$file" "$backup"
    log_info "已创建备份: $backup"
  else
    log_warning "未创建备份 (NO_BACKUP=1)"
  fi

  local temp
  temp=$(mktemp)

  # awk 逻辑：
  # 进入冲突后先丢弃上半部分 (skip_upper=1)，遇到 ======= 后开始输出 (skip_upper=0)，
  # 遇到 >>>>>>> 结束。
  awk '
    BEGIN {
      in_conflict = 0
      skip_upper = 0
      conflict_blocks = 0
      malformed_blocks = 0
    }
    /^<<<<<<< / {
      in_conflict = 1
      skip_upper = 1
      conflict_blocks++
      next
    }
    /^=======/ {
      if (in_conflict) {
        skip_upper = 0
        next
      }
    }
    /^>>>>>>> / {
      if (in_conflict) {
        in_conflict = 0
        skip_upper = 0
        next
      }
    }
    {
      if (!in_conflict || (in_conflict && !skip_upper)) {
        print
      }
    }
    END {
      if (conflict_blocks > 0) {
        print "处理了 " conflict_blocks " 个冲突块 (保留下半部分)" > "/dev/stderr"
      } else {
        print "未检测到冲突块" > "/dev/stderr"
      }
    }
  ' "$file" > "$temp"

  if [ "${DRY_RUN:-0}" = "1" ]; then
    log_info "DRY_RUN=1 展示 $file 处理后的内容："
    echo "----- BEGIN ($file) -----"
    cat "$temp"
    echo "----- END ($file) -----"
    rm -f "$temp"
  else
    mv "$temp" "$file"
    log_success "已处理: $file (已删除冲突上半部分，保留下半部分)"
  fi

  # 提示后续动作
  if [[ "$file" == *"pnpm-lock.yaml"* ]]; then
    log_info "建议: 运行 pnpm install 以确保锁文件一致性"
  fi
  if [[ "$file" == *"package.json"* ]]; then
    log_info "建议: 检查依赖并运行 pnpm install / npm install"
  fi
}

overall_status=0
for f in "$@"; do
  if ! process_file "$f"; then
    overall_status=1
  fi
  echo ""
done

if [ "${DRY_RUN:-0}" = "1" ]; then
  log_info "DRY_RUN 模式未修改任何文件。"
fi

if [ $overall_status -eq 0 ]; then
  log_success "所有文件处理完成。"
else
  log_error "部分文件处理失败，请查看上方输出。"
fi

exit $overall_status

