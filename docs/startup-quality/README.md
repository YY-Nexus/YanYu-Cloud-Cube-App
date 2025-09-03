# 启动质量体系概览

本目录说明 YanYu-Cloud-Cube-App 启动阶段八大维度的指标、流程、工具与治理节奏。

## 目标

- 建立统一指标与 Gate（防回退）
- 快速定位启动异常
- 驱动性能与稳定性持续可视化优化
- 支撑多阶段成熟度演进 (L1→L5)

## 维度速览

1. 功能完整性
2. 启动稳定性
3. 环境兼容性
4. 启动性能
5. 错误处理
6. 全局配置加载
7. 依赖管理
8. 可观测性

## 核心文件

- startup-quality-config.yaml：指标/阈值/Gate
- scripts/quality/gate.mjs：计算 Scorecard
- scripts/quality/exit-check.mjs：执行 Gate
- RUM & White Screen 脚本：采集实时事件
- .github/workflows/*：CI、SBOM、安全、质量 Gate

## 流程

1. PR -> 基础 CI (lint/test/build)
2. PR -> Startup Quality Gate 解析配置（暂为模拟指标，可逐渐接入真实聚合）
3. 合并 -> SBOM + CodeQL
4. 运行期 -> RUM SDK 与日志上报 -> 外部聚合服务 (未来接入)
5. 定期 -> 导出聚合结果→更新 Scorecard 趋势 → 回归/复盘

## 指标接入路线图

| 阶段 | 内容 | 结果 |
|------|------|------|
| M1 | 基线指标 & CI Gate | 阻断明显回退 |
| M2 | 降级策略 & 长尾分析 | 精细化优化 |
| M3 | 预测告警 & 自愈 | 智能韧性 |

## 调整策略

- 误报或新业务导致指标波动：先临时标记 soft_fail，再评估调整阈值或拆分场景。
- 新增指标：扩展 startup-quality-config.yaml 对应维度 metrics 数组。
- 删除指标：需说明影响的维度权重再平衡。

## 看板建议

- Funnel：attempted->config_loaded->first_render->interactive_ready
- 性能分布：LCP/TTI P50/P75/P95/P99
- 错误分类：按 error_taxonomy 聚类
- 依赖耗时堆积：TopN initialization

## 常见问答

Q: 为什么分维度权重？  
A: 保证多维折中，防止单一性能指标掩盖稳定性问题。

Q: 如何对接真实指标？  
A: gate.mjs 读取外部 JSON（如 artifacts/metrics.json）或调用内部 API，写入 metricsMap。

## 里程碑

- M1: 基线 & Gate
- M2: 扩展观测与韧性
- M3: 智能化与自愈
