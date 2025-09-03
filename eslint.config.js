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
    files: ['**/*.{js,jsx,ts,tsx}'],
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
        Buffer: 'readonly',
        __dirname: 'readonly',
        __filename: 'readonly',
        module: 'readonly',
        require: 'readonly',
        exports: 'readonly',
        global: 'readonly',
        window: 'readonly',
        document: 'readonly',
        location: 'readonly',
        fetch: 'readonly',
        Headers: 'readonly',
      },
    },
    plugins: {
      '@typescript-eslint': typescript,
      import: importPlugin,
      'unused-imports': unusedImports,
      react: react,
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
      'react/react-in-jsx-scope': 'off', // Not needed in Next.js
      'react/prop-types': 'off', // Using TypeScript for type checking
      '@typescript-eslint/no-require-imports': 'off', // Allow require in config files
      'no-undef': 'off', // TypeScript handles this
      'no-empty': 'warn', // Downgrade to warning
    },
  },
  {
    ignores: ['node_modules/**', 'dist/**', '.next/**', 'coverage/**', '**/*.config.js'],
  },
]
