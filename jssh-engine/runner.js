/**
 * runner.js — on_failure / retry 制御フロー + バッチ実行
 */

import { execCommand } from './ssh.js';

const ANSI = {
  red:    '\x1b[1;31m', grn: '\x1b[1;32m',
  cyn:    '\x1b[1;36m', ylw: '\x1b[1;33m',
  dim:    '\x1b[2;37m', nc:  '\x1b[0m',
};
const c = (color, msg) => `${ANSI[color]}${msg}${ANSI.nc}`;

/** ステップ1本を on_failure / retry 込みで実行 */
export async function runStep(client, step, abortSignal) {
  if (abortSignal.aborted) {
    return { ...stepMeta(step), exit_code: -1, stdout: '', stderr: '', status: 'skipped', execution_time_ms: 0 };
  }

  const maxRetry  = step.on_failure === 'retry' ? (step.retry_count ?? 3) : 1;
  const retryWait = (step.retry_delay_seconds ?? 2) * 1000;
  let result;

  for (let attempt = 1; attempt <= maxRetry; attempt++) {
    console.log(
      c('cyn', `[STEP ${step.step_id}]`) +
      c('dim', ` ${step.name}`) +
      (attempt > 1 ? c('ylw', ` (retry ${attempt}/${maxRetry})`) : '')
    );

    result = await execCommand(client, step);

    const ok = result.status === 'success' || result.exit_code === 0;

    if (ok) {
      console.log(c('grn', `  ✓ exit=${result.exit_code}`) + c('dim', `  ${result.execution_time_ms}ms`));
      if (result.stdout) console.log(c('dim', result.stdout.split('\n').map(l => '    ' + l).join('\n')));
      return result;
    }

    console.error(c('red', `  ✗ exit=${result.exit_code}  status=${result.status}`));
    if (result.stderr) console.error(c('dim', result.stderr.split('\n').map(l => '    ' + l).join('\n')));

    if (step.on_failure === 'retry' && attempt < maxRetry) {
      console.log(c('ylw', `  ↻ Retrying in ${step.retry_delay_seconds ?? 2}s...`));
      await new Promise(r => setTimeout(r, retryWait));
    }
  }

  // 最終的に失敗
  if (step.on_failure === 'abort' && !step.ignore_errors) {
    abortSignal.abort();
    console.error(c('red', `  [ABORT] Pipeline halted by step ${step.step_id}`));
  } else {
    console.log(c('ylw', `  [CONTINUE] Ignoring failure of step ${step.step_id}`));
    result.status = 'failed';
  }
  return result;
}

/** バッチ（depends_on 解決済み1レベル）を parallel_group ごとに並列実行 */
export async function runBatch(client, batch, abortSignal) {
  // parallel_group でグルーピング
  const groups = new Map();
  for (const step of batch) {
    const key = step.parallel_group ?? `__s${step.step_id}`;
    if (!groups.has(key)) groups.set(key, []);
    groups.get(key).push(step);
  }

  // グループを全部並列で走らせる
  const groupPromises = [...groups.values()].map(async (group) => {
    const results = [];
    for (const step of group) {
      // グループ内は順番実行（並列グループ間は並列）
      results.push(await runStep(client, step, abortSignal));
    }
    return results;
  });

  return (await Promise.all(groupPromises)).flat();
}

function stepMeta(step) {
  return { step_id: step.step_id, command: step.command };
}
