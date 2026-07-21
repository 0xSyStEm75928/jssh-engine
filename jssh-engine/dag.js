/**
 * dag.js — DAG実行エンジン
 * トポロジカルソート + 並列グループ制御
 */

/**
 * depends_on の循環参照チェック付きトポロジカルソート
 * @param {Array} steps - execution_sequence
 * @returns {Array<Array>} - 並列実行できるステップのバッチ配列
 */
export function buildExecutionPlan(steps) {
  const idMap = new Map(steps.map(s => [s.step_id, s]));

  // 循環参照チェック（DFS）
  const visited = new Set();
  const stack   = new Set();

  function dfs(id) {
    if (stack.has(id)) throw new Error(`[DAG] Circular dependency detected at step_id=${id}`);
    if (visited.has(id)) return;
    stack.add(id);
    const step = idMap.get(id);
    if (!step) throw new Error(`[DAG] Unknown step_id=${id} in depends_on`);
    for (const dep of (step.depends_on || [])) dfs(dep);
    stack.delete(id);
    visited.add(id);
  }
  for (const s of steps) dfs(s.step_id);

  // Kahn's algorithm でレベル（バッチ）分け
  const inDegree = new Map(steps.map(s => [s.step_id, 0]));
  const graph    = new Map(steps.map(s => [s.step_id, []]));

  for (const s of steps) {
    for (const dep of (s.depends_on || [])) {
      graph.get(dep).push(s.step_id);
      inDegree.set(s.step_id, inDegree.get(s.step_id) + 1);
    }
  }

  const batches = [];
  let queue = steps.filter(s => inDegree.get(s.step_id) === 0).map(s => s.step_id);

  while (queue.length > 0) {
    batches.push(queue.map(id => idMap.get(id)));
    const next = [];
    for (const id of queue) {
      for (const child of graph.get(id)) {
        inDegree.set(child, inDegree.get(child) - 1);
        if (inDegree.get(child) === 0) next.push(child);
      }
    }
    queue = next;
  }

  return batches; // [ [step1], [step2, step3], [step4] ] — バッチ内は並列実行可
}

/**
 * parallel_group でさらにグループ分け（バッチ内の細粒度制御）
 */
export function groupByParallel(batch) {
  const groups = new Map();
  for (const step of batch) {
    const key = step.parallel_group ?? `__serial_${step.step_id}`;
    if (!groups.has(key)) groups.set(key, []);
    groups.get(key).push(step);
  }
  return [...groups.values()];
}
