#!/usr/bin/env bash
# filepath: scripts/auto-resolve-conflicts.sh

# 自动解决冲突，在冲突内容中自动删除出图内容的上半部分
# Auto-resolve conflicts by automatically deleting the upper half of conflict content

set -e

# 默认处理 pnpm-lock.yaml，但可以接受其他文件作为参数
TARGET_FILE="${1:-pnpm-lock.yaml}"

if [ ! -f "$TARGET_FILE" ]; then
  echo "错误：未找到文件 $TARGET_FILE"
  echo "Error: File $TARGET_FILE not found"
  exit 1
fi

echo "开始处理冲突文件: $TARGET_FILE"
echo "Processing conflict file: $TARGET_FILE"

# 备份原文件
BACKUP_FILE="$TARGET_FILE.conflict-backup-$(date +%Y%m%d_%H%M%S)"
cp "$TARGET_FILE" "$BACKUP_FILE"
echo "已创建备份: $BACKUP_FILE"
echo "Backup created: $BACKUP_FILE"

# 创建临时文件来处理内容
TEMP_FILE=$(mktemp)
trap "rm -f $TEMP_FILE" EXIT

# 使用 Python 来处理复杂的冲突解决逻辑
python3 - "$TARGET_FILE" "$TEMP_FILE" << 'EOF'
import sys
import re

def resolve_conflicts(input_file, output_file):
    """
    解决 Git 冲突标记，删除下半部分（incoming branch）内容，保留上半部分（HEAD）内容
    Resolve Git conflict markers by removing lower half (incoming branch) content and keeping upper half (HEAD)
    """
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    lines = content.split('\n')
    result_lines = []
    i = 0
    conflicts_resolved = 0
    orphan_endings_removed = 0
    
    while i < len(lines):
        line = lines[i]
        
        # 检查是否是孤立的结束标记（没有对应的开始标记）
        if line.startswith('>>>>>>> '):
            orphan_endings_removed += 1
            print(f"警告: 在行 {i+1} 发现孤立的结束标记，已删除")
            print(f"Warning: Orphan end marker found at line {i+1}, removed")
            i += 1
            continue
        
        # 检查是否是冲突开始标记
        if line.startswith('<<<<<<< '):
            conflicts_resolved += 1
            conflict_start = i
            
            # 查找分隔符和结束标记
            separator_index = None
            end_index = None
            
            j = i + 1
            while j < len(lines):
                if lines[j].startswith('======='):
                    separator_index = j
                elif lines[j].startswith('>>>>>>> '):
                    end_index = j
                    break
                j += 1
            
            if end_index is None:
                # 没有找到结束标记，可能是不完整的冲突
                print(f"警告: 在行 {i+1} 发现不完整的冲突标记")
                print(f"Warning: Incomplete conflict marker found at line {i+1}")
                
                # 查找下一个可能的结束标记
                j = i + 1
                while j < len(lines):
                    if lines[j].startswith('>>>>>>> '):
                        end_index = j
                        break
                    j += 1
                
                if end_index is None:
                    # 仍然没有找到，跳过这行
                    result_lines.append(line)
                    i += 1
                    continue
            
            # 处理冲突内容
            if separator_index is not None:
                # 标准冲突：有分隔符
                # 删除下半部分（incoming branch 内容），保留上半部分（HEAD 内容）
                upper_half_start = conflict_start + 1
                upper_half_end = separator_index
                
                # 添加上半部分内容到结果
                for k in range(upper_half_start, upper_half_end):
                    result_lines.append(lines[k])
            else:
                # 没有分隔符的情况，可能是格式异常
                # 在这种情况下，我们删除整个冲突块
                print(f"警告: 在行 {i+1} 发现没有分隔符的冲突标记，删除整个冲突块")
                print(f"Warning: Conflict marker without separator at line {i+1}, removing entire block")
            
            # 跳到冲突结束之后
            i = end_index + 1
            
        else:
            # 普通行，直接添加
            result_lines.append(line)
            i += 1
    
    # 写入结果
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(result_lines))
        if result_lines and not content.endswith('\n'):
            f.write('\n')
    
    print(f"共解决了 {conflicts_resolved} 个冲突")
    print(f"Resolved {conflicts_resolved} conflicts")
    
    if orphan_endings_removed > 0:
        print(f"移除了 {orphan_endings_removed} 个孤立的结束标记")
        print(f"Removed {orphan_endings_removed} orphan end markers")
    
    return conflicts_resolved

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 script.py input_file output_file")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    try:
        conflicts_resolved = resolve_conflicts(input_file, output_file)
        if conflicts_resolved > 0:
            print(f"成功解决冲突，已保存到临时文件")
            print(f"Conflicts resolved successfully, saved to temporary file")
        else:
            print("未发现冲突标记")
            print("No conflict markers found")
    except Exception as e:
        print(f"错误: {e}")
        print(f"Error: {e}")
        sys.exit(1)
EOF

# 检查 Python 脚本是否成功执行
if [ $? -eq 0 ] && [ -f "$TEMP_FILE" ]; then
    # 将处理后的内容替换原文件
    mv "$TEMP_FILE" "$TARGET_FILE"
    echo "冲突解决完成！"
    echo "Conflict resolution completed!"
    echo ""
    echo "建议后续操作:"
    echo "Recommended next steps:"
    if [ "$TARGET_FILE" = "pnpm-lock.yaml" ]; then
        echo "1. 执行 pnpm install 重新整理依赖关系"
        echo "   Run: pnpm install to reorganize dependencies"
    fi
    echo "2. 检查文件内容确保合并正确"
    echo "   Review file content to ensure proper merge"
    echo "3. 提交更改"
    echo "   Commit the changes"
else
    echo "错误：冲突解决失败"
    echo "Error: Conflict resolution failed"
    exit 1
fi