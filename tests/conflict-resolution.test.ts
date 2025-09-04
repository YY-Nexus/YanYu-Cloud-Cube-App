import { describe, it, expect, beforeEach, afterEach } from 'vitest'
import { execSync } from 'child_process'
import { writeFileSync, readFileSync, existsSync } from 'fs'
import path from 'path'

describe('Auto-resolve Conflicts Scripts', () => {
  const testDir = path.join(process.cwd(), 'test-temp')
  const testPackageJson = path.join(testDir, 'test-package.json')
  const testLockFile = path.join(testDir, 'test-lock.yaml')

  beforeEach(() => {
    // Create test directory
    execSync(`mkdir -p ${testDir}`)
  })

  afterEach(() => {
    // Clean up test files
    execSync(`rm -rf ${testDir}`)
  })

  describe('Package.json conflict resolution', () => {
    it('should handle files without conflicts', () => {
      const content = JSON.stringify(
        {
          name: 'test-package',
          version: '1.0.0',
          dependencies: {
            react: '^18.0.0',
          },
        },
        null,
        2,
      )

      writeFileSync(testPackageJson, content)

      const result = execSync(
        `cd ${testDir} && bash ../scripts/auto-resolve-package-conflicts.sh test-package.json`,
        {
          encoding: 'utf8',
        },
      )

      expect(result).toContain('已解决 0 个 package.json 冲突')
      expect(result).toContain('Resolved 0 package.json conflicts')
    })

    it('should detect script exists', () => {
      expect(existsSync('./scripts/auto-resolve-package-conflicts.sh')).toBe(true)
      expect(existsSync('./scripts/auto-resolve-conflicts.sh')).toBe(true)
    })

    it('should be executable', () => {
      const stat = execSync('ls -la scripts/auto-resolve-package-conflicts.sh', {
        encoding: 'utf8',
      })
      expect(stat).toMatch(/-rwxr-xr-x/)
    })
  })

  describe('Enhanced conflict resolution features', () => {
    it('should provide colored output', () => {
      // Test that the enhanced script has color support
      const script = readFileSync('./scripts/auto-resolve-conflicts.sh', 'utf8')
      expect(script).toContain('RED=')
      expect(script).toContain('GREEN=')
      expect(script).toContain('log_info')
      expect(script).toContain('log_success')
    })

    it('should check for conflict markers before processing', () => {
      const script = readFileSync('./scripts/auto-resolve-conflicts.sh', 'utf8')
      expect(script).toContain('grep -q "<<<<<<< \\|>>>>>>> \\|======="')
      expect(script).toContain('No conflict markers found')
    })
  })

  describe('Package.json scripts integration', () => {
    it('should have the new script available in package.json', () => {
      const packageJson = JSON.parse(readFileSync('./package.json', 'utf8'))
      expect(packageJson.scripts).toHaveProperty('fix-package-conflicts')
      expect(packageJson.scripts['fix-package-conflicts']).toBe(
        'bash scripts/auto-resolve-package-conflicts.sh',
      )
    })

    it('should maintain existing scripts', () => {
      const packageJson = JSON.parse(readFileSync('./package.json', 'utf8'))
      expect(packageJson.scripts).toHaveProperty('fix-conflicts')
      expect(packageJson.scripts).toHaveProperty('fix-pnpm-conflicts')
    })
  })
})
