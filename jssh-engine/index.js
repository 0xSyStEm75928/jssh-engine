#!/usr/bin/env node
/**
 * index.js — LuciFeR0x0systeM :: jssh DAG Execution Engine
 * 使い方: node index.js payload.json
 */

import { readFileSync } from 'fs';
import { createConnection, closeConnection } from './ssh.js';
import { buildExecutionPlan } from './dag.js';
import { interpolate } from './interpolate.js';
import { runBatch } from './runner.js';

const ANSI = {
  red: '\x1b[1;31m', grn: '\x1b[1;32m',
  cyn: '\x1b[1;36m', dim: '\x1b[2;37m', nc: '\x1b[0m',
};
const c = (col, msg) => `${ANSI[col]}${msg}${ANSI.nc}`;

function printBanner() {
  console.log(c('red', `
  _     _   _  ____ _ _____ ___  ____
 | |   | | | |/ ___(_)  __|  __|| __ \\
 | |   | | | | |   | | |__ | _| |    /
 | |___| |_| | |___| |  __|| |__|\\|\\ \\
 |_____|\\_____|\\____|_|_|  |_____|_| \\_|
     :::: 0 x 0  :  jssh Engine v2 ::::
`));
}

async function main() {
  printBanner();

  const payloadPath = process.argv[2];
  if (!payloadPath) {
    console.error(c('red', '[!] Usage: node index.js <payload.json>'));
    process.exit(1);
  }

  // --- 1. JSONロード & バリデーション ---
  let payload;
  try {
    payload = JSON.parse(readFileSync(payloadPath, 'utf-8'));
  } catch (e) {
    console.error(c('red', `[!] Failed to parse payload: ${e.message}`));
    process.exit(1);
  }

  const { title, version, metadata, variables = {}, connection_settings, execution_sequence, hooks } = payload;

  console.log(c('cyn', `[PAYLOAD] ${title} v${version}`));
  if (metadata) {
    console.log(c('dim', `  env=${metadata.environment}  tags=${(metadata.tags||[]).join(',')}`));
  }

  // --- 2. 変数補間（全体に適用）---
  const conn  = interpolate(connection_settings, variables);
  const steps = interpolate(execution_sequence,  variables);

  // --- 3. DAG ビルド + 循環参照チェック ---
  let plan;
  try {
    plan = buildExecutionPlan(steps);
  } catch (e) {
    console.error(c('red', `[DAG ERROR] ${e.message}`));
    process.exit(1);
  }
  console.log(c('dim', `[DAG] ${steps.length} steps → ${plan.length} execution level(s)`));
  plan.forEach((batch, i) => {
    console.log(c('dim', `  Level ${i+1}: [${batch.map(s => `step${s.step_id}`).join(', ')}]`));
  });

  // --- 4. SSH接続 (jump_host 対応) ---
  console.log(c('cyn', `\n[SSH] Connecting → ${conn.host}:${conn.port ?? 22} ...`));
  if (conn.jump_host?.enabled) {
    console.log(c('dim', `  via jump_host: ${conn.jump_host.host}`));
  }

  let connection;
  try {
    connection = await createConnection(conn);
    console.log(c('grn', '[SSH] Connected.\n'));
  } catch (e) {
    console.error(c('red', `[SSH] Connection failed: ${e.message}`));
    process.exit(1);
  }

  // --- pre_connect hook (接続後に表示のみ) ---
  if (hooks?.pre_connect) console.log(c('dim', `[HOOK:pre] ${hooks.pre_connect}`));

  // --- 5. DAG レベル順に実行 ---
  const abortSignal = new AbortController().signal;
  // abort可能なコントローラ
  const controller = new AbortController();
  const allResults = [];
  let pipelineFailed = false;
  let failedStep = null;

  for (const [i, batch] of plan.entries()) {
    console.log(c('cyn', `\n── Level ${i+1} / ${plan.length} ${'─'.repeat(40)}`));
    const results = await runBatch(connection.client, batch, controller);
    allResults.push(...results);

    if (controller.signal.aborted) {
      pipelineFailed = true;
      failedStep = results.find(r => r.status === 'failed' || r.status === 'timeout')?.step_id;
      break;
    }
  }

  // --- 6. 結果サマリ ---
  console.log(c('cyn', `\n${'═'.repeat(54)}`));
  console.log(c('cyn', ' EXECUTION SUMMARY'));
  console.log(c('cyn', `${'═'.repeat(54)}`));

  const statusSymbol = { success: c('grn','✓'), failed: c('red','✗'), skipped: c('dim','–'), timeout: c('red','⏱') };
  for (const r of allResults) {
    console.log(`  ${statusSymbol[r.status] ?? '?'}  step${r.step_id}  ${r.status}  ${r.execution_time_ms ?? 0}ms`);
  }

  console.log();
  if (pipelineFailed) {
    const msg = (hooks?.post_failure ?? '[!!] Pipeline failed at step {{failed_step}}')
      .replace('{{failed_step}}', failedStep ?? '?');
    console.log(c('red', msg));
  } else {
    console.log(c('grn', hooks?.post_success ?? '[OK] All steps complete'));
  }

  // --- 7. JSON出力 ---
  const outputPath = payloadPath.replace(/\.json$/, '.result.json');
  const { writeFileSync } = await import('fs');
  writeFileSync(outputPath, JSON.stringify(allResults, null, 2));
  console.log(c('dim', `\n[OUT] Results saved → ${outputPath}`));

  closeConnection(connection);
  process.exit(pipelineFailed ? 1 : 0);
}

main().catch(e => {
  console.error(`\x1b[1;31m[FATAL] ${e.message}\x1b[0m`);
  process.exit(1);
});
