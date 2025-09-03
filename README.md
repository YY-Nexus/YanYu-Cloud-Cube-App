# 文件结构

feat/startup-quality-infra
├─ startup-quality-config.yaml
├─ CODEOWNERS
├─ .github/
│  ├─ pull_request_template.md
│  ├─ ISSUE_TEMPLATE/
│  │   └─ quality_improvement.md
│  ├─ workflows/
│  │   ├─ ci.yml
│  │   ├─ startup-quality-gate.yml
│  │   ├─ sbom-security.yml
│  │   ├─ pr-labeler.yml
│  │   ├─ codeql.yml
│  │   └─ check-copilot-summary.yml
│  ├─ labeler.yml
│  └─ dependabot.yml
├─ docs/
│  └─ startup-quality/
│      ├─BRANCH_GUIDE.md
│      ├─README.md
│      └─ metrics_reference.md
├─ scripts/
│  ├─ quality/
│  │   ├─ gate.mjs
│  │   └─ exit-check.mjs
│  ├─ rum/
│  │   └─ initRUM.js
│  └─ white-screen/
│      └─ observer.js
├─ README.md
├─ .gitignore
└─ package.json
