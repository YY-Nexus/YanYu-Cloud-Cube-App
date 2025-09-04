import { describe, it, expect } from 'vitest'

describe('TypeScript Config Validation', () => {
  it('should support modern JS features', () => {
    // Test modern JavaScript features work with our TS config
    const asyncFunction = async () => 'test'
    const promise = asyncFunction()
    expect(promise).toBeInstanceOf(Promise)
  })

  it('should support object destructuring and spread', () => {
    const obj = { a: 1, b: 2, c: 3 }
    const { a, ...rest } = obj
    expect(a).toBe(1)
    expect(rest).toEqual({ b: 2, c: 3 })
  })

  it('should support array methods', () => {
    const numbers = [1, 2, 3, 4, 5]
    const doubled = numbers.map((n) => n * 2)
    const evens = numbers.filter((n) => n % 2 === 0)

    expect(doubled).toEqual([2, 4, 6, 8, 10])
    expect(evens).toEqual([2, 4])
  })
})
