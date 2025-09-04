// eslint.config.js
import js from '@eslint/js'
import typescriptParser from '@typescript-eslint/parser'
import typescriptPlugin from '@typescript-eslint/eslint-plugin'
import unusedImportsPlugin from 'eslint-plugin-unused-imports'

export default [
  {
    ignores: [
      'node_modules/',
      'dist/',
      'build/',
      '.next/',
      'coverage/',
      '*.config.js',
      '*.config.ts',
      '*.config.mjs',
      'apps/*/node_modules/',
      'packages/*/node_modules/',
      'apps/*/.next/',
      'packages/*/dist/',
      'YanYu-Cloud-Cube-App/', // Ignore duplicate nested directory
      'apps/Supabase/', // Ignore Supabase app with many legacy ESLint rule references
      '**/next-env.d.ts', // Ignore Next.js generated types
    ],
  },
  js.configs.recommended,
  {
    files: ['**/*.{js,jsx}'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      globals: {
        console: 'readonly',
        process: 'readonly',
        module: 'readonly',
        require: 'readonly',
        document: 'readonly',
        window: 'readonly',
        fetch: 'readonly',
        Headers: 'readonly',
        location: 'readonly',
        React: 'readonly',
        JSX: 'readonly',
        alert: 'readonly',
        prompt: 'readonly',
      },
      parserOptions: {
        ecmaFeatures: {
          jsx: true,
        },
      },
    },
    rules: {
      'no-undef': 'warn', // Relax for JS files that might have different globals
    },
  },
  {
    files: ['**/*.{ts,tsx}'],
    languageOptions: {
      parser: typescriptParser,
      parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module',
        ecmaFeatures: {
          jsx: true,
        },
      },
      globals: {
        console: 'readonly',
        process: 'readonly',
        document: 'readonly',
        window: 'readonly',
        fetch: 'readonly',
        Headers: 'readonly',
        location: 'readonly',
        React: 'readonly',
        JSX: 'readonly',
        HTMLElement: 'readonly',
        HTMLDivElement: 'readonly',
        HTMLParagraphElement: 'readonly',
        HTMLHeadingElement: 'readonly',
        HTMLButtonElement: 'readonly',
        HTMLInputElement: 'readonly',
        HTMLTextAreaElement: 'readonly',
      },
    },
    plugins: {
      '@typescript-eslint': typescriptPlugin,
      'unused-imports': unusedImportsPlugin,
    },
    rules: {
      ...typescriptPlugin.configs.recommended.rules,
      'unused-imports/no-unused-imports': 'error',
      '@typescript-eslint/no-explicit-any': 'warn',
      '@typescript-eslint/no-unused-vars': 'warn',
      '@typescript-eslint/no-empty-object-type': 'warn',
      'no-undef': 'off', // TypeScript handles this
      'no-empty': 'warn',
    },
  },
]
