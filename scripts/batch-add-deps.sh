# filepath: scripts/batch-add-deps.sh
for pkg in __merge/*/package.json; do
  pnpm add lodash --filter $(dirname $pkg)
done