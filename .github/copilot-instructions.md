# YanYu Cloud Cube App - GitHub Copilot Instructions

**ALWAYS follow these instructions first and fallback to additional search and context gathering only if the information here is incomplete or found to be in error.**

YanYu Cloud Cube App is a Next.js 15.x monorepo using pnpm workspaces and Turbo for build orchestration. It contains multiple applications with standardized CI/CD, code quality tools, and automated conflict resolution.

## Working Effectively

### Bootstrap and Validate Repository

- Install Node.js 18+ (specified in `.nvmrc`): `node --version` should show v18+
- Install pnpm globally: `npm install -g pnpm@9.0.0`
- Verify pnpm version: `pnpm --version` should show 9.0.0
- Install dependencies: `pnpm install --frozen-lockfile` -- takes 40 seconds. NEVER CANCEL. Set timeout to 120+ seconds.
- Run validation suite:
  - `pnpm lint` -- takes 2 seconds, allows up to 10 warnings (currently 9 TypeScript any-type warnings)
  - `pnpm type-check` -- takes 3 seconds. NEVER CANCEL. Set timeout to 60+ seconds.
  - `pnpm test` -- takes 1 second, runs governance and basic tests

### Build Status and Known Issues

**CRITICAL**: The individual app builds are currently broken due to missing dependencies and network issues. DO NOT attempt `pnpm build` as it will fail.

Known build issues:

- `apps/markdown`: Missing nextra dependencies, requires module-type compatibility fixes
- `apps/ewm`: Missing @tailwindcss/typography, network dependency on fonts.googleapis.com fails
- `apps/Supabase`: Module parsing errors with commonjs/ESM compatibility
- Individual app dev servers have configuration issues

**WORKING COMMANDS ONLY**:

- `pnpm install --frozen-lockfile` ✅
- `pnpm lint` ✅
- `pnpm type-check` ✅
- `pnpm test` ✅
- `pnpm format` ⚠️ (works but may fail on some YAML syntax issues)

**FAILING COMMANDS** (document as broken):

- `pnpm build` ❌ - fails due to app-specific dependency issues
- `pnpm dev` ❌ - fails due to missing nextra dependencies in markdown app
- Individual app builds ❌ - multiple dependency and configuration issues

### Validation Scenarios

After making changes, ALWAYS run this validation sequence:

1. `pnpm install --frozen-lockfile` (if package.json changes)
2. `pnpm lint` - ensure code quality standards
3. `pnpm type-check` - verify TypeScript compilation
4. `pnpm test` - run governance and unit tests
5. **DO NOT** attempt to build or run dev servers until dependency issues are resolved

### Conflict Resolution

- Use `pnpm fix-conflicts` to automatically resolve Git conflicts in any file
- Use `pnpm fix-pnpm-conflicts` specifically for pnpm-lock.yaml conflicts
- Conflict resolution script preserves "lower part" of conflicts (incoming changes)
- Always run `pnpm install` after resolving pnpm-lock.yaml conflicts

## Repository Structure

### Key Directories

- `apps/`: Multiple Next.js applications (currently with build issues)
  - `apps/Supabase/`: Slack clone with Supabase integration
  - `apps/ewm/`: EWM application with Nextra documentation
  - `apps/markdown/`: Nextra documentation template
  - `apps/web/`: Main web application (placeholder)
- `packages/`: Shared packages and utilities
  - `packages/ui/`: UI components (placeholder)
  - `packages/config/`: Configuration utilities (placeholder)
  - `packages/utils/`: Utility functions (placeholder)
- `.github/workflows/`: CI/CD pipelines
- `docs/`: Architecture and troubleshooting documentation
- `scripts/`: Automation and conflict resolution scripts

### Configuration Files

- `package.json`: Root workspace configuration with pnpm 9.0.0
- `pnpm-workspace.yaml`: Workspace definition
- `turbo.json`: Turbo build configuration
- `.nvmrc`: Node.js version specification (18)
- `tsconfig.base.json`: TypeScript base configuration
- `vitest.config.ts`: Test configuration

## CI/CD and Quality Assurance

### Pre-commit Validation

Always run before committing:

- `pnpm lint` -- NEVER CANCEL. Set timeout to 60+ seconds
- `pnpm type-check` -- NEVER CANCEL. Set timeout to 60+ seconds
- `pnpm test` -- NEVER CANCEL. Set timeout to 60+ seconds
- `pnpm format` for code formatting

### GitHub Actions

- CI runs on PRs and main branch pushes
- Workflow includes: install → lint → type-check → test → (build disabled due to issues)
- Uses Node.js 20, pnpm 9 in CI environment
- Vercel integration for preview deployments (when builds work)

### Quality Standards

- Maximum 10 ESLint warnings allowed (currently 9)
- TypeScript strict mode enabled
- Prettier for code formatting
- Husky for git hooks
- Renovate for dependency updates

## Common Tasks

### Development Workflow

1. Clone repository
2. `pnpm install --frozen-lockfile` -- 40 seconds, NEVER CANCEL
3. Make changes to code
4. Run validation: `pnpm lint && pnpm type-check && pnpm test`
5. Format code: `pnpm format`
6. Commit changes

### Dependency Management

- Use `pnpm install` to add dependencies
- Use `pnpm install --frozen-lockfile` for CI/production
- Run `pnpm install` after resolving lock file conflicts
- Check `renovate.json` for automated dependency update configuration

### Troubleshooting

- Check `docs/troubleshooting.md` for common issues
- Use `docs/conflict-resolution.md` for Git conflict guidance
- Review `docs/ci-cd.md` for CI/CD process details
- Individual app issues are documented as known problems

## CRITICAL Timing and Timeout Guidelines

**NEVER CANCEL these commands - wait for completion:**

- `pnpm install --frozen-lockfile`: 40 seconds normal, set timeout to 120+ seconds
- `pnpm type-check`: 3 seconds normal, set timeout to 60+ seconds
- `pnpm lint`: 2 seconds normal, set timeout to 60+ seconds
- `pnpm test`: 1 second normal, set timeout to 60+ seconds

**Expected command timings:**

- Dependencies install: ~40 seconds
- Linting: ~2 seconds
- Type checking: ~3 seconds
- Testing: ~1 second
- Formatting: ~1 second

## Manual Validation Requirements

**ALWAYS perform these steps after making changes:**

1. Verify linting passes: `pnpm lint` (should complete with ≤10 warnings)
2. Verify type checking: `pnpm type-check` (should complete without errors)
3. Verify tests pass: `pnpm test` (should show all tests passing)
4. Check governance compliance: Tests verify Next.js 15.x, TypeScript, ESLint, Prettier, Vitest, and Husky are properly configured

**DO NOT attempt to validate by building or running applications** - the build process is currently broken and will fail.

## Common Command Reference

```bash
# Initial setup
node --version                    # Verify Node 18+
npm install -g pnpm@9.0.0        # Install pnpm
pnpm install --frozen-lockfile   # Install dependencies (40s)

# Development validation
pnpm lint                         # Code quality check (2s)
pnpm type-check                   # TypeScript validation (3s)
pnpm test                         # Run tests (1s)
pnpm format                       # Format code (1s)

# Conflict resolution
pnpm fix-conflicts <file>         # Resolve Git conflicts
pnpm fix-pnpm-conflicts          # Resolve pnpm-lock.yaml conflicts

# Workspace information
pnpm -r list                      # List all workspace packages
pnpm why <package>                # Check package dependency tree
```

Remember: This repository has known build issues with individual applications. Focus on root-level commands for validation and avoid attempting to build or run individual apps until dependency issues are resolved.
