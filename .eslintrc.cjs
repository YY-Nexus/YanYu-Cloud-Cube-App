module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint', 'import', 'unused-imports'],
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:import/recommended',
    'plugin:import/typescript',
    'plugin:react/recommended',
    'plugin:react-hooks/recommended',
    'prettier',
  ],
  settings: { react: { version: 'detect' } },
  rules: {
    'unused-imports/no-unused-imports': 'error',
    '@typescript-eslint/no-explicit-any': 'warn',
    'import/order': ['error', { 'newlines-between': 'always' }],
  },
}
