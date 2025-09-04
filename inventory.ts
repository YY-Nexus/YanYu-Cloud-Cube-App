import { execSync } from 'node:child_process'
import { existsSync, readFileSync, writeFileSync } from 'node:fs'
import { mkdirSync } from 'node:fs'
import path from 'node:path'

interface RepoMeta {
  name: string
  url: string
  defaultBranchRef: { name: string }
  pushedAt: string
  isPrivate: boolean
}

const raw = JSON.parse(readFileSync('repos.json', 'utf-8')) as RepoMeta[]
const out: any[] = []

const WORKDIR = '___clones'
mkdirSync(WORKDIR, { recursive: true })

function daysAgo(dateStr: string) {
  const d = new Date(dateStr)
  return Math.floor((Date.now() - d.getTime()) / 86400000)
}

for (const repo of raw) {
  const dir = path.join(WORKDIR, repo.name)
  if (!existsSync(dir)) {
    console.log('Cloning', repo.name)
    try {
      execSync(`gh repo clone YY-Nexus/${repo.name} ${dir} -- --depth=1`, { stdio: 'ignore' })
    } catch {
      console.warn('Clone failed', repo.name)
      continue
    }
  }
  const pkgPath = path.join(dir, 'package.json')
  if (!existsSync(pkgPath)) {
    out.push({
      repo: repo.name,
      hasPackage: false,
      nextVersion: '',
      usesTypeScript: false,
      eslintConfigured: false,
      prettierConfigured: false,
      hasAppDir: false,
      pageRouterOnly: false,
      testFramework: '',
      hasCI: false,
      lastCommitDays: daysAgo(repo.pushedAt),
      packageManager: '',
      duplicationCandidate: /demo|test|model|example/i.test(repo.name),
    })
    continue
  }
  const pkg = JSON.parse(readFileSync(pkgPath, 'utf-8'))
  const deps = { ...pkg.dependencies, ...pkg.devDependencies }
  const nextVersion = deps.next || ''
  const ts =
    existsSync(path.join(dir, 'tsconfig.json')) || existsSync(path.join(dir, 'tsconfig.base.json'))
  const eslintConfigured = ['.eslintrc.js', '.eslintrc.cjs', '.eslintrc.json', '.eslintrc'].some(
    (f) => existsSync(path.join(dir, f)),
  )
  const prettierConfigured = [
    '.prettierrc',
    '.prettierrc.js',
    '.prettierrc.cjs',
    '.prettierrc.json',
  ].some((f) => existsSync(path.join(dir, f)))
  const hasAppDir = existsSync(path.join(dir, 'app'))
  const hasPagesDir = existsSync(path.join(dir, 'pages'))
  const testFramework = deps.vitest ? 'vitest' : deps.jest ? 'jest' : ''
  const hasCI = existsSync(path.join(dir, '.github', 'workflows'))
  const pm = existsSync(path.join(dir, 'pnpm-lock.yaml'))
    ? 'pnpm'
    : existsSync(path.join(dir, 'yarn.lock'))
      ? 'yarn'
      : existsSync(path.join(dir, 'package-lock.json'))
        ? 'npm'
        : ''
  let sizeMB = 0
  try {
    const sizeStr = execSync(`du -sm ${dir} | cut -f1`).toString().trim()
    sizeMB = Number(sizeStr)
  } catch {
    // Ignore size calculation errors
  }
  out.push({
    repo: repo.name,
    nextVersion,
    usesTypeScript: ts,
    eslintConfigured,
    prettierConfigured,
    hasAppDir,
    pageRouterOnly: hasPagesDir && !hasAppDir,
    testFramework,
    hasCI,
    lastCommitDays: daysAgo(repo.pushedAt),
    packageManager: pm,
    sizeMB,
    duplicationCandidate: /demo|test|model|example|model/i.test(repo.name),
    recommendedAction: '',
  })
}

writeFileSync('inventory.json', JSON.stringify(out, null, 2))
console.log('Done -> inventory.json, please review.')
