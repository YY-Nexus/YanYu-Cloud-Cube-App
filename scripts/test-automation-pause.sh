#!/usr/bin/env bash
# scripts/test-automation-pause.sh
# 
# 测试自动化暂停功能
# Test automation pause functionality

echo "=========================================="
echo "测试自动化暂停功能"
echo "Testing Automation Pause Functionality"
echo "=========================================="

echo ""
echo "1. 测试主自动化脚本暂停状态"
echo "1. Testing master automation script pause status"
echo "-----------------------------"
bash scripts/master-all-in-one.sh
echo ""

echo "2. 检查新增的脚本文件"
echo "2. Checking new script files"
echo "-----------------------------"
ls -la scripts/ | grep -E "(disable|enable|paused|original)" || echo "Scripts not found"
echo ""

echo "3. 验证文档创建"
echo "3. Verifying documentation creation"
echo "-----------------------------"
if [ -f "docs/external-automation-pause.md" ]; then
    echo "✓ 外部自动化暂停文档已创建"
    echo "✓ External automation pause documentation created"
    echo "文件大小: $(wc -l < docs/external-automation-pause.md) 行"
    echo "File size: $(wc -l < docs/external-automation-pause.md) lines"
else
    echo "✗ 文档文件未找到"
    echo "✗ Documentation file not found"
fi
echo ""

echo "4. 检查脚本权限"
echo "4. Checking script permissions"
echo "-----------------------------"
for script in disable-external-cicd.sh enable-external-cicd.sh master-all-in-one-paused.sh; do
    if [ -x "scripts/$script" ]; then
        echo "✓ $script 具有执行权限"
        echo "✓ $script has execute permission"
    else
        echo "✗ $script 缺少执行权限"
        echo "✗ $script missing execute permission"
    fi
done
echo ""

echo "5. 测试暂停模式脚本"
echo "5. Testing pause mode script"
echo "-----------------------------"
bash scripts/master-all-in-one-paused.sh --help 2>/dev/null || echo "Pause mode script executed (no --help option available)"
echo ""

echo "=========================================="
echo "测试完成！"
echo "Testing completed!"
echo "=========================================="