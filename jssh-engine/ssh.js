/**
 * ssh.js — SSH接続 + コマンド実行ラッパー
 * jump_host は direct-tcpip トンネル経由
 */

import { Client } from 'ssh2';
import { readFileSync } from 'fs';
import { homedir } from 'os';

function resolveKey(keyPath) {
  const p = keyPath.replace('~', homedir());
  try { return readFileSync(p); } catch { return null; }
}

/** SSH接続を Promise で包む */
function connect(cfg, stream = null) {
  return new Promise((resolve, reject) => {
    const client = new Client();
    const authCfg = cfg.auth ?? {};
    const opts    = cfg.options ?? {};

    const connParams = {
      host:        cfg.host,
      port:        cfg.port ?? 22,
      username:    authCfg.username,
      readyTimeout: (opts.timeout_seconds ?? 10) * 1000,
      keepaliveInterval: (opts.keepalive_interval_seconds ?? 0) * 1000,
    };

    if (authCfg.auth_method === 'publickey') {
      const key = resolveKey(authCfg.private_key_path ?? '~/.ssh/id_ed25519');
      if (!key) return reject(new Error(`[SSH] Private key not found: ${authCfg.private_key_path}`));
      connParams.privateKey  = key;
      if (authCfg.passphrase) connParams.passphrase = authCfg.passphrase;
    } else {
      connParams.password = authCfg.password ?? '';
    }

    if (opts.strict_host_key_checking === false) {
      connParams.hostVerifier = () => true;
    }

    if (stream) connParams.sock = stream; // jump host トンネル用

    client.on('ready', () => resolve(client));
    client.on('error', reject);
    client.connect(connParams);
  });
}

/** jump_host 経由の Direct-TCPIP トンネル確立 */
function openTunnel(jumpClient, targetHost, targetPort) {
  return new Promise((resolve, reject) => {
    jumpClient.forwardOut(
      '127.0.0.1', 0,
      targetHost, targetPort,
      (err, stream) => err ? reject(err) : resolve(stream)
    );
  });
}

/** リトライ付き SSH接続ファクトリ */
export async function createConnection(cfg) {
  const opts      = cfg.options ?? {};
  const maxRetry  = opts.max_retries ?? 1;
  const retryWait = (opts.retry_delay_seconds ?? 2) * 1000;
  const jump      = cfg.jump_host;

  for (let attempt = 1; attempt <= maxRetry; attempt++) {
    try {
      let jumpClient = null;
      let stream     = null;

      if (jump?.enabled) {
        jumpClient = await connect({
          host: jump.host,
          port: jump.port ?? 22,
          auth: { username: jump.username, auth_method: 'publickey',
                  private_key_path: cfg.auth.private_key_path },
          options: cfg.options,
        });
        stream = await openTunnel(jumpClient, cfg.host, cfg.port ?? 22);
      }

      const client = await connect(cfg, stream);
      return { client, jumpClient }; // 両方返してあとでclose

    } catch (err) {
      console.error(`[SSH] Connect attempt ${attempt}/${maxRetry} failed: ${err.message}`);
      if (attempt < maxRetry) await new Promise(r => setTimeout(r, retryWait));
      else throw err;
    }
  }
}

/** コマンド1本実行 → {exit_code, stdout, stderr, execution_time_ms} */
export function execCommand(client, step) {
  const shell   = step.shell ?? 'sh';
  const env     = step.env   ?? {};
  const timeout = (step.timeout ?? 30) * 1000;

  // 環境変数プレフィックスを組み立て
  const envPrefix = Object.entries(env)
    .map(([k, v]) => `export ${k}=${JSON.stringify(v)}`)
    .join('; ');
  const fullCmd = envPrefix ? `${envPrefix}; ${step.command}` : step.command;

  return new Promise((resolve, reject) => {
    const start = Date.now();
    let stdout = '', stderr = '';
    let timer;

    client.exec(fullCmd, { pty: false }, (err, stream) => {
      if (err) return reject(err);

      timer = setTimeout(() => {
        stream.close();
        resolve({
          step_id: step.step_id,
          command: step.command,
          exit_code: -1,
          stdout,
          stderr: stderr + '\n[TIMEOUT]',
          execution_time_ms: Date.now() - start,
          status: 'timeout',
        });
      }, timeout);

      stream.on('data', d => { stdout += d.toString(); });
      stream.stderr.on('data', d => { stderr += d.toString(); });
      stream.on('close', (code) => {
        clearTimeout(timer);
        resolve({
          step_id: step.step_id,
          command: step.command,
          exit_code: code ?? 0,
          stdout: stdout.trimEnd(),
          stderr: stderr.trimEnd(),
          execution_time_ms: Date.now() - start,
          status: code === 0 ? 'success' : 'failed',
        });
      });
    });
  });
}

export function closeConnection({ client, jumpClient }) {
  try { client?.end(); }     catch {}
  try { jumpClient?.end(); } catch {}
}
