import { describe, it, expect } from 'vitest'
import { readFileSync } from 'fs'
import { join } from 'path'

describe('Repository Governance', () => {
  it('should use Next.js 15.x', () => {
    const packageJsonPath = join(process.cwd(), 'package.json')
    const packageJson = JSON.parse(readFileSync(packageJsonPath, 'utf-8'))
    expect(packageJson.dependencies.next).toMatch(/^\^15\./)
  })

  it('should have TypeScript enabled', () => {
    const packageJsonPath = join(process.cwd(), 'package.json')
    const packageJson = JSON.parse(readFileSync(packageJsonPath, 'utf-8'))
    expect(packageJson.devDependencies.typescript).toBeDefined()
  })

  it('should have ESLint configured', () => {
    const packageJsonPath = join(process.cwd(), 'package.json')
    const packageJson = JSON.parse(readFileSync(packageJsonPath, 'utf-8'))
    expect(packageJson.devDependencies.eslint).toBeDefined()
  })

  it('should have Prettier configured', () => {
    const packageJsonPath = join(process.cwd(), 'package.json')
    const packageJson = JSON.parse(readFileSync(packageJsonPath, 'utf-8'))
    expect(packageJson.devDependencies.prettier).toBeDefined()
  })

  it('should have Vitest configured', () => {
    const packageJsonPath = join(process.cwd(), 'package.json')
    const packageJson = JSON.parse(readFileSync(packageJsonPath, 'utf-8'))
    expect(packageJson.devDependencies.vitest).toBeDefined()
  })

  it('should have Husky configured', () => {
    const packageJsonPath = join(process.cwd(), 'package.json')
    const packageJson = JSON.parse(readFileSync(packageJsonPath, 'utf-8'))
    expect(packageJson.devDependencies.husky).toBeDefined()
  })
})
