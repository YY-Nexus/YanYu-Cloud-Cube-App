#!/usr/bin/env bash
# filepath: scripts/auto-resolve-package-conflicts.sh

# 自动解决 package.json 冲突的专用脚本
# Auto-resolve package.json conflicts with intelligent dependency merging

set -e

# 默认处理 package.json，但可以接受其他文件作为参数
TARGET_FILE="${1:-package.json}"

if [ ! -f "$TARGET_FILE" ]; then
  echo "错误：未找到文件 $TARGET_FILE"
  echo "Error: File $TARGET_FILE not found"
  exit 1
fi

echo "开始处理 package.json 冲突文件: $TARGET_FILE"
echo "Processing package.json conflict file: $TARGET_FILE"

# 备份原文件
BACKUP_FILE="$TARGET_FILE.package-conflict-backup-$(date +%Y%m%d_%H%M%S)"
cp "$TARGET_FILE" "$BACKUP_FILE"
echo "已创建备份: $BACKUP_FILE"
echo "Backup created: $BACKUP_FILE"

# 创建临时文件来处理内容
TEMP_FILE=$(mktemp)

# 使用 Node.js 脚本智能合并 package.json 冲突
cat > "$TEMP_FILE.merge.js" << 'EOF'
const fs = require('fs');
const path = require('path');

function mergePackageJsonConflicts(filePath) {
    const content = fs.readFileSync(filePath, 'utf8');
    const lines = content.split('\n');
    let result = [];
    let conflictsResolved = 0;
    let inConflict = false;
    let headSection = [];
    let incomingSection = [];
    let currentSection = 'head';
    
    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        
        if (line.startsWith('<<<<<<< ')) {
            inConflict = true;
            conflictsResolved++;
            headSection = [];
            incomingSection = [];
            currentSection = 'head';
            continue;
        }
        
        if (line.startsWith('=======') && inConflict) {
            currentSection = 'incoming';
            continue;
        }
        
        if (line.startsWith('>>>>>>> ') && inConflict) {
            // 智能合并 package.json 内容
            const mergedContent = intelligentMerge(headSection, incomingSection);
            result.push(...mergedContent);
            
            inConflict = false;
            headSection = [];
            incomingSection = [];
            continue;
        }
        
        if (inConflict) {
            if (currentSection === 'head') {
                headSection.push(line);
            } else {
                incomingSection.push(line);
            }
        } else {
            result.push(line);
        }
    }
    
    console.log(`已解决 ${conflictsResolved} 个 package.json 冲突`);
    console.log(`Resolved ${conflictsResolved} package.json conflicts`);
    
    return result.join('\n');
}

function intelligentMerge(headLines, incomingLines) {
    try {
        // 尝试解析为 JSON 对象进行智能合并
        const headText = headLines.join('\n');
        const incomingText = incomingLines.join('\n');
        
        // 检查是否为有效的 JSON 片段
        if (isValidJsonFragment(headText) && isValidJsonFragment(incomingText)) {
            return mergeJsonFragments(headText, incomingText);
        }
    } catch (e) {
        console.log('无法解析为 JSON，使用默认策略');
        console.log('Cannot parse as JSON, using default strategy');
    }
    
    // 默认策略：保留 HEAD 内容
    return headLines;
}

function isValidJsonFragment(text) {
    // 简单检查是否包含 JSON 对象或数组的特征
    const trimmed = text.trim();
    return trimmed.includes('"') && (trimmed.includes(':') || trimmed.includes('['));
}

function mergeJsonFragments(headText, incomingText) {
    // 对于 dependencies 和 devDependencies，合并所有包
    if (headText.includes('"dependencies"') || headText.includes('"devDependencies"') || 
        headText.includes('"scripts"')) {
        
        try {
            // 尝试解析并合并对象
            const headObj = parsePartialJson(headText);
            const incomingObj = parsePartialJson(incomingText);
            
            if (headObj && incomingObj) {
                const merged = mergeObjects(headObj, incomingObj);
                return formatJsonFragment(merged, headText);
            }
        } catch (e) {
            console.log('JSON 合并失败，使用默认策略');
            console.log('JSON merge failed, using default strategy');
        }
    }
    
    // 默认返回 HEAD 内容
    return headText.split('\n');
}

function parsePartialJson(text) {
    // 尝试提取 JSON 对象
    const lines = text.split('\n');
    let jsonStr = '';
    let braceCount = 0;
    let started = false;
    
    for (const line of lines) {
        if (line.trim().includes('{')) {
            started = true;
        }
        if (started) {
            jsonStr += line + '\n';
            braceCount += (line.match(/{/g) || []).length;
            braceCount -= (line.match(/}/g) || []).length;
            if (braceCount === 0 && started) {
                break;
            }
        }
    }
    
    try {
        return JSON.parse(jsonStr.trim());
    } catch (e) {
        return null;
    }
}

function mergeObjects(head, incoming) {
    const result = { ...head };
    
    for (const key in incoming) {
        if (incoming.hasOwnProperty(key)) {
            if (typeof incoming[key] === 'object' && typeof head[key] === 'object' && 
                !Array.isArray(incoming[key]) && !Array.isArray(head[key])) {
                // 递归合并对象
                result[key] = { ...head[key], ...incoming[key] };
            } else if (!head.hasOwnProperty(key)) {
                // 如果 HEAD 中没有这个键，添加它
                result[key] = incoming[key];
            }
            // 如果 HEAD 中已有，保留 HEAD 的值（优先级策略）
        }
    }
    
    return result;
}

function formatJsonFragment(obj, originalText) {
    const formatted = JSON.stringify(obj, null, 2);
    const lines = formatted.split('\n');
    
    // 保持原有的缩进风格
    const firstLine = originalText.split('\n')[0];
    const indent = firstLine.match(/^\s*/)[0];
    
    return lines.map((line, index) => {
        if (index === 0 || index === lines.length - 1) {
            return indent + line.trim();
        }
        return indent + '  ' + line.trim();
    });
}

// 主函数
const targetFile = process.argv[2] || 'package.json';
const outputFile = process.argv[3] || targetFile + '.resolved';

const resolvedContent = mergePackageJsonConflicts(targetFile);
fs.writeFileSync(outputFile, resolvedContent);

console.log(`冲突解决完成，输出到: ${outputFile}`);
console.log(`Conflict resolution completed, output to: ${outputFile}`);
EOF

# 执行 Node.js 脚本
if node "$TEMP_FILE.merge.js" "$TARGET_FILE" "$TEMP_FILE"; then
    # 将处理后的内容替换原文件
    mv "$TEMP_FILE" "$TARGET_FILE"
    
    echo ""
    echo "package.json 冲突解决完成！"
    echo "package.json conflict resolution completed!"
    echo ""
    echo "建议后续操作："
    echo "Recommended next steps:"
    echo "1. 验证 package.json 语法正确性"
    echo "   Validate package.json syntax: npm run type-check"
    echo "2. 重新安装依赖"
    echo "   Reinstall dependencies: pnpm install"
    echo "3. 检查文件内容确保合并正确"
    echo "   Review file content to ensure proper merge"
    echo "4. 提交更改"
    echo "   Commit the changes"
else
    echo "错误：package.json 冲突解决失败"
    echo "Error: package.json conflict resolution failed"
    exit 1
fi

# 清理临时文件
rm -f "$TEMP_FILE.merge.js"