import yaml

# 读取 pnpm-lock.yaml 文件
with open('pnpm-lock.yaml', 'r', encoding='utf-8') as f:
    data = yaml.safe_load(f)

# pnpm-lock.yaml 的依赖通常在 'packages' 字段下
packages = data.get('packages', {})

print("依赖包列表：")
for pkg, info in packages.items():
    # 包名通常在 pkg 路径里，版本在 info['version']
    # 例如: '/react@18.2.0' -> react, 18.2.0
    if '@' in pkg:
        name_version = pkg.lstrip('/').split('@')
        name = name_version[0]
        version = name_version[1] if len(name_version) > 1 else info.get('version', '未知')
    else:
        name = pkg.lstrip('/')
        version = info.get('version', '未知')
    print(f"{name}: {version}")