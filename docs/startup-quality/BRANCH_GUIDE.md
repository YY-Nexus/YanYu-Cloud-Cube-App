# 启动质量专项分支指南

分支：feat/startup-quality-infra  (长期存在的集成 / 实验 / 渐进门控分支)

## 目的

- 聚合启动质量与可观测性相关脚本、指标管道、门控策略
- 渐进引入强门控前的验证场
- 产出可沉淀的组件（脚本、适配器、指标转换器），稳定后向 main 拆分 PR

## 阶段策略

| Phase | 描述 | Mandatory 范围 | 目标时间 |
|-------|------|----------------|----------|
| 0 Baseline | 只观测/宽门控 | 启动成功率、致命漏洞=0 | Week 1 |
| 1 Core | 核心稳定性加入 | + 崩溃率、未捕获错误率 | Week 2 |
| 2 Perf Core | 加入性能 | + LCP, TTI, 白屏 | Week 3 |
| 3 Coverage & Obs | 覆盖 & 可观测 | + core_function_coverage, startup_stage_coverage | Week 4 |
| 4 Full Gate | 与 main 对齐 | 全部 | TBD |

## 同步策略

- 每日（工作日）将 main 合并到本分支：`git merge origin/main`
- 严禁对本分支强制 push（需变基时开临时分支操作）

## 质量产物

- 每次 push：生成 scorecard.json (artifact)
- 每日 02:00 UTC：生成 nightly-scorecard.json
- 计划：保留最近 14 天 scorecard 以做趋势分析

## 环境变量

| 变量 | 用途 |
|------|------|
| GATE_PHASE | baseline / core / perf / full → 控制 exit-check 行为 |
| METRICS_FILE | 指向 CI 生成的 metrics.json |
| METRIC_* | 单指标快速注入（调试用） |

## 后续计划

- RUM 数据 → metrics adapter
- SBOM 漏洞结果 → outdated_vuln_dependency_count
- 计算 maturity level (score → L1~L5)

---
维护人：startup-quality
