import js from '@eslint/js'
import typescript from '@typescript-eslint/eslint-plugin'
import typescriptParser from '@typescript-eslint/parser'
import importPlugin from 'eslint-plugin-import'
import unusedImports from 'eslint-plugin-unused-imports'
import react from 'eslint-plugin-react'
import reactHooks from 'eslint-plugin-react-hooks'

export default [
  js.configs.recommended,
  {
    files: ['**/*.{ts,tsx,js,jsx}'],
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
        // Node.js globals
        console: 'readonly',
        process: 'readonly',
        global: 'readonly',
        Buffer: 'readonly',
        __dirname: 'readonly',
        __filename: 'readonly',
        module: 'readonly',
        require: 'readonly',
        exports: 'readonly',
        
        // Browser globals
        window: 'readonly',
        document: 'readonly',
        location: 'readonly',
        fetch: 'readonly',
        Headers: 'readonly',
        Response: 'readonly',
        prompt: 'readonly',
        alert: 'readonly',
        navigator: 'readonly',
        URL: 'readonly',
        performance: 'readonly',
        
        // React globals
        React: 'readonly',
        
        // HTML Element types (for TypeScript)
        HTMLElement: 'readonly',
        HTMLDivElement: 'readonly',
        HTMLButtonElement: 'readonly',
        HTMLInputElement: 'readonly',
        HTMLTextAreaElement: 'readonly',
        HTMLParagraphElement: 'readonly',
        HTMLHeadingElement: 'readonly',
      },
    },
    plugins: {
      '@typescript-eslint': typescript,
      'import': importPlugin,
      'unused-imports': unusedImports,
      'react': react,
      'react-hooks': reactHooks,
    },
    settings: {
      react: {
        version: 'detect',
      },
    },
    rules: {
      ...typescript.configs.recommended.rules,
      ...react.configs.recommended.rules,
      ...reactHooks.configs.recommended.rules,
      'unused-imports/no-unused-imports': 'error',
      '@typescript-eslint/no-explicit-any': 'warn',
      'import/order': ['error', { 'newlines-between': 'always' }],
      'react/react-in-jsx-scope': 'off', // Not needed in Next.js 13+
      'react/prop-types': 'off', // TypeScript handles this
      '@typescript-eslint/no-require-imports': 'off', // Allow require in config files
      'no-empty': 'warn',
      '@typescript-eslint/no-unused-vars': 'warn',
      '@typescript-eslint/no-empty-object-type': 'warn',
      // Disable unknown rules
      '@next/next/no-img-element': 'off',
    },
  },
  {
    files: ['**/*.config.{js,ts}', '**/next.config.js', '**/tailwind.config.js', '**/postcss.config.js'],
    rules: {
      'no-undef': 'off',
      '@typescript-eslint/no-require-imports': 'off',
    },
  },
  {
    ignores: [
      'node_modules/**',
      '.next/**',
      'dist/**',
      'build/**',
      'pnpm-lock.yaml*',
      '*.conflict-backup-*',
    ],
  },
]