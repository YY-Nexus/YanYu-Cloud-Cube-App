import { describe, it, expect } from 'vitest'

describe('Basic functionality', () => {
  it('should run basic tests', () => {
    expect(1 + 1).toBe(2)
  })

  it('should handle strings', () => {
    expect('hello world').toContain('world')
  })
})

describe('Environment setup', () => {
  it('should have global test environment', () => {
    expect(typeof describe).toBe('function')
    expect(typeof it).toBe('function')
    expect(typeof expect).toBe('function')
  })
})