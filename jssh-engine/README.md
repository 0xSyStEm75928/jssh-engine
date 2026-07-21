# LuciFeR0x0systeM :: jssh DAG Engine v2

JSON-drivenなSSH自動化エンジン。  
`depends_on` + `parallel_group` によるDAG実行、変数補間、踏み台対応。

## セットアップ

```bash
npm install   # または pnpm install / yarn
```

## 実行

```bash
node index.js payload.json
```

結果は `payload.result.json` に自動出力される。

---

## DAG実行の仕組み

```
payload.json の execution_sequence:

  step1 ──┬── step2 ──────────────────┐
          ├── step3 (parallel: A) ──┤── step5
          └── step4 (parallel: A) ──┘

Level 1: [step1]
Level 2: [step2] + [step3, step4 を並列グループAとして同時実行]
Level 3: [step5]
```

- `depends_on: []` → Level 1（依存なし）
- `depends_on: [1]` → step1完了後に実行
- `parallel_group: "health-checks"` → 同グループは並列実行
- 循環参照はKahn's algorithmで検出してエラー終了

---

## on_failure の挙動

| 値 | 挙動 |
|---|---|
| `abort` | パイプライン即停止。後続stepはすべて `skipped` |
| `continue` | 失敗を無視して次へ |
| `retry` | `retry_count` 回リトライ後に `abort` or `continue` |

---

## 変数補間

`variables` に定義した値が `{{VARIABLE_NAME}}` として全フィールドに展開される。

```json
"variables": { "TARGET_HOST": "192.168.1.100" },
"connection_settings": { "host": "{{TARGET_HOST}}" }
```

---

## jump_host（踏み台）

```json
"jump_host": {
  "enabled": true,
  "host": "bastion.example.com",
  "port": 22,
  "username": "jump_user"
}
```

ssh2 の `direct-tcpip` チャンネルで踏み台→ターゲットをトンネリング。

---

## ファイル構成

```
jssh-engine/
├── index.js        メインエントリ・バナー・サマリ出力
├── dag.js          トポロジカルソート・循環参照検出
├── interpolate.js  {{変数}} 補間エンジン
├── ssh.js          ssh2ラッパー・jump_host・コマンド実行
├── runner.js       on_failure/retry制御・バッチ並列実行
├── payload.json    サンプルペイロード
└── package.json
```
