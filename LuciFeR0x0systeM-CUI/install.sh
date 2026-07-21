#!/bin/sh
# ============================================================
# LuciFeR0x0systeM :: iSH セットアップスクリプト
# iSH (Alpine Linux) で初回のみ実行してください
# ============================================================

echo "[*] Updating apk..."
apk update

echo "[*] Installing python3..."
apk add python3

echo "[*] Setting execute permissions..."
chmod +x start.sh

echo ""
echo "[OK] Setup complete!"
echo "     Run: ./start.sh"
