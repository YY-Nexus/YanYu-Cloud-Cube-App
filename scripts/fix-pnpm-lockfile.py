#!/usr/bin/env python3
"""
智能修复 pnpm-lock.yaml 文件中的冲突和重复项
"""

import sys
import re
import shutil
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Set


def log_info(message: str):
    print(f"[INFO] {message}")


def log_warn(message: str):
    print(f"[WARN] {message}")


def log_error(message: str):
    print(f"[ERROR] {message}")


def backup_file(file_path: Path) -> Path:
    """创建文件备份"""
    backup_dir = Path(".conflict-backups")
    backup_dir.mkdir(exist_ok=True)
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = backup_dir / f"{file_path.name}.{timestamp}.bak"
    
    shutil.copy2(file_path, backup_path)
    log_info(f"备份文件: {file_path} -> {backup_path}")
    return backup_path


def remove_conflict_markers(content: str) -> str:
    """移除Git冲突标记"""
    lines = content.split('\n')
    filtered_lines = []
    
    for line in lines:
        if not (line.startswith('<<<<<<<') or 
                line.startswith('=======') or 
                line.startswith('>>>>>>>')):
            filtered_lines.append(line)
    
    return '\n'.join(filtered_lines)


def fix_duplicate_packages_simple(content: str) -> str:
    """使用简单方法修复重复包定义 - 移除空的重复项"""
    lines = content.split('\n')
    result_lines = []
    seen_packages: Dict[str, int] = {}  # 包名 -> 第一次出现的行号
    
    for i, line in enumerate(lines):
        # 在packages部分查找包定义
        if re.match(r'^  [^:\s]+@[^:]*:\s*$', line.strip()) or re.match(r'^  [^:\s]+@[^:]*:\s*\{\}\s*$', line.strip()):
            # 提取包名和版本
            package_match = re.match(r'^  ([^:\s]+@[^:]*):(.*)$', line.strip())
            if package_match:
                package_key = package_match.group(1).strip()
                package_content = package_match.group(2).strip()
                
                if package_key in seen_packages:
                    # 如果当前是空定义 {}，跳过它
                    if package_content == '{}' or package_content == '':
                        log_warn(f"跳过重复的空包定义: {package_key}")
                        continue
                    # 如果之前是空定义，替换之前的
                    else:
                        log_warn(f"发现重复包定义，保留有内容的版本: {package_key}")
                
                seen_packages[package_key] = i
        
        result_lines.append(line)
    
    return '\n'.join(result_lines)


def validate_yaml_syntax(content: str) -> bool:
    """简单的YAML语法验证"""
    try:
        lines = content.split('\n')
        for i, line in enumerate(lines, 1):
            # 检查制表符
            if '\t' in line:
                log_warn(f"第{i}行包含制表符，可能导致YAML解析错误")
                return False
        
        return True
    except Exception as e:
        log_error(f"YAML验证失败: {e}")
        return False


def fix_pnpm_lockfile(file_path: Path) -> bool:
    """修复pnpm-lock.yaml文件"""
    if not file_path.exists():
        log_error(f"文件不存在: {file_path}")
        return False
    
    log_info(f"开始修复lockfile: {file_path}")
    
    # 备份原文件
    backup_file(file_path)
    
    # 读取文件内容
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        log_error(f"读取文件失败: {e}")
        return False
    
    original_content = content
    
    # 移除冲突标记
    content = remove_conflict_markers(content)
    
    # 修复重复包定义
    content = fix_duplicate_packages_simple(content)
    
    # 写回文件
    try:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        if content != original_content:
            log_info("成功修复lockfile")
        else:
            log_info("lockfile无需修复")
        
        return True
    except Exception as e:
        log_error(f"写入文件失败: {e}")
        return False


def main():
    """主函数"""
    lockfile_path = Path("pnpm-lock.yaml")
    
    if len(sys.argv) > 1:
        lockfile_path = Path(sys.argv[1])
    
    success = fix_pnpm_lockfile(lockfile_path)
    
    if success:
        log_info("Lockfile修复完成")
        sys.exit(0)
    else:
        log_error("Lockfile修复失败")
        sys.exit(1)


if __name__ == "__main__":
    main()