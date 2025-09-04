import { defineConfig } from 'vitest/config'
import { resolve } from 'path'

export default defineConfig({
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./test/setup.ts'],
  },
  resolve: {
    alias: {
      '@': resolve(__dirname, './'),
      '@ui': resolve(__dirname, './packages/ui/src'),
      '@config': resolve(__dirname, './packages/config/src'),
      '@utils': resolve(__dirname, './packages/utils/src'),
    },
  },
})
