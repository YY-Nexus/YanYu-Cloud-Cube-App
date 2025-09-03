# Metrics Reference

| metric_id | 说明 | 单位/类型 | 采集来源 | 口径备注 |
|-----------|------|-----------|----------|----------|
| startup_success_rate | 启动成功率 | % | RUM | succeeded_starts/attempted_starts |
| crash_rate_per_start | 启动崩溃率 | % | RUM/Crash SDK | fatal_crashes/attempted_starts |
| lcp_p75 | Largest Contentful Paint P75 | ms | Web Vitals | 冷/热区分可扩展标签 |
| tti_p75 | Time To Interactive P75 | ms | 自研/RUM | 稳定主线程 + 可交互 |
| core_function_coverage | 核心功能覆盖率 | % | 测试报告 | 实现且通过用例 |
| config_schema_pass_rate | 配置 Schema 校验成功率 | % | CI 校验日志 | 失败即阻断 |
| dependency_init_time_ratio | 依赖初始化时间占比 | % | RUM 分段耗时 | 依赖初始化 / 启动总耗时 |
| uncaught_error_rate | 未捕获错误率 | % | window.onerror | 启动阶段 session 范围 |
| degrade_success_rate | 降级成功率 | % | 自研降级模块 | 降级后仍完成启动 |

（其余详见 startup-quality-config.yaml）
