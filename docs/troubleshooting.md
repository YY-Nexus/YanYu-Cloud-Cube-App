# 常见问题与故障排查

## 1. CI/CD 构建失败
- 检查 .github/workflows 下的构建日志
- 依赖是否安装完整（pnpm install）

## 2. 应用无法启动
- 检查 .env 配置
- 检查端口冲突

## 3. 依赖升级导致问题
- Review Renovate PR
- 回滚到上一个健康版本