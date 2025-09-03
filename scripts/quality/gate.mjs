#!/usr/bin/env node
/**
 * Enhanced Quality Gate Script
 * Features:
 *  - Reads YAML config
 *  - Supports env overrides (METRIC_<ID>)
 *  - Deterministic simulated metrics with --seed (avoid CI flakiness)
 *  - Normalizes dimension & metric weights
 *  - Evaluates targets, produces per-metric scores
 *  - Supports mandatory metrics & block conditions (if present in config)
 *  - Optional baseline diff (--baseline)
 *  - Optional external metrics JSON (--metrics-file)
 *  - Metadata: commit, branch, repo, phase, context
 *  - Optional output file (--output)
 *
 * Usage examples:
 *  node scripts/quality/gate.mjs --config startup-quality-config.yaml > scorecard.json
 *  node scripts/quality/gate.mjs --config startup-quality-config.yaml --context pr --baseline metrics/baseline/scorecard-20250903.json
 *  METRIC_STARTUP_SUCCESS_RATE=99.5 node scripts/quality/gate.mjs --config startup-quality-config.yaml --seed ci
 */

import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import yaml from 'yaml';

// ---------------- CLI ARG PARSE ----------------
const args = process.argv.slice(2);
function getArg(name) {
  const idx = args.indexOf(name);
  return idx >= 0 ? args[idx + 1] : undefined;
}
function hasFlag(name) { return args.includes(name); }

if (hasFlag('--help')) {
  console.log(`Quality Gate Script Help
  --config <file>        YAML config (required if exists)
  --context <ctx>        pr|push|schedule|manual (optional)
  --baseline <file>      Previous scorecard for diff (optional)
  --metrics-file <file>  External metrics JSON (optional)
  --output <file>        Output to file instead of stdout
  --seed <seed>          Deterministic seed for simulated metrics
  --help                 Show this help
  `);
  process.exit(0);
}

const configPath = getArg('--config') || 'startup-quality-config.yaml';
const context = getArg('--context') || process.env.GITHUB_EVENT_NAME || 'manual';
const baselinePath = getArg('--baseline');
const metricsFile = getArg('--metrics-file');
const outputFile = getArg('--output');
const seedInput = getArg('--seed') || process.env.GATE_SEED || 'default-seed';

// ---------------- LOAD CONFIG ----------------
if (!fs.existsSync(configPath)) {
  console.error(`[gate] Config not found: ${configPath}`);
  process.exit(1);
}
let cfgRaw;
try {
  cfgRaw = fs.readFileSync(configPath, 'utf-8');
} catch (e) {
  console.error(`[gate] Failed to read config: ${e.message}`);
  process.exit(1);
}
let cfg;
try {
  cfg = yaml.parse(cfgRaw);
} catch (e) {
  console.error(`[gate] Failed to parse YAML: ${e.message}`);
  process.exit(1);
}

if (!cfg.dimensions || !cfg.scoring || !cfg.scoring.dimension_weights) {
  console.error('[gate] Config missing required sections: dimensions / scoring.dimension_weights');
  process.exit(1);
}

// ---------------- SEEDED RANDOM ----------------
function makeSeeded(seedStr) {
  let h = 0;
  for (let i = 0; i < seedStr.length; i++) {
    h = Math.imul(31, h) + seedStr.charCodeAt(i) | 0;
  }
  return () => {
    // LCG variant
    h = (Math.imul(48271, h) + 0x7fffffff) & 0x7fffffff;
    return (h >>> 0) / 0xffffffff;
  };
}
const rand = makeSeeded(String(seedInput));

// ---------------- EXTERNAL METRICS (optional) ----------------
let externalMetrics = {};
if (metricsFile) {
  if (!fs.existsSync(metricsFile)) {
    console.error(`[gate] Provided --metrics-file not found: ${metricsFile}`);
    process.exit(1);
  }
  try {
    const extRaw = fs.readFileSync(metricsFile, 'utf-8');
    externalMetrics = JSON.parse(extRaw);
    // Expected format: { metricId: value, ... }
  } catch (e) {
    console.error(`[gate] Failed to parse metrics file: ${e.message}`);
    process.exit(1);
  }
}

// ---------------- HELPERS ----------------
function metricEnvKey(id) {
  return `METRIC_${id.toUpperCase()}`;
}

function fetchMetricValue(metricId, fallbackMode = 'simulate') {
  // 1. Env override
  const key = metricEnvKey(metricId);
  if (process.env[key] !== undefined) {
    return Number(process.env[key]);
  }
  // 2. External metrics file
  if (externalMetrics[metricId] !== undefined) {
    return Number(externalMetrics[metricId]);
  }
  // 3. Simulate (deterministic)
  if (fallbackMode === 'simulate') {
    return Number((rand() * 100).toFixed(2));
  }
  return NaN;
}

function parseTarget(expr) {
  if (!expr) return null;
  const m = expr.match(/(>=|<=|>|<|==)\s*([\d.]+)/);
  if (!m) return null;
  return { op: m[1], target: Number(m[2]) };
}

function evaluate(value, parsed) {
  if (!parsed) return true;
  const v = Number(value);
  const t = parsed.target;
  switch (parsed.op) {
    case '>=': return v >= t;
    case '<=': return v <= t;
    case '>': return v > t;
    case '<': return v < t;
    case '==': return v === t;
    default: return true;
  }
}

function computeScore(value, parsed) {
  if (!parsed) return 100;
  const pass = evaluate(value, parsed);
  if (pass) return 100;
  const v = Number(value);
  const t = parsed.target;
  // Relative deviation capped
  const diffRatio = Math.min(Math.abs(v - t) / (Math.abs(t) || 1), 1);
  return Math.max(5, Number((100 * (1 - diffRatio)).toFixed(2)));
}

// Classification thresholds (configurable via cfg.scoring.levels?)
function classify(totalScore) {
  const map = (cfg.scoring && cfg.scoring.levels) || [
    { min: 90, level: 'Release Ready' },
    { min: 80, level: 'Minor Improvement' },
    { min: 70, level: 'Conditional' },
    { min: 60, level: 'High Risk' },
    { min: 0,  level: 'Block' }
  ];
  for (const row of map) {
    if (totalScore >= row.min) return row.level;
  }
  return 'Block';
}

// ---------------- NORMALIZE DIMENSION WEIGHTS ----------------
const dimWeightsRaw = cfg.scoring.dimension_weights;
const dimNames = Object.keys(cfg.dimensions);
let weightSum = 0;
for (const d of dimNames) {
  weightSum += (dimWeightsRaw[d] ?? 0);
}
const normalizedDimWeights = {};
if (weightSum === 0) {
  // fallback equal distribution
  dimNames.forEach(d => normalizedDimWeights[d] = 1 / dimNames.length);
} else {
  dimNames.forEach(d => normalizedDimWeights[d] = (dimWeightsRaw[d] ?? 0) / weightSum);
}

const warnings = [];
if (Math.abs(Object.values(normalizedDimWeights).reduce((a,b)=>a+b,0) - 1) > 1e-6) {
  warnings.push('Dimension weights normalization rounding drift detected.');
}

// ---------------- PROCESS METRICS ----------------
const metricsOutput = [];
const dimensionScores = {};

for (const dim of dimNames) {
  const dimConf = cfg.dimensions[dim];
  const metrics = dimConf.metrics || [];
  if (metrics.length === 0) {
    dimensionScores[dim] = 0;
    continue;
  }
  // Normalize metric weights inside dimension
  let metricWeightSum = metrics.reduce((s, m) => s + (m.weight || 0), 0);
  if (!metricWeightSum) {
    // If all weights missing or zero -> equal distribution
    metricWeightSum = metrics.length;
    metrics.forEach(m => m.__normWeight = 1 / metrics.length);
  } else {
    metrics.forEach(m => m.__normWeight = (m.weight || 0) / metricWeightSum);
  }

  let dimWeighted = 0;

  for (const m of metrics) {
    const parsedTarget = parseTarget(m.target);
    const value = fetchMetricValue(m.id);
    const pass = evaluate(value, parsedTarget);
    const score = computeScore(value, parsedTarget);
    dimWeighted += score * m.__normWeight;
    metricsOutput.push({
      id: m.id,
      dimension: dim,
      value,
      target: m.target || null,
      pass,
      score,
      weight: m.weight ?? null,
      norm_weight: Number(m.__normWeight.toFixed(4))
    });
  }
  dimensionScores[dim] = Number(dimWeighted.toFixed(2));
}

// ---------------- TOTAL SCORE ----------------
let totalScore = 0;
for (const [dim, score] of Object.entries(dimensionScores)) {
  totalScore += score * (normalizedDimWeights[dim] || 0);
}
totalScore = Number(totalScore.toFixed(2));
const level = classify(totalScore);

// ---------------- MANDATORY & BLOCK CONDITIONS ----------------
const mandatoryFailed = [];
if (cfg.mandatory && Array.isArray(cfg.mandatory.metrics)) {
  for (const mId of cfg.mandatory.metrics) {
    const mo = metricsOutput.find(m => m.id === mId);
    if (mo && !mo.pass) {
      mandatoryFailed.push(mId);
    }
  }
}

const blockReasons = [];
if (Array.isArray(cfg.block_conditions)) {
  // Very simple parser: each condition like "metric_id < 80" combined singly
  for (const cond of cfg.block_conditions) {
    const c = cond.trim();
    // pattern: metric op number
    const m = c.match(/^([a-zA-Z0-9_\-]+)\s*(>=|<=|>|<|==)\s*([\d.]+)$/);
    if (!m) {
      warnings.push(`Unrecognized block condition syntax: "${c}"`);
      continue;
    }
    const [, mId, op, rawNum] = m;
    const targetVal = Number(rawNum);
    const mo = metricsOutput.find(x => x.id === mId);
    if (!mo) {
      warnings.push(`Block condition references unknown metric: "${mId}"`);
      continue;
    }
    const v = Number(mo.value);
    let violated = false;
    switch (op) {
      case '>=': violated = !(v >= targetVal); break;
      case '<=': violated = !(v <= targetVal); break;
      case '>':  violated = !(v > targetVal); break;
      case '<':  violated = !(v < targetVal); break;
      case '==': violated = !(v === targetVal); break;
    }
    if (violated) {
      blockReasons.push(`Condition failed: ${mId} ${op} ${targetVal} (actual=${v})`);
    }
  }
}

const blocked = mandatoryFailed.length > 0 || blockReasons.length > 0;

// ---------------- BASELINE DIFF (optional) ----------------
let diff = undefined;
if (baselinePath) {
  if (!fs.existsSync(baselinePath)) {
    warnings.push(`Baseline file not found: ${baselinePath}`);
  } else {
    try {
      const baseline = JSON.parse(fs.readFileSync(baselinePath, 'utf-8'));
      diff = {
        baseline_total: baseline.total_score ?? null,
        current_total: totalScore,
        total_delta: (baseline.total_score !== undefined && !isNaN(baseline.total_score))
          ? Number((totalScore - baseline.total_score).toFixed(2))
          : null,
        metrics: {}
      };
      const baselineIndex = {};
      if (Array.isArray(baseline.metrics)) {
        baseline.metrics.forEach(m => { baselineIndex[m.id] = m; });
      }
      for (const m of metricsOutput) {
        const b = baselineIndex[m.id];
        if (b && b.value !== undefined) {
          diff.metrics[m.id] = {
            baseline: b.value,
            current: m.value,
            delta: Number((m.value - b.value).toFixed(4))
          };
        }
      }
    } catch (e) {
      warnings.push(`Failed to parse baseline: ${e.message}`);
    }
  }
}

// ---------------- BUILD RESULT ----------------
const result = {
  meta: {
    generated_at: new Date().toISOString(),
    config: path.basename(configPath),
    context,
    phase: process.env.GATE_PHASE || 'unspecified',
    seed: seedInput,
    commit: process.env.GITHUB_SHA || '',
    branch: process.env.GITHUB_REF_NAME ||
            (process.env.GITHUB_REF || '').replace('refs/heads/', ''),
    repository: process.env.GITHUB_REPOSITORY || '',
    baseline: baselinePath || null,
    metrics_file: metricsFile || null
  },
  totals: {
    total_score: totalScore,
    level
  },
  dimension_scores: dimensionScores,
  normalized_dimension_weights: normalizedDimWeights,
  metrics: metricsOutput,
  gating: {
    mandatory_failed: mandatoryFailed,
    block_reasons: blockReasons,
    blocked
  },
  diff,
  warnings
};

const json = JSON.stringify(result, null, 2);

if (outputFile) {
  fs.writeFileSync(outputFile, json);
  console.log(`[gate] Wrote scorecard to ${outputFile}`);
} else {
  process.stdout.write(json + '\n');
}