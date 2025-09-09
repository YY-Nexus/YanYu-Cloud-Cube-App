import { defineConfig } from 'vitest/config'
import { resolve } from 'path'

export default defineConfig({
  test: {
    environment: 'node', // 或 'jsdom'，根据需求
    globals: true,
    setupFiles: ['./test/setup.ts'], // 如果需要
    include: ['**/*.{test,spec}.{js,mjs,cjs,ts,mts,cts,jsx,tsx}'],
    exclude: ['**/node_modules/**', '**/dist/**', '**/.next/**', '**/build/**'],
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