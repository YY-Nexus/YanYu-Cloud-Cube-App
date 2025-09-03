import { readFileSync, writeFileSync } from 'fs'

const inventory = JSON.parse(readFileSync('inventory.json', 'utf8'))

function mark(item: any) {
  // 没有 package.json 或 Next.js 版本为空
  if (item.hasPackage === false || !item.nextVersion)
    return { ...item, recommendedAction: 'ARCHIVE' }
  // 体积小于10MB且只有pages
  if (item.sizeMB < 10 && item.pageRouterOnly) return { ...item, recommendedAction: 'MERGE' }
  // 近期开发，Next.js >=14，TypeScript，且非重复
  if (
    parseFloat(item.nextVersion.replace(/[^\d.]/g, '')) >= 14 &&
    item.usesTypeScript &&
    !item.duplicationCandidate
  )
    return { ...item, recommendedAction: 'KEEP' }
  // 仅Next.js 13及以下，或依赖老旧
  if (parseFloat(item.nextVersion.replace(/[^\d.]/g, '')) < 14)
    return { ...item, recommendedAction: 'MERGE' }
  // 其它情况
  return { ...item, recommendedAction: 'ARCHIVE' }
}

const marked = inventory.map(mark)
writeFileSync('inventory-marked.json', JSON.stringify(marked, null, 2))
console.log('Done: inventory-marked.json')
