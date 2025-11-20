# EWM Repository Split Information

This directory contains the `ewm` application extracted from the main monorepo.

## Original Location
- **Original Path**: `apps/ewm` in the `YanYu-Cloud-Cube-App` monorepo
- **Split Date**: 2025-11-20
- **Original Repository**: https://github.com/YY-Nexus/YanYu-Cloud-Cube-App

## Git History
The Git history for this subdirectory has been preserved in `GIT_HISTORY.txt`.

## Next Steps
1. Create a new independent repository for `ewm`
2. Initialize Git in this directory: `git init`
3. Add the remote: `git remote add origin <new-repo-url>`
4. Commit all files: `git add . && git commit -m "Initial commit from monorepo split"`
5. Push to the new repository: `git push -u origin main`
6. Run `pnpm install` to install dependencies
7. Test the application: `pnpm dev`

## Dependencies
This application has the following dependencies (see `package.json` for details):
- Next.js: ^15.5.3
- React: ^19.1.1
- Various Radix UI components
- Tailwind CSS
- And more...

## Configuration Notes
After splitting, you may need to:
- Update any absolute import paths
- Configure environment variables
- Set up CI/CD pipelines independently
- Update documentation references
