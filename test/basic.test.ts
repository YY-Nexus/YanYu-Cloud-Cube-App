import { describe, it, expect } from 'vitest'
import { readFileSync } from 'fs'
import { resolve } from 'path'

describe('Repository Setup', () => {
  it('should have basic configuration', () => {
    expect(true).toBe(true)
  })

  it('should be able to read package.json', () => {
    const pkgPath = resolve(__dirname, '../package.json')
    const pkg = JSON.parse(readFileSync(pkgPath, 'utf-8'))
    expect(pkg.name).toBe('yan-yu-cloud-cube-app')
    expect(pkg.private).toBe(true)
  })

  it('should have vitest configured', () => {
    expect(typeof describe).toBe('function')
    expect(typeof it).toBe('function')
    expect(typeof expect).toBe('function')
  })
})
