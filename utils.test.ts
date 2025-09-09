import { describe, it, expect } from 'vitest'

describe('utilities', () => {
  it('should handle string operations correctly', () => {
    const str = 'Hello World'
    expect(str.toLowerCase()).toBe('hello world')
    expect(str.toUpperCase()).toBe('HELLO WORLD')
  })

  it('should handle array operations correctly', () => {
    const arr = [1, 2, 3, 4, 5]
    expect(arr.length).toBe(5)
    expect(arr.filter((n) => n > 3)).toEqual([4, 5])
    expect(arr.map((n) => n * 2)).toEqual([2, 4, 6, 8, 10])
  })

  it('should handle object operations correctly', () => {
    const obj = { name: 'test', value: 42 }
    expect(obj.name).toBe('test')
    expect(obj.value).toBe(42)
    expect(Object.keys(obj)).toEqual(['name', 'value'])
  })
})
