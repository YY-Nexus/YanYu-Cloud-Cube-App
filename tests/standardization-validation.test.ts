import { describe, it, expect } from 'vitest'
import { readFileSync, existsSync } from 'fs'
import { join } from 'path'

describe('Repository Standardization Validation', () => {
  const rootDir = process.cwd()

  it('should have Next.js 15.x configured', () => {
    const packageJson = JSON.parse(readFileSync(join(rootDir, 'package.json'), 'utf-8'))
    expect(packageJson.dependencies?.next || packageJson.devDependencies?.next).toMatch(/\^15\./)
  })

  it('should have TypeScript properly configured', () => {
    expect(existsSync(join(rootDir, 'tsconfig.json'))).toBe(true)
    expect(existsSync(join(rootDir, 'tsconfig.base.json'))).toBe(true)

    const packageJson = JSON.parse(readFileSync(join(rootDir, 'package.json'), 'utf-8'))
    expect(packageJson.devDependencies?.typescript).toBeDefined()
  })

  it('should have ESLint and Prettier configured', () => {
    expect(existsSync(join(rootDir, 'eslint.config.js'))).toBe(true)
    expect(existsSync(join(rootDir, '.prettierrc'))).toBe(true)

    const packageJson = JSON.parse(readFileSync(join(rootDir, 'package.json'), 'utf-8'))
    expect(packageJson.devDependencies?.eslint).toBeDefined()
    expect(packageJson.devDependencies?.prettier).toBeDefined()
  })

  it('should have Husky configured', () => {
    expect(existsSync(join(rootDir, '.husky'))).toBe(true)

    const packageJson = JSON.parse(readFileSync(join(rootDir, 'package.json'), 'utf-8'))
    expect(packageJson.devDependencies?.husky).toBeDefined()
    expect(packageJson.scripts?.prepare).toContain('husky')
  })

  it('should have Vitest configured', () => {
    expect(existsSync(join(rootDir, 'vitest.config.ts'))).toBe(true)

    const packageJson = JSON.parse(readFileSync(join(rootDir, 'package.json'), 'utf-8'))
    expect(packageJson.devDependencies?.vitest).toBeDefined()
    expect(packageJson.scripts?.test).toContain('vitest')
  })

  it('should have CI/CD workflows', () => {
    expect(existsSync(join(rootDir, '.github/workflows'))).toBe(true)
    expect(existsSync(join(rootDir, '.github/workflows/ci.yml'))).toBe(true)
  })

  it('should have environment example', () => {
    expect(existsSync(join(rootDir, '.env.example'))).toBe(true)
  })

  it('should have proper build configuration', () => {
    const packageJson = JSON.parse(readFileSync(join(rootDir, 'package.json'), 'utf-8'))
    expect(packageJson.scripts?.build).toBeDefined()
    expect(packageJson.scripts?.lint).toBeDefined()
    expect(packageJson.scripts?.['type-check']).toBeDefined()
  })
})
