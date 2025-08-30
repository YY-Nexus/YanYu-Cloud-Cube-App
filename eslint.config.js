import js from '@eslint/js'

export default [
  js.configs.recommended,
  {
    files: ['**/*.{js,mjs,cjs,ts,tsx}'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      globals: {
        // Browser globals
        window: 'readonly',
        document: 'readonly',
        console: 'readonly',
        alert: 'readonly',
        prompt: 'readonly',
        fetch: 'readonly',
        Headers: 'readonly',
        location: 'readonly',
        // Node.js globals
        process: 'readonly',
        module: 'readonly',
        require: 'readonly',
        __dirname: 'readonly',
        __filename: 'readonly',
        // TypeScript/React globals
        HTMLDivElement: 'readonly',
        HTMLButtonElement: 'readonly',
        HTMLInputElement: 'readonly',
        HTMLTextAreaElement: 'readonly',
        HTMLParagraphElement: 'readonly',
        HTMLHeadingElement: 'readonly',
        React: 'readonly',
        JSX: 'readonly',
      },
    },
    rules: {
      // Disable problematic rules for migration
      'no-unused-vars': 'warn',
      'no-undef': 'warn',
      'no-empty': 'warn',
    },
  },
  {
    ignores: ['node_modules/**', 'dist/**', 'build/**', '.next/**', '**/*.d.ts', 'pnpm-lock.yaml'],
  },
]
