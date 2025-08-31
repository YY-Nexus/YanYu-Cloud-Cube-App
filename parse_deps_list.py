with open('deps.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()

deps = {}
for line in lines:
    if ':' not in line or not line.strip():
        continue
    parts = line.strip().rsplit(':', 1)
    if len(parts) == 2:
        name, version = parts
        deps.setdefault(name, []).append(version)

for name, versions in deps.items():
    print(f"{name}: {', '.join(versions)}")