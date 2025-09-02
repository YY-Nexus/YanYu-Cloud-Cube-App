#!/usr/bin/env bash
# 测试自动冲突解决脚本

set -e

TEST_DIR="/tmp/conflict-resolution-test"
SCRIPT_DIR="/home/runner/work/YanYu-Cloud-Cube-App/YanYu-Cloud-Cube-App/scripts"

# 清理和准备测试环境
setup_test() {
    rm -rf "$TEST_DIR"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # 复制脚本到测试目录
    cp "$SCRIPT_DIR/auto-fix-pnpm-lock-conflicts.sh" .
    cp "$SCRIPT_DIR/fix-pnpm-lockfile.py" .
    mkdir -p scripts
    cp "$SCRIPT_DIR/fix-pnpm-lockfile.py" scripts/
}

# 测试1: package.json冲突
test_package_json_conflict() {
    echo "=== 测试 package.json 冲突解决 ==="
    
    cat > package.json << 'EOF'
{
  "name": "test-app",
  "dependencies": {
<<<<<<< HEAD
    "react": "^18.0.0",
    "lodash": "^4.17.21"
=======
    "react": "^19.0.0",
    "axios": "^1.6.0"
>>>>>>> feature-branch
  }
}
EOF
    
    ./auto-fix-pnpm-lock-conflicts.sh
    
    if grep -q "<<<<<<< \|======\|>>>>>>> " package.json; then
        echo "❌ package.json冲突解决失败"
        return 1
    else
        echo "✅ package.json冲突解决成功"
    fi
}

# 测试2: pnpm-lock.yaml冲突标记
test_lockfile_conflict_markers() {
    echo "=== 测试 pnpm-lock.yaml 冲突标记 ==="
    
    cat > pnpm-lock.yaml << 'EOF'
lockfileVersion: '9.0'

importers:
  .:
    dependencies:
      react:
<<<<<<< HEAD
        specifier: ^18.0.0
        version: 18.2.0
=======
        specifier: ^19.0.0
        version: 19.1.1
>>>>>>> feature-branch

packages:
  react@18.2.0: {}
  react@19.1.1: {}
EOF
    
    ./auto-fix-pnpm-lock-conflicts.sh
    
    if grep -q "<<<<<<< \|======\|>>>>>>> " pnpm-lock.yaml; then
        echo "❌ pnpm-lock.yaml冲突标记解决失败"
        return 1
    else
        echo "✅ pnpm-lock.yaml冲突标记解决成功"
    fi
}

# 测试3: 配置文件冲突
test_config_conflicts() {
    echo "=== 测试配置文件冲突解决 ==="
    
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
<<<<<<< HEAD
    "target": "ES2020",
    "strict": true
=======
    "target": "ES2022",
    "strict": false
>>>>>>> feature-branch
  }
}
EOF
    
    ./auto-fix-pnpm-lock-conflicts.sh
    
    if grep -q "<<<<<<< \|======\|>>>>>>> " tsconfig.json; then
        echo "❌ tsconfig.json冲突解决失败"
        return 1
    else
        echo "✅ tsconfig.json冲突解决成功"
    fi
}

# 测试4: 备份功能
test_backup_functionality() {
    echo "=== 测试备份功能 ==="
    
    echo '{"test": "data"}' > test-file.json
    echo '<<<<<<< HEAD' >> test-file.json
    echo '"conflict": "version1"' >> test-file.json
    echo '=======' >> test-file.json
    echo '"conflict": "version2"' >> test-file.json
    echo '>>>>>>> branch' >> test-file.json
    echo '}' >> test-file.json
    
    ./auto-fix-pnpm-lock-conflicts.sh
    
    if [ -d ".conflict-backups" ] && [ -f ".conflict-backups"/*.bak ]; then
        echo "✅ 备份功能正常"
    else
        echo "❌ 备份功能失败"
        return 1
    fi
}

# 运行所有测试
run_tests() {
    setup_test
    
    local failed=0
    
    test_package_json_conflict || ((failed++))
    test_lockfile_conflict_markers || ((failed++))
    test_config_conflicts || ((failed++))
    test_backup_functionality || ((failed++))
    
    cd /
    
    if [ $failed -eq 0 ]; then
        echo "🎉 所有测试通过！"
        return 0
    else
        echo "❌ $failed 个测试失败"
        return 1
    fi
}

# 清理测试环境
cleanup() {
    rm -rf "$TEST_DIR"
}

# 主函数
main() {
    echo "开始冲突解决脚本测试..."
    
    if run_tests; then
        echo "测试完成 - 成功"
        cleanup
        exit 0
    else
        echo "测试完成 - 失败"
        echo "测试文件保留在: $TEST_DIR"
        exit 1
    fi
}

main "$@"