# Branch Protection (Temporary Feature Branch)

- 分支：feat/startup-quality-infra
- 模式：最小（仅需要拉取请求）

Active:
- Require pull request before merging

Inactive:
- Required approvals
- Status checks
- Up-to-date before merge
- Code owners
- Deployment requirements
- Linear history / signed commits
- Lock branch
- Prevent bypass

Rationale:
- 快速迭代高质量的基础设施脚本（gate.mjs、exit-check.mjs）
- Avoid accidental merge to main without at least a visible PR review surface
- Do not block while metrics & scoring model are still volatile

Next Upgrade (after gate stabilizes):
1. Add required approvals = 1
2. Migrate protection to main branch instead
3. Add Startup Quality Gate as required status check
