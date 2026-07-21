====================================================
  LuciFeR0x0systeM :: CUI CONTROL HUB
  iSH / Alpine Linux / POSIX sh + Python3
====================================================

■ 初回セットアップ（iSH内で実行）
  sh install.sh

■ 起動
  ./start.sh
  または
  python3 main.py

■ ファイル構成
  start.sh              ブートシーケンス＆起動スクリプト
  main.py               メインコントロールハブ（メニュー）
  modules/
    compliance.py       COMPLIANCE SCAN（監査ログ出力）
    rawtx.py            RAW TX GENERATOR（hexデータ生成）
    packet.py           PACKET INJECTION（GitHub API取得）
    syslog_mod.py       SYSTEM LOG（ログ表示・管理）
  logs/
    system.log          実行ログ（自動生成）

■ 動作要件
  - iSH (iOS) / Alpine Linux x86 32bit
  - python3（apk add python3）
  - ネットワーク接続（PACKET INJECTIONモジュール使用時）
  - Go/ghコマンド等のバイナリ不要

■ GitHub APIトークン（任意）
  PACKET INJECTIONでrate limitを避けたい場合は
  GitHub Personal Access Token（read:public_repo）を用意してください。
  起動時にプロンプトで入力できます（保存はされません）。

====================================================
