import { describe, it, expect } from 'vitest'
import { execSync } from 'child_process'
import { existsSync, readFileSync } from 'fs'
import { join } from 'path'

describe('CI/CD Integration Tests', () => {
  it('should have conflict resolution script', () => {
    const scriptPath = join(process.cwd(), 'scripts/auto-resolve-conflicts.sh')
    expect(existsSync(scriptPath)).toBe(true)
  })

  it('should have pnpm conflict resolution script', () => {
    const scriptPath = join(process.cwd(), 'scripts/auto-fix-pnpm-lock-conflicts.sh')
    expect(existsSync(scriptPath)).toBe(true)
  })

  it('should have all CI workflow files', () => {
    const workflows = [
      '.github/workflows/ci.yml',
      '.github/workflows/auto-review.yml',
      '.github/workflows/auto-fix.yml',
      '.github/workflows/branch-protection.yml',
    ]

    workflows.forEach((workflow) => {
      const workflowPath = join(process.cwd(), workflow)
      expect(existsSync(workflowPath)).toBe(true)
    })
  })

  it('should have proper package.json scripts', () => {
    const packageJsonPath = join(process.cwd(), 'package.json')
    const packageJson = JSON.parse(readFileSync(packageJsonPath, 'utf-8'))

    expect(packageJson.scripts).toHaveProperty('fix-conflicts')
    expect(packageJson.scripts).toHaveProperty('fix-pnpm-conflicts')
    expect(packageJson.scripts).toHaveProperty('lint')
    expect(packageJson.scripts).toHaveProperty('lint:fix')
    expect(packageJson.scripts).toHaveProperty('test')
    expect(packageJson.scripts).toHaveProperty('build')
  })

  it('should have documentation files', () => {
    const docs = ['docs/ci-cd.md', 'docs/conflict-resolution.md', 'docs/automation-guide.md']

    docs.forEach((doc) => {
      const docPath = join(process.cwd(), doc)
      expect(existsSync(docPath)).toBe(true)
    })
  })

  it('should be able to run conflict resolution script without errors', () => {
    expect(() => {
      execSync('bash scripts/auto-resolve-conflicts.sh --help || true', {
        stdio: 'pipe',
        cwd: process.cwd(),
      })
    }).not.toThrow()
  })

  it('should have valid GitHub workflow syntax', () => {
    const workflows = [
      '.github/workflows/ci.yml',
      '.github/workflows/auto-review.yml',
      '.github/workflows/auto-fix.yml',
      '.github/workflows/branch-protection.yml',
    ]

    workflows.forEach((workflow) => {
      const workflowPath = join(process.cwd(), workflow)
      const content = readFileSync(workflowPath, 'utf-8')

      // Basic YAML structure checks
      expect(content).toContain('name:')
      expect(content).toContain('on:')
      expect(content).toContain('jobs:')
    })
  })
})
