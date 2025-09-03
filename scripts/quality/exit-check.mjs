#!/usr/bin/env node
import fs from 'node:fs';

const file = process.argv[2];
if (!file) {
  console.error('Usage: node exit-check.mjs <scorecard.json>');
  process.exit(1);
}

const data = JSON.parse(fs.readFileSync(file, 'utf-8'));

// 简化门槛：total_score > 0 视为通过
if (data.total_score > 0) {
  console.log('[QUALITY GATE] PASS total_score =', data.total_score);
  process.exit(0);
} else {
  console.error('[QUALITY GATE] FAIL total_score =', data.total_score);
  process.exit(2);
}