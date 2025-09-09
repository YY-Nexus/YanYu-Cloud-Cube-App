import { describe, it, expect } from 'vitest'
import { readFileSync, readdirSync } from 'fs'
import { join } from 'path'

describe('GitHub Issue Templates', () => {
  const templatesDir = join(process.cwd(), '.github', 'ISSUE_TEMPLATE')

  it('should have all required issue templates', () => {
    const files = readdirSync(templatesDir)
    const expectedTemplates = [
      'bug_report.md',
      'feature_request.md',
      'incident.md',
      'standardize.md',
      'general.md',
      'config.yml',
    ]

    expectedTemplates.forEach((template) => {
      expect(files).toContain(template)
    })
  })

  it('should have valid YAML frontmatter in all markdown templates', () => {
    const files = readdirSync(templatesDir)
    const markdownFiles = files.filter((file) => file.endsWith('.md'))

    markdownFiles.forEach((file) => {
      const content = readFileSync(join(templatesDir, file), 'utf-8')

      // Check if file starts with YAML frontmatter
      expect(content).toMatch(/^---\n/)

      // Check if file has required fields
      expect(content).toMatch(/name:/)
      expect(content).toMatch(/about:/)
      expect(content).toMatch(/title:/)
      expect(content).toMatch(/labels:/)
    })
  })

  it('should have bilingual content in templates', () => {
    const files = readdirSync(templatesDir)
    const markdownFiles = files.filter((file) => file.endsWith('.md'))

    markdownFiles.forEach((file) => {
      const content = readFileSync(join(templatesDir, file), 'utf-8')

      // Check for Chinese/English bilingual patterns
      const hasBilingualPattern =
        content.includes(' / ') || content.includes('Please') || content.includes('描述')

      expect(hasBilingualPattern).toBe(true)
    })
  })

  it('should have config.yml with proper structure', () => {
    const configPath = join(templatesDir, 'config.yml')
    const content = readFileSync(configPath, 'utf-8')

    // Check for required config fields
    expect(content).toMatch(/blank_issues_enabled:\s*false/)
    expect(content).toMatch(/contact_links:/)
    expect(content).toMatch(/name:/)
    expect(content).toMatch(/url:/)
    expect(content).toMatch(/about:/)
  })
})
