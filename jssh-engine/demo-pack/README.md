# jssh Demo Pack v1.0
## by LuciFeR0x0systeM

JSON一枚でどのOSでも・どの言語でも・何台でも制御する SSH自動化エンジン のサンプル集。

---

## 収録ペイロード

| ファイル | カテゴリ | 内容 |
|---|---|---|
| 01_multi-lang-check.json | 診断 | Python/Node/Ruby/Go/Rust/Java を並列チェック |
| 02_deploy-nginx.json | DevOps | Nginx インストール→設定→起動→疎通まで一気通貫 |
| 03_git-pull-deploy.json | DevOps | git pull → 依存更新 → プロセス再起動 |
| 04_docker-compose-up.json | DevOps | Docker Compose スタック一括起動 |
| 05_ish-alpine-setup.json | iSH専用 | Alpine 初期セットアップ全自動 |
| 06_multi-server-sync.json | 上級 | jump host経由で3台並列実行 |

---

## 使い方

```bash
# セットアップ
npm install
npm link          # jssh コマンドをグローバル登録

# ペイロード内の変数を書き換えて実行
jssh payload.json

# ストリームモード（リアルタイム出力）
jssh -s payload.json
```

---

## ペイロード変数の変え方

各JSONファイルの `variables` セクションを編集するだけ：

```json
"variables": {
  "TARGET_HOST": "あなたのサーバーIP",
  "TARGET_USER": "ユーザー名"
}
```

---

## バージョンロードマップ

| バージョン | 内容 | 予定価格 |
|---|---|---|
| v1.0 (本パック) | 基本6ペイロード + エンジン | $29 |
| v1.5 | +Webフック通知 / Slack / Discord 連携ペイロード | $49 |
| v2.0 | GUI ペイロードビルダー統合 (Web UI) | $79 |
| v2.5 | Ansible/Terraform 変換ブリッジ | $129 |

---

## エンジンの特徴

- **DAG実行** — 依存関係を自動解決、順番を自動決定
- **並列グループ** — `parallel_group` で複数コマンドを同時実行
- **jump host対応** — 踏み台サーバー経由のSSHをワンコンフィグで
- **変数補間** — `{{VAR}}` で動的パラメータ注入
- **on_failure制御** — abort / continue / retry を各ステップで指定
- **軽量** — Node.js + ssh2 のみ。Ansible不要

---

## ライセンス

個人・商用利用可。再配布・転売不可。
© 2026 LuciFeR0x0systeM
