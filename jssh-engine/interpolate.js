/**
 * interpolate.js — {{VARIABLE}} テンプレート補間
 */

/**
 * オブジェクト全体を再帰的に変数補間
 * @param {any} obj - 対象（文字列 / オブジェクト / 配列）
 * @param {Object} vars - variables マップ
 * @returns {any}
 */
export function interpolate(obj, vars) {
  if (typeof obj === 'string') {
    return obj.replace(/\{\{(\w+)\}\}/g, (_, key) => {
      if (!(key in vars)) console.warn(`[INTERP] Undefined variable: {{${key}}}`);
      return vars[key] ?? `{{${key}}}`;
    });
  }
  if (Array.isArray(obj)) return obj.map(item => interpolate(item, vars));
  if (obj && typeof obj === 'object') {
    return Object.fromEntries(
      Object.entries(obj).map(([k, v]) => [k, interpolate(v, vars)])
    );
  }
  return obj;
}
