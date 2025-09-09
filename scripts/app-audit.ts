#!/usr/bin/env tsx

/**
 * Application Audit System
 * 应用程序审核系统
 * 
 * Performs comprehensive analysis of all applications in the monorepo
 * and generates standardization recommendations and execution plans.
 */

import { readFileSync, writeFileSync, existsSync } from 'fs';
import { resolve, join } from 'path';
import { execSync } from 'child_process';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

interface AppAnalysis {
  name: string;
  path: string;
  hasPackageJson: boolean;
  packageInfo?: any;
  nextVersion?: string;
  usesTypeScript: boolean;
  hasAppDir: boolean;
  pageRouterOnly: boolean;
  eslintConfigured: boolean;
  prettierConfigured: boolean;
  testFramework: string;
  hasCI: boolean;
  sizeMB: number;
  missingFeatures: string[];
  recommendations: string[];
  priority: 'high' | 'medium' | 'low';
  standardizationScore: number;
}

interface GlobalAuditReport {
  timestamp: string;
  summary: {
    totalApps: number;
    fullyStandardized: number;
    needsWork: number;
    critical: number;
  };
  apps: AppAnalysis[];
  globalRecommendations: string[];
  executionPlan: {
    phase: string;
    tasks: string[];
    estimatedDays: number;
  }[];
}

class AppAuditor {
  private rootDir: string;
  private appsDir: string;

  constructor() {
    this.rootDir = process.cwd();
    this.appsDir = join(this.rootDir, 'apps');
  }

  /**
   * 分析单个应用程序
   */
  private analyzeApp(appName: string): AppAnalysis {
    const appPath = join(this.appsDir, appName);
    const packageJsonPath = join(appPath, 'package.json');
    
    const analysis: AppAnalysis = {
      name: appName,
      path: appPath,
      hasPackageJson: existsSync(packageJsonPath),
      usesTypeScript: false,
      hasAppDir: false,
      pageRouterOnly: false,
      eslintConfigured: false,
      prettierConfigured: false,
      testFramework: '',
      hasCI: false,
      sizeMB: 0,
      missingFeatures: [],
      recommendations: [],
      priority: 'medium',
      standardizationScore: 0
    };

    if (!analysis.hasPackageJson) {
      analysis.missingFeatures.push('Package.json configuration');
      analysis.recommendations.push('Initialize with proper package.json');
      analysis.priority = 'high';
      return analysis;
    }

    // 读取 package.json
    try {
      const packageContent = readFileSync(packageJsonPath, 'utf-8');
      analysis.packageInfo = JSON.parse(packageContent);
      
      // 检查 Next.js 版本
      const deps = { ...analysis.packageInfo.dependencies, ...analysis.packageInfo.devDependencies };
      analysis.nextVersion = deps.next || '';
      
      // 检查 TypeScript
      analysis.usesTypeScript = existsSync(join(appPath, 'tsconfig.json')) || 
                               !!deps.typescript || 
                               !!deps['@types/react'];

      // 检查 ESLint
      analysis.eslintConfigured = existsSync(join(appPath, '.eslintrc.json')) ||
                                 existsSync(join(appPath, '.eslintrc.js')) ||
                                 !!deps.eslint;

      // 检查 Prettier
      analysis.prettierConfigured = existsSync(join(appPath, '.prettierrc')) ||
                                   existsSync(join(appPath, '.prettierrc.js')) ||
                                   !!deps.prettier;

      // 检查应用结构
      analysis.hasAppDir = existsSync(join(appPath, 'app')) || existsSync(join(appPath, 'src', 'app'));
      analysis.pageRouterOnly = existsSync(join(appPath, 'pages')) && !analysis.hasAppDir;

      // 检查测试框架
      if (deps.vitest) analysis.testFramework = 'vitest';
      else if (deps.jest) analysis.testFramework = 'jest';
      else if (deps['@testing-library/react']) analysis.testFramework = 'testing-library';

      // 检查 CI 配置
      analysis.hasCI = existsSync(join(appPath, 'ci.yml')) ||
                      existsSync(join(appPath, '.github'));

    } catch (error) {
      analysis.missingFeatures.push('Invalid package.json');
      analysis.recommendations.push('Fix package.json syntax errors');
    }

    // 计算应用大小
    try {
      const sizeOutput = execSync(`du -sm "${appPath}" 2>/dev/null || echo "0"`, { encoding: 'utf-8' });
      analysis.sizeMB = parseInt(sizeOutput.split('\t')[0]) || 0;
    } catch {
      analysis.sizeMB = 0;
    }

    // 生成改进建议
    this.generateRecommendations(analysis);

    return analysis;
  }

  /**
   * 生成改进建议
   */
  private generateRecommendations(analysis: AppAnalysis): void {
    let score = 0;

    // Next.js 版本检查
    if (!analysis.nextVersion) {
      analysis.missingFeatures.push('Next.js framework');
      analysis.recommendations.push('Add Next.js 15.x as dependency');
    } else if (!analysis.nextVersion.includes('15.')) {
      analysis.missingFeatures.push('Outdated Next.js version');
      analysis.recommendations.push('Upgrade to Next.js 15.x');
    } else {
      score += 20;
    }

    // TypeScript 检查
    if (!analysis.usesTypeScript) {
      analysis.missingFeatures.push('TypeScript configuration');
      analysis.recommendations.push('Enable TypeScript for type safety');
    } else {
      score += 20;
    }

    // 代码质量工具
    if (!analysis.eslintConfigured) {
      analysis.missingFeatures.push('ESLint configuration');
      analysis.recommendations.push('Configure ESLint for code quality');
    } else {
      score += 15;
    }

    if (!analysis.prettierConfigured) {
      analysis.missingFeatures.push('Prettier configuration');
      analysis.recommendations.push('Configure Prettier for code formatting');
    } else {
      score += 15;
    }

    // 应用架构
    if (!analysis.hasAppDir && !analysis.pageRouterOnly) {
      analysis.missingFeatures.push('Next.js routing structure');
      analysis.recommendations.push('Implement proper Next.js routing (App Router or Pages Router)');
    } else {
      score += 15;
    }

    // 测试框架
    if (!analysis.testFramework) {
      analysis.missingFeatures.push('Testing framework');
      analysis.recommendations.push('Add testing framework (Vitest recommended)');
    } else {
      score += 10;
    }

    // CI/CD
    if (!analysis.hasCI) {
      analysis.missingFeatures.push('CI/CD configuration');
      analysis.recommendations.push('Add CI/CD workflow');
    } else {
      score += 5;
    }

    analysis.standardizationScore = score;

    // 确定优先级
    if (score < 30) analysis.priority = 'high';
    else if (score < 70) analysis.priority = 'medium';
    else analysis.priority = 'low';

    // 添加特定应用的建议
    this.addAppSpecificRecommendations(analysis);
  }

  /**
   * 添加特定应用的建议
   */
  private addAppSpecificRecommendations(analysis: AppAnalysis): void {
    switch (analysis.name) {
      case 'web':
        if (analysis.sizeMB < 1) {
          analysis.missingFeatures.push('Main application content');
          analysis.recommendations.push('Implement main web application features');
          analysis.recommendations.push('Add landing page and core functionality');
          analysis.priority = 'high';
        }
        break;

      case 'ewm':
        analysis.recommendations.push('Standardize UI components with design system');
        analysis.recommendations.push('Add comprehensive QR code generation features');
        break;

      case 'markdown':
        analysis.recommendations.push('Ensure Nextra documentation is complete');
        analysis.recommendations.push('Add interactive documentation features');
        break;

      case 'Supabase':
        if (!analysis.usesTypeScript) {
          analysis.recommendations.push('Convert JavaScript components to TypeScript');
          analysis.priority = 'high';
        }
        analysis.recommendations.push('Add real-time features and improve chat UI');
        break;
    }
  }

  /**
   * 执行全局审核
   */
  public async performGlobalAudit(): Promise<GlobalAuditReport> {
    console.log('🔍 Starting global application audit...');

    const apps = ['web', 'ewm', 'markdown', 'Supabase'];
    const analyses: AppAnalysis[] = [];

    for (const appName of apps) {
      console.log(`📋 Analyzing ${appName}...`);
      analyses.push(this.analyzeApp(appName));
    }

    const fullyStandardized = analyses.filter(app => app.standardizationScore >= 80).length;
    const needsWork = analyses.filter(app => app.standardizationScore < 80).length;
    const critical = analyses.filter(app => app.priority === 'high').length;

    const report: GlobalAuditReport = {
      timestamp: new Date().toISOString(),
      summary: {
        totalApps: analyses.length,
        fullyStandardized,
        needsWork,
        critical
      },
      apps: analyses,
      globalRecommendations: this.generateGlobalRecommendations(analyses),
      executionPlan: this.generateExecutionPlan(analyses)
    };

    return report;
  }

  /**
   * 生成全局建议
   */
  private generateGlobalRecommendations(analyses: AppAnalysis[]): string[] {
    const recommendations = [
      '建立统一的 UI 组件库和设计系统',
      '标准化所有应用的技术栈到 Next.js 15.x + TypeScript',
      '实施统一的代码质量标准 (ESLint + Prettier)',
      '为所有应用添加全面的测试覆盖',
      '建立自动化 CI/CD 流程',
      '实现跨应用的状态管理和数据共享',
      '优化性能和用户体验一致性',
      '添加全面的错误监控和日志系统'
    ];

    // 基于分析结果添加特定建议
    const lowScoreApps = analyses.filter(app => app.standardizationScore < 50);
    if (lowScoreApps.length > 0) {
      recommendations.unshift('优先处理标准化分数低于50的应用');
    }

    const noTypeScriptApps = analyses.filter(app => !app.usesTypeScript);
    if (noTypeScriptApps.length > 0) {
      recommendations.push(`将 ${noTypeScriptApps.map(app => app.name).join(', ')} 转换为 TypeScript`);
    }

    return recommendations;
  }

  /**
   * 生成执行计划
   */
  private generateExecutionPlan(analyses: AppAnalysis[]): GlobalAuditReport['executionPlan'] {
    return [
      {
        phase: 'Phase 1: 紧急修复和基础标准化',
        tasks: [
          '修复所有高优先级问题',
          '标准化 package.json 配置',
          '启用 TypeScript (如果缺失)',
          '配置基础的 ESLint 和 Prettier',
          '完成 web 应用的基础功能'
        ],
        estimatedDays: 5
      },
      {
        phase: 'Phase 2: UI 标准化和组件库',
        tasks: [
          '创建统一的 UI 组件库',
          '标准化所有应用的界面设计',
          '实现响应式布局',
          '优化用户体验一致性',
          '添加主题和样式系统'
        ],
        estimatedDays: 8
      },
      {
        phase: 'Phase 3: 功能完善和集成',
        tasks: [
          '完善各应用的核心功能',
          '实现应用间的数据共享',
          '添加用户认证和权限管理',
          '集成分析和监控系统',
          '优化性能和加载速度'
        ],
        estimatedDays: 10
      },
      {
        phase: 'Phase 4: 测试和部署优化',
        tasks: [
          '添加全面的单元测试',
          '实施集成测试',
          '优化 CI/CD 流程',
          '配置生产环境部署',
          '建立监控和告警系统'
        ],
        estimatedDays: 7
      }
    ];
  }

  /**
   * 保存审核报告
   */
  public saveReport(report: GlobalAuditReport): void {
    const reportPath = join(this.rootDir, 'app-audit-report.json');
    writeFileSync(reportPath, JSON.stringify(report, null, 2));
    
    // 生成 Markdown 报告
    this.generateMarkdownReport(report);
    
    console.log(`📊 Audit report saved to: ${reportPath}`);
  }

  /**
   * 生成 Markdown 报告
   */
  private generateMarkdownReport(report: GlobalAuditReport): void {
    const markdown = `# Application Audit Report
# 应用程序审核报告

**Generated:** ${new Date(report.timestamp).toLocaleString()}

## Summary 概览

- **Total Applications:** ${report.summary.totalApps}
- **Fully Standardized:** ${report.summary.fullyStandardized}
- **Needs Work:** ${report.summary.needsWork}
- **Critical Issues:** ${report.summary.critical}

## Application Analysis 应用分析

${report.apps.map(app => `
### ${app.name}

**Standardization Score:** ${app.standardizationScore}/100 | **Priority:** ${app.priority}

**Current State:**
- Next.js Version: ${app.nextVersion || 'Not configured'}
- TypeScript: ${app.usesTypeScript ? '✅' : '❌'}
- ESLint: ${app.eslintConfigured ? '✅' : '❌'}
- Prettier: ${app.prettierConfigured ? '✅' : '❌'}
- Testing: ${app.testFramework || 'None'}
- Size: ${app.sizeMB}MB

**Missing Features:**
${app.missingFeatures.map(feature => `- ${feature}`).join('\n')}

**Recommendations:**
${app.recommendations.map(rec => `- ${rec}`).join('\n')}
`).join('\n')}

## Global Recommendations 全局建议

${report.globalRecommendations.map(rec => `- ${rec}`).join('\n')}

## Execution Plan 执行计划

${report.executionPlan.map(phase => `
### ${phase.phase}

**Estimated Time:** ${phase.estimatedDays} days

**Tasks:**
${phase.tasks.map(task => `- ${task}`).join('\n')}
`).join('\n')}

---

*This report was generated by the YanYu Cloud Cube App audit system.*
`;

    const markdownPath = join(this.rootDir, 'docs', 'app-audit-report.md');
    writeFileSync(markdownPath, markdown);
    console.log(`📋 Markdown report saved to: ${markdownPath}`);
  }
}

// 主执行函数
async function main() {
  const auditor = new AppAuditor();
  
  try {
    const report = await auditor.performGlobalAudit();
    auditor.saveReport(report);
    
    console.log('\n🎉 Global audit completed successfully!');
    console.log(`📊 Summary: ${report.summary.fullyStandardized}/${report.summary.totalApps} apps fully standardized`);
    console.log(`⚠️  Critical issues: ${report.summary.critical}`);
    
  } catch (error) {
    console.error('❌ Audit failed:', error);
    process.exit(1);
  }
}

// Run if this is the main module
if (import.meta.url === `file://${process.argv[1]}`) {
  main();
}

export { AppAuditor, type AppAnalysis, type GlobalAuditReport };