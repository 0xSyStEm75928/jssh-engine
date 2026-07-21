#!/bin/sh
# ============================================================
# LuciFeR0x0systeM :: iSH ONE-PASTE INSTALLER v2
# iSH 上でそのままペーストして実行するだけ
# ============================================================

set -e

BASE="$HOME/LuciFeR0x0systeM"
mkdir -p "$BASE/modules" "$BASE/logs"

echo "[*] ファイル展開中..."

# ── start.sh ────────────────────────────────────────────────
cat << 'EOF_START' > "$BASE/start.sh"
#!/bin/sh
RED='\033[1;31m'
GRN='\033[1;32m'
CYN='\033[1;36m'
DIM='\033[2;37m'
NC='\033[0m'

clear
printf "${RED}"
cat << 'LOGO'
  _     _   _  ____ _ _____ ___  ____
 | |   | | | |/ ___(_)  __|  __|| __ \
 | |   | | | | |   | | |__ | _| |    /
 | |___| |_| | |___| |  __|| |__|\ |\ \
 |_____|\_____|\____|_|_|  |_____|_| \_|
    :::: 0 x 0  :  s y s t e M ::::
LOGO
printf "${NC}\n"

BOOT_MSGS="
INITIALIZING DARWIN RECONSTRUCT...
DEPTH_COLLAPSE: 0x999
SECURE_KERNEL_EMULATION: ACTIVE
LOADING DEVIL_LOGIC MODULES...
INJECTING POLYMORPHIC PROTOCOLS...
MOUNTING /dev/null/sanity...
SYSTEM VERIFIED. NO SAFETY GUARANTEES.
"

TS=$(date '+%H:%M:%S')
echo "$BOOT_MSGS" | while IFS= read -r line; do
    [ -z "$line" ] && continue
    printf "${DIM}[${TS}]${NC} ${GRN}%s${NC}\n" "$line"
    sleep 0.35
done

printf "\n${CYN}>>> カーネル準備完了 — エンターキーで突入...${NC}\n"
read -r _

if ! command -v python3 >/dev/null 2>&1; then
    printf "${RED}[!] python3 が見つからん。実行: apk add python3${NC}\n"
    exit 1
fi

python3 "$(dirname "$0")/main.py"
EOF_START

# ── main.py ─────────────────────────────────────────────────
cat << 'EOF_MAIN' > "$BASE/main.py"
#!/usr/bin/env python3
# LuciFeR0x0systeM :: MAIN CONTROL HUB

import os
import sys
import time
from datetime import datetime

class C:
    RED  = '\033[1;31m'
    GRN  = '\033[1;32m'
    CYN  = '\033[1;36m'
    YLW  = '\033[1;33m'
    MAG  = '\033[1;35m'
    DIM  = '\033[2;37m'
    BOLD = '\033[1m'
    NC   = '\033[0m'

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
LOG_DIR  = os.path.join(BASE_DIR, 'logs')
os.makedirs(LOG_DIR, exist_ok=True)

def ts():
    return datetime.now().strftime('%H:%M:%S')

def write_log(tag: str, msg: str):
    log_path = os.path.join(LOG_DIR, 'system.log')
    entry = f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] [{tag}] {msg}\n"
    with open(log_path, 'a', encoding='utf-8') as f:
        f.write(entry)

def show_header():
    os.system('clear')
    print(f"{C.RED}")
    print("  _     _   _  ____ _ _____ ___  ____")
    print(" | |   | | | |/ ___(_)  __|  __|| __ \\")
    print(" | |   | | | | |   | | |__ | _| |    /")
    print(" | |___| |_| | |___| |  __|| |__|\ |\\ \\")
    print(" |_____|\\_____|\\____|_|_|  |_____|_| \\_|")
    print("     :::: 0 x 0  :  s y s t e M ::::")
    print(f"{C.NC}")
    print(f"{C.DIM}{'─'*54}{C.NC}")
    print(f"{C.DIM}  USER: root@LuciFeR  │  {ts()}  │  v2026.07{C.NC}")
    print(f"{C.DIM}{'─'*54}{C.NC}\n")

def show_menu():
    show_header()
    print(f"  {C.RED}[1]{C.NC}  COMPLIANCE SCAN     {C.DIM}// 監査ぶっこ抜き{C.NC}")
    print(f"  {C.RED}[2]{C.NC}  RAW TX GENERATOR    {C.DIM}// 16進トランザクション錬成{C.NC}")
    print(f"  {C.RED}[3]{C.NC}  PACKET INJECTION    {C.DIM}// GitHub APIぶん殴る{C.NC}")
    print(f"  {C.RED}[4]{C.NC}  SYSTEM LOG          {C.DIM}// ログ覗き見＆消去{C.NC}")
    print(f"  {C.RED}[5]{C.NC}  SYS PROBE           {C.DIM}// 環境情報ガチ抽出{C.NC}")
    print(f"  {C.RED}[6]{C.NC}  NET SCAN            {C.DIM}// ポートをノックする{C.NC}")
    print(f"  {C.RED}[7]{C.NC}  PROC WATCH          {C.DIM}// プロセス監視＆狩り{C.NC}")
    print(f"  {C.RED}[8]{C.NC}  SHELL EXEC          {C.DIM}// コマンドぶちこみ砲{C.NC}")
    print(f"  {C.DIM}[q]{C.NC}  EXIT / SUSPEND      {C.DIM}// 逃走{C.NC}\n")
    print(f"{C.DIM}{'─'*54}{C.NC}")

def main():
    while True:
        show_menu()
        try:
            choice = input(f"{C.CYN}LuciFeR0x0::# {C.NC}").strip().lower()
        except (EOFError, KeyboardInterrupt):
            break

        if choice == '1':
            write_log('MENU', 'Launched COMPLIANCE SCAN')
            from modules.compliance import run; run(write_log)
        elif choice == '2':
            write_log('MENU', 'Launched RAW TX GENERATOR')
            from modules.rawtx import run; run(write_log)
        elif choice == '3':
            write_log('MENU', 'Launched PACKET INJECTION')
            from modules.packet import run; run(write_log)
        elif choice == '4':
            write_log('MENU', 'Opened SYSTEM LOG')
            from modules.syslog_mod import run; run(LOG_DIR, write_log)
        elif choice == '5':
            write_log('MENU', 'Launched SYS PROBE')
            from modules.sysprobe import run; run(write_log)
        elif choice == '6':
            write_log('MENU', 'Launched NET SCAN')
            from modules.netscan import run; run(write_log)
        elif choice == '7':
            write_log('MENU', 'Launched PROC WATCH')
            from modules.procwatch import run; run(write_log)
        elif choice == '8':
            write_log('MENU', 'Launched SHELL EXEC')
            from modules.shellexec import run; run(write_log)
        elif choice in ('q', 'exit', 'quit'):
            break
        else:
            print(f"{C.YLW}[?] そんな番号ない{C.NC}")
            time.sleep(0.8)

    print(f"\n{C.RED}[!] システム休止。接続切断。{C.NC}\n")
    sys.exit(0)

if __name__ == '__main__':
    main()
EOF_MAIN

# ── modules/__init__.py ──────────────────────────────────────
: > "$BASE/modules/__init__.py"

# ── modules/compliance.py ────────────────────────────────────
cat << 'EOF_COMP' > "$BASE/modules/compliance.py"
#!/usr/bin/env python3
# MODULE: COMPLIANCE SCAN

import time, random, sys

class C:
    RED='\033[1;31m'; GRN='\033[1;32m'; CYN='\033[1;36m'
    YLW='\033[1;33m'; DIM='\033[2;37m'; NC='\033[0m'

SCAN_TARGETS = [
    '0xDEAD_BEEF::kernel_space',
    '/proc/sys/net/ipv4/conf',
    'daemon::saac_core@pid[1337]',
    'entropy_pool::urandom_bridge',
    '/dev/shm/volatile_cache',
    'socket::AF_UNIX[/tmp/.devil_sock]',
    'cgroup::v2/system.slice/lucifer.service',
    'kmod::polymorphic_inject.ko',
    'iptables::FORWARD_CHAIN[-j DROP]',
    'audit::syscall[execve,openat,ptrace]',
    'SELinux::enforce_policy_override',
    'seccomp::BPF_filter_bypass_check',
]

VERDICTS = [
    ('PASS', C.GRN, 'クリーン'),
    ('PASS', C.GRN, '正常稼働中'),
    ('WARN', C.YLW, '異常検知 — 非致命的'),
    ('PASS', C.GRN, '署名確認済'),
    ('WARN', C.YLW, 'エントロピー低下 — 監視継続'),
    ('PASS', C.GRN, '安定'),
    ('FAIL', C.RED, '違反検出 — 隔離フラグ設置'),
    ('PASS', C.GRN, '検証完了'),
]

def progress_bar(label, width=30):
    sys.stdout.write(f"  {C.DIM}[{label}]{C.NC} [")
    sys.stdout.flush()
    for i in range(width):
        time.sleep(random.uniform(0.02, 0.06))
        sys.stdout.write(f"{C.GRN}{'#' if i%3!=2 else '|'}{C.NC}")
        sys.stdout.flush()
    sys.stdout.write(f"] {C.GRN}完了{C.NC}\n")
    sys.stdout.flush()

def run(write_log):
    print(f"\n{C.RED}╔══════════════════════════════════════════╗")
    print(f"║  COMPLIANCE SCAN :: 監査エンジン v2.7   ║")
    print(f"╚══════════════════════════════════════════╝{C.NC}\n")
    print(f"{C.CYN}[*] スキャン面展開中...{C.NC}")
    time.sleep(0.5)
    progress_bar('INIT', 20)
    print()

    fail_count = warn_count = 0
    for target in SCAN_TARGETS:
        v_label, v_color, v_msg = random.choice(VERDICTS)
        time.sleep(random.uniform(0.15, 0.4))
        print(f"  {v_color}[{v_label}]{C.NC}  {C.DIM}{target}{C.NC}")
        print(f"         └─ {v_color}{v_msg}{C.NC}")
        write_log('COMPLIANCE', f'{v_label}::{target}::{v_msg}')
        if v_label == 'FAIL': fail_count += 1
        elif v_label == 'WARN': warn_count += 1

    print(f"\n{C.DIM}{'─'*46}{C.NC}")
    print(f"  {C.CYN}スキャン完了{C.NC}")
    print(f"  対象     : {len(SCAN_TARGETS)}")
    print(f"  {C.GRN}PASS{C.NC}     : {len(SCAN_TARGETS)-fail_count-warn_count}")
    print(f"  {C.YLW}WARN{C.NC}     : {warn_count}")
    print(f"  {C.RED}FAIL{C.NC}     : {fail_count}")

    if fail_count > 0:
        print(f"\n  {C.RED}[!!] 致命的フラグ検出 — 手動確認必要{C.NC}")
    elif warn_count > 0:
        print(f"\n  {C.YLW}[!]  警告あり — システム劣化中だが動作継続{C.NC}")
    else:
        print(f"\n  {C.GRN}[OK] 全システム正常{C.NC}")

    write_log('COMPLIANCE', f'完了 FAIL={fail_count} WARN={warn_count}')
    print(f"\n{C.DIM}Enterで戻る...{C.NC}"); input()
EOF_COMP

# ── modules/rawtx.py ─────────────────────────────────────────
cat << 'EOF_TX' > "$BASE/modules/rawtx.py"
#!/usr/bin/env python3
# MODULE: RAW TX GENERATOR

import os, time, random

class C:
    RED='\033[1;31m'; GRN='\033[1;32m'; CYN='\033[1;36m'
    YLW='\033[1;33m'; MAG='\033[1;35m'; DIM='\033[2;37m'; NC='\033[0m'

NODES = [
    'node-alpha  :: 192.168.0x1::7777',
    'node-beta   :: 10.0.dead.beef::8888',
    'node-gamma  :: fd00::c0de:f00d::9999',
    'node-omega  :: 127.0.0x0::1337',
    'relay-null  :: /dev/null/upstream',
]
TX_TYPES = ['TRANSFER','INVOKE','DELEGATE','DESTROY','MINT','INJECT']

def rand_hex(n): return os.urandom(n).hex()

def run(write_log):
    print(f"\n{C.RED}╔══════════════════════════════════════════╗")
    print(f"║  RAW TX GENERATOR :: 16進エンジン v3.1  ║")
    print(f"╚══════════════════════════════════════════╝{C.NC}\n")

    print(f"{C.CYN}送信先ノード選択:{C.NC}")
    for i, node in enumerate(NODES, 1):
        print(f"  {C.RED}[{i}]{C.NC} {node}")
    print(f"  {C.DIM}[0]{C.NC} ランダム\n")

    try:
        idx = int(input(f"{C.CYN}ノード番号 > {C.NC}").strip())
        target = NODES[idx-1] if 1 <= idx <= len(NODES) else random.choice(NODES)
    except (ValueError, KeyboardInterrupt):
        target = random.choice(NODES)

    try:
        raw = input(f"{C.CYN}TX数 [1-10, デフォ=3] > {C.NC}").strip()
        count = max(1, min(10, int(raw))) if raw else 3
    except ValueError:
        count = 3

    print(f"\n{C.YLW}[*] {count}件生成中 → {target.split('::')[0].strip()}{C.NC}\n")
    time.sleep(0.4)

    for i in range(1, count+1):
        tx = {
            'TX_ID':   f'0x{rand_hex(16)}',
            'TYPE':    random.choice(TX_TYPES),
            'NONCE':   f'0x{rand_hex(4)}',
            'TARGET':  target.split('::')[1].strip() if '::' in target else target,
            'PAYLOAD': f'0x{rand_hex(random.randint(16,64))}',
            'GAS':     f'{random.randint(21000,500000):,}',
            'SIG_R':   f'0x{rand_hex(32)}',
            'SIG_S':   f'0x{rand_hex(32)}',
            'SIG_V':   f'0x{random.choice(["1b","1c"])}',
        }
        print(f"{C.MAG}── TX #{i} {'─'*36}{C.NC}")
        for k, v in tx.items():
            print(f"  {C.DIM}{k:<16}{C.NC}: {C.GRN}{v}{C.NC}")
        print()
        write_log('RAWTX', f'TX#{i} id={tx["TX_ID"][:10]}... type={tx["TYPE"]}')
        time.sleep(0.25)

    print(f"{C.GRN}[OK] {count}件生成＆署名完了。{C.NC}")
    print(f"{C.DIM}(オフラインモード — ブロードキャスト無効){C.NC}\n")
    write_log('RAWTX', f'バッチ完了 count={count}')
    print(f"{C.DIM}Enterで戻る...{C.NC}"); input()
EOF_TX

# ── modules/packet.py ────────────────────────────────────────
cat << 'EOF_PKT' > "$BASE/modules/packet.py"
#!/usr/bin/env python3
# MODULE: PACKET INJECTION :: GitHub API

import urllib.request, urllib.error, json, time, sys
from datetime import datetime

class C:
    RED='\033[1;31m'; GRN='\033[1;32m'; CYN='\033[1;36m'
    YLW='\033[1;33m'; MAG='\033[1;35m'; DIM='\033[2;37m'; NC='\033[0m'

DEFAULT_REPO = 'torvalds/linux'
API_BASE     = 'https://api.github.com'
REFRESH_SECS = 30

def fetch_commits(repo, token=''):
    url = f'{API_BASE}/repos/{repo}/commits?per_page=10'
    req = urllib.request.Request(url)
    req.add_header('Accept', 'application/vnd.github.v3+json')
    req.add_header('User-Agent', 'LuciFeR0x0systeM/2.0')
    if token: req.add_header('Authorization', f'token {token}')
    with urllib.request.urlopen(req, timeout=15) as resp:
        return json.loads(resp.read().decode('utf-8'))

def print_commits(commits, repo):
    ts = datetime.now().strftime('%H:%M:%S')
    print(f"\n{C.CYN}[{ts}] PACKET INJECTION :: {repo}{C.NC}")
    print(f"{C.DIM}{'─'*56}{C.NC}")
    for i, c in enumerate(commits, 1):
        sha    = c.get('sha','N/A')[:10]
        msg    = c.get('commit',{}).get('message','').splitlines()[0][:48]
        author = c.get('commit',{}).get('author',{}).get('name','unknown')
        date   = c.get('commit',{}).get('author',{}).get('date','')[:10]
        print(f"  {C.RED}#{i:02d}{C.NC} {C.YLW}{sha}{C.NC}  {C.GRN}{author:<18}{C.NC} {C.DIM}{date}{C.NC}")
        print(f"       └─ {msg}")
    print(f"{C.DIM}{'─'*56}{C.NC}")

def countdown(secs):
    for r in range(secs, 0, -1):
        sys.stdout.write(f"\r  {C.DIM}次のフェッチまで {r:2d}秒  [q+Enterで終了]{C.NC} ")
        sys.stdout.flush()
        time.sleep(1)
    sys.stdout.write('\r'+' '*50+'\r'); sys.stdout.flush()

def run(write_log):
    print(f"\n{C.RED}╔══════════════════════════════════════════╗")
    print(f"║  PACKET INJECTION :: GitHub API v4.0   ║")
    print(f"╚══════════════════════════════════════════╝{C.NC}\n")

    repo_input = input(f"{C.CYN}ターゲットリポジトリ [{DEFAULT_REPO}] > {C.NC}").strip()
    repo = repo_input if '/' in repo_input else DEFAULT_REPO
    token = input(f"{C.CYN}GitHubトークン (空白=なし) > {C.NC}").strip()
    auto = input(f"{C.CYN}自動リフレッシュ {REFRESH_SECS}秒? [y/N] > {C.NC}").strip().lower() == 'y'

    write_log('PACKET', f'開始 repo={repo} auto={auto}')
    try:
        while True:
            print(f"{C.YLW}[*] コミット取得中...{C.NC}")
            try:
                commits = fetch_commits(repo, token)
                print_commits(commits, repo)
                write_log('PACKET', f'{len(commits)}件取得 from {repo}')
            except urllib.error.HTTPError as e:
                print(f"{C.RED}[!] HTTP {e.code}: {e.reason}{C.NC}")
            except urllib.error.URLError as e:
                print(f"{C.RED}[!] ネットワークエラー: {e.reason}{C.NC}")
            except Exception as e:
                print(f"{C.RED}[!] エラー: {e}{C.NC}")
            if not auto: break
            countdown(REFRESH_SECS)
    except KeyboardInterrupt:
        print(f"\n{C.YLW}[*] 自動リフレッシュ停止。{C.NC}")

    print(f"\n{C.DIM}Enterで戻る...{C.NC}"); input()
EOF_PKT

# ── modules/syslog_mod.py ────────────────────────────────────
cat << 'EOF_LOG' > "$BASE/modules/syslog_mod.py"
#!/usr/bin/env python3
# MODULE: SYSTEM LOG VIEWER

import os, time

class C:
    RED='\033[1;31m'; GRN='\033[1;32m'; CYN='\033[1;36m'
    YLW='\033[1;33m'; DIM='\033[2;37m'; NC='\033[0m'

TAG_COLORS = {
    'MENU':'\\033[2;37m', 'COMPLIANCE':'\\033[1;32m',
    'RAWTX':'\\033[1;33m', 'PACKET':'\\033[1;36m', 'SYS_INIT':'\\033[1;31m',
}

def colorize(line):
    for tag, color in {
        'MENU':C.DIM,'COMPLIANCE':C.GRN,'RAWTX':C.YLW,
        'PACKET':C.CYN,'SYS_INIT':C.RED
    }.items():
        if f'[{tag}]' in line:
            return f"{color}{line.rstrip()}{C.NC}"
    return f"{C.DIM}{line.rstrip()}{C.NC}"

def run(log_dir, write_log):
    log_path = os.path.join(log_dir, 'system.log')
    while True:
        os.system('clear')
        print(f"{C.RED}╔══════════════════════════════════════════╗")
        print(f"║  SYSTEM LOG :: イベントモニター          ║")
        print(f"╚══════════════════════════════════════════╝{C.NC}\n")
        print(f"  {C.RED}[1]{C.NC}  ログ表示 (直近40行)")
        print(f"  {C.RED}[2]{C.NC}  テール監視 (Ctrl+Cで停止)")
        print(f"  {C.RED}[3]{C.NC}  ログ全消去")
        print(f"  {C.DIM}[q]{C.NC}  メインメニューへ\n")
        try:
            choice = input(f"{C.CYN}SYSLOG::# {C.NC}").strip().lower()
        except (EOFError, KeyboardInterrupt):
            break

        if choice == '1':
            if not os.path.exists(log_path):
                print(f"{C.YLW}[!] ログファイルなし。{C.NC}")
            else:
                with open(log_path,'r',encoding='utf-8') as f: lines = f.readlines()
                os.system('clear')
                print(f"{C.CYN}── SYSTEM LOG ({len(lines)}行) ──{C.NC}\n")
                for l in (lines[-40:] if len(lines)>40 else lines): print(colorize(l))
            print(f"\n{C.DIM}Enterで続行...{C.NC}"); input()
        elif choice == '2':
            if not os.path.exists(log_path):
                print(f"{C.YLW}[!] ログなし。他モジュール先に動かして。{C.NC}"); time.sleep(1.5); continue
            print(f"{C.CYN}[*] テール中... (Ctrl+Cで停止){C.NC}\n")
            try:
                with open(log_path,'r',encoding='utf-8') as f:
                    for l in f.readlines()[-20:]: print(colorize(l))
                    while True:
                        l = f.readline()
                        if l: print(colorize(l), end='', flush=True)
                        else: time.sleep(0.5)
            except KeyboardInterrupt:
                print(f"\n{C.YLW}[*] テール停止。{C.NC}"); time.sleep(0.5)
        elif choice == '3':
            if input(f"{C.RED}[!] 全ログ消去? [yes/N] > {C.NC}").strip().lower() == 'yes':
                open(log_path,'w').close()
                write_log('SYSLOG','ログ消去済')
                print(f"{C.GRN}[OK] 消去完了。{C.NC}")
            else:
                print(f"{C.DIM}[--] キャンセル。{C.NC}")
            time.sleep(1)
        elif choice == 'q':
            break
        else:
            print(f"{C.YLW}[?] そんな番号ない{C.NC}"); time.sleep(0.6)
EOF_LOG

# ── modules/sysprobe.py ──────────────────────────────────────
cat << 'EOF_SYS' > "$BASE/modules/sysprobe.py"
#!/usr/bin/env python3
# MODULE: SYS PROBE :: 環境情報ガチ抽出

import os, subprocess, time

class C:
    RED='\033[1;31m'; GRN='\033[1;32m'; CYN='\033[1;36m'
    YLW='\033[1;33m'; DIM='\033[2;37m'; NC='\033[0m'

def cmd(c):
    try:
        return subprocess.check_output(c, shell=True, stderr=subprocess.DEVNULL,
                                       timeout=5).decode('utf-8').strip()
    except Exception:
        return '取得失敗'

def section(title):
    print(f"\n{C.RED}── {title} {'─'*(42-len(title))}{C.NC}")

def row(label, value):
    print(f"  {C.DIM}{label:<20}{C.NC}: {C.GRN}{value}{C.NC}")

def run(write_log):
    os.system('clear')
    print(f"{C.RED}╔══════════════════════════════════════════╗")
    print(f"║  SYS PROBE :: 環境情報ガチ抽出          ║")
    print(f"╚══════════════════════════════════════════╝{C.NC}")

    section('カーネル / OS')
    row('ホスト名',    cmd('hostname'))
    row('カーネル',   cmd('uname -r'))
    row('アーキ',     cmd('uname -m'))
    row('OS情報',     cmd('cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d \'"\''))

    section('CPU / メモリ')
    row('CPU',        cmd('cat /proc/cpuinfo | grep "model name" | head -1 | cut -d: -f2 | xargs'))
    row('コア数',     cmd('nproc'))
    row('メモリ合計', cmd('grep MemTotal /proc/meminfo | awk \'{print $2" kB"}\''))
    row('空きメモリ', cmd('grep MemAvailable /proc/meminfo | awk \'{print $2" kB"}\''))

    section('ストレージ')
    df = cmd('df -h / | tail -1')
    row('ルート(/)',   df)

    section('ネットワーク')
    row('IPアドレス', cmd('ip addr show 2>/dev/null | grep "inet " | grep -v 127 | awk \'{print $2}\' | head -1 || hostname -i 2>/dev/null'))
    row('デフォルトGW', cmd('ip route 2>/dev/null | grep default | awk \'{print $3}\' | head -1 || netstat -rn 2>/dev/null | grep "^0.0.0.0" | awk \'{print $2}\''))

    section('ランタイム')
    row('Python',     cmd('python3 --version'))
    row('Shell',      cmd('echo $SHELL'))
    row('起動時間',   cmd('uptime | sed "s/.*up //" | cut -d, -f1'))
    row('現在時刻',   cmd('date "+%Y-%m-%d %H:%M:%S %Z"'))

    write_log('SYSPROBE', f'ホスト={cmd("hostname")} カーネル={cmd("uname -r")}')
    print(f"\n{C.DIM}Enterで戻る...{C.NC}"); input()
EOF_SYS

# ── modules/netscan.py ───────────────────────────────────────
cat << 'EOF_NET' > "$BASE/modules/netscan.py"
#!/usr/bin/env python3
# MODULE: NET SCAN :: ポートをノックする

import socket, time, sys

class C:
    RED='\033[1;31m'; GRN='\033[1;32m'; CYN='\033[1;36m'
    YLW='\033[1;33m'; DIM='\033[2;37m'; NC='\033[0m'

PRESETS = {
    '1': ('よく使うポート',  [21,22,23,25,53,80,110,143,443,3306,5432,6379,8080,8443,27017]),
    '2': ('Webサービス系',   [80,443,8080,8443,3000,4000,5000,8000,9000]),
    '3': ('DBポート系',      [3306,5432,6379,27017,5984,9200,7474]),
    '4': ('SSH/管理系',      [22,2222,3389,5900,5901]),
}

def scan_port(host, port, timeout=1.0):
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(timeout)
        result = s.connect_ex((host, port))
        s.close()
        return result == 0
    except Exception:
        return False

def run(write_log):
    os.system('clear') if False else None
    print(f"\n{C.RED}╔══════════════════════════════════════════╗")
    print(f"║  NET SCAN :: ポートノッカー              ║")
    print(f"╚══════════════════════════════════════════╝{C.NC}\n")

    print(f"{C.CYN}スキャンプリセット:{C.NC}")
    for k, (label, ports) in PRESETS.items():
        print(f"  {C.RED}[{k}]{C.NC} {label} ({len(ports)}ポート)")
    print(f"  {C.RED}[5]{C.NC} カスタムポート指定\n")

    try:
        choice = input(f"{C.CYN}選択 > {C.NC}").strip()
    except KeyboardInterrupt:
        return

    if choice in PRESETS:
        label, ports = PRESETS[choice]
    elif choice == '5':
        raw = input(f"{C.CYN}ポート番号(カンマ区切り) > {C.NC}").strip()
        try:
            ports = [int(p.strip()) for p in raw.split(',') if p.strip()]
            label = 'カスタム'
        except ValueError:
            print(f"{C.RED}[!] 無効な入力{C.NC}"); time.sleep(1); return
    else:
        print(f"{C.YLW}[?] そんな番号ない{C.NC}"); time.sleep(1); return

    host = input(f"{C.CYN}ターゲットホスト [127.0.0.1] > {C.NC}").strip() or '127.0.0.1'

    try:
        timeout = float(input(f"{C.CYN}タイムアウト秒 [0.5] > {C.NC}").strip() or '0.5')
    except ValueError:
        timeout = 0.5

    print(f"\n{C.YLW}[*] {host} をノック中 — {label} ({len(ports)}ポート){C.NC}\n")
    write_log('NETSCAN', f'開始 host={host} ports={len(ports)}')

    open_ports = []
    for port in ports:
        sys.stdout.write(f"  {C.DIM}ポート {port:<6}{C.NC} ... ")
        sys.stdout.flush()
        if scan_port(host, port, timeout):
            print(f"{C.GRN}[OPEN]{C.NC}")
            open_ports.append(port)
            write_log('NETSCAN', f'OPEN {host}:{port}')
        else:
            print(f"{C.RED}[CLOSED]{C.NC}")

    print(f"\n{C.DIM}{'─'*44}{C.NC}")
    print(f"  {C.CYN}スキャン完了{C.NC}")
    print(f"  対象: {len(ports)}ポート  {C.GRN}OPEN: {len(open_ports)}{C.NC}  {C.RED}CLOSED: {len(ports)-len(open_ports)}{C.NC}")
    if open_ports:
        print(f"  解放済: {C.GRN}{', '.join(map(str,open_ports))}{C.NC}")

    write_log('NETSCAN', f'完了 open={open_ports}')
    print(f"\n{C.DIM}Enterで戻る...{C.NC}"); input()
EOF_NET

# ── modules/procwatch.py ─────────────────────────────────────
cat << 'EOF_PROC' > "$BASE/modules/procwatch.py"
#!/usr/bin/env python3
# MODULE: PROC WATCH :: プロセス監視＆狩り

import os, time, subprocess

class C:
    RED='\033[1;31m'; GRN='\033[1;32m'; CYN='\033[1;36m'
    YLW='\033[1;33m'; DIM='\033[2;37m'; NC='\033[0m'

def get_procs():
    try:
        out = subprocess.check_output(
            ['ps', 'aux'], stderr=subprocess.DEVNULL
        ).decode('utf-8').strip().split('\n')
        return out
    except Exception:
        try:
            out = subprocess.check_output(
                ['ps', '-e', '-o', 'pid,comm'], stderr=subprocess.DEVNULL
            ).decode('utf-8').strip().split('\n')
            return out
        except Exception:
            return ['取得失敗']

def run(write_log):
    while True:
        os.system('clear')
        print(f"{C.RED}╔══════════════════════════════════════════╗")
        print(f"║  PROC WATCH :: プロセス監視＆狩り       ║")
        print(f"╚══════════════════════════════════════════╝{C.NC}\n")
        print(f"  {C.RED}[1]{C.NC}  プロセス一覧表示")
        print(f"  {C.RED}[2]{C.NC}  プロセス名で検索")
        print(f"  {C.RED}[3]{C.NC}  PIDでkill (要注意)")
        print(f"  {C.RED}[4]{C.NC}  自動リフレッシュ監視 (5秒間隔)")
        print(f"  {C.DIM}[q]{C.NC}  戻る\n")

        try:
            choice = input(f"{C.CYN}PROC::# {C.NC}").strip().lower()
        except (EOFError, KeyboardInterrupt):
            break

        if choice == '1':
            procs = get_procs()
            os.system('clear')
            print(f"{C.CYN}── プロセス一覧 ({len(procs)-1}件) ──{C.NC}\n")
            print(f"{C.DIM}{procs[0]}{C.NC}")
            for p in procs[1:21]:
                print(f"{C.GRN}{p}{C.NC}")
            if len(procs) > 22:
                print(f"{C.DIM}  ...他 {len(procs)-22} 件{C.NC}")
            write_log('PROCWATCH', f'一覧取得 {len(procs)-1}件')
            print(f"\n{C.DIM}Enterで戻る...{C.NC}"); input()

        elif choice == '2':
            kw = input(f"{C.CYN}検索キーワード > {C.NC}").strip()
            procs = [p for p in get_procs() if kw.lower() in p.lower()]
            print(f"\n{C.CYN}[{kw}] ヒット: {len(procs)}件{C.NC}")
            for p in procs:
                print(f"  {C.YLW}{p}{C.NC}")
            write_log('PROCWATCH', f'検索 kw={kw} hits={len(procs)}')
            print(f"\n{C.DIM}Enterで戻る...{C.NC}"); input()

        elif choice == '3':
            pid = input(f"{C.RED}[!] killするPID > {C.NC}").strip()
            try:
                int(pid)
                confirm = input(f"{C.RED}PID {pid} をkill? [yes/N] > {C.NC}").strip().lower()
                if confirm == 'yes':
                    os.kill(int(pid), 15)
                    print(f"{C.GRN}[OK] PID {pid} にSIGTERM送信。{C.NC}")
                    write_log('PROCWATCH', f'SIGTERM → PID {pid}')
                else:
                    print(f"{C.DIM}[--] キャンセル。{C.NC}")
            except (ValueError, ProcessLookupError, PermissionError) as e:
                print(f"{C.RED}[!] エラー: {e}{C.NC}")
            time.sleep(1.5)

        elif choice == '4':
            print(f"{C.CYN}[*] 監視中... (Ctrl+Cで停止){C.NC}\n")
            try:
                while True:
                    procs = get_procs()
                    os.system('clear')
                    print(f"{C.RED}PROC WATCH :: LIVE  {C.DIM}(Ctrl+Cで停止){C.NC}")
                    print(f"{C.DIM}{'─'*54}{C.NC}")
                    print(f"{C.DIM}{procs[0] if procs else ''}{C.NC}")
                    for p in procs[1:16]:
                        print(f"{C.GRN}{p}{C.NC}")
                    print(f"\n{C.DIM}総プロセス数: {len(procs)-1}  │  5秒後リフレッシュ{C.NC}")
                    time.sleep(5)
            except KeyboardInterrupt:
                print(f"\n{C.YLW}[*] 監視停止。{C.NC}"); time.sleep(0.5)

        elif choice == 'q':
            break
        else:
            print(f"{C.YLW}[?] そんな番号ない{C.NC}"); time.sleep(0.6)
EOF_PROC

# ── modules/shellexec.py ─────────────────────────────────────
cat << 'EOF_SHELL' > "$BASE/modules/shellexec.py"
#!/usr/bin/env python3
# MODULE: SHELL EXEC :: コマンドぶちこみ砲

import subprocess, time, os
from datetime import datetime

class C:
    RED='\033[1;31m'; GRN='\033[1;32m'; CYN='\033[1;36m'
    YLW='\033[1;33m'; DIM='\033[2;37m'; NC='\033[0m'

BLACKLIST = ['rm -rf /', 'mkfs', ':(){:|:&};:',
             'dd if=/dev/zero', '> /dev/sda']

QUICK_CMDS = [
    ('uname -a',           'カーネル情報'),
    ('df -h',              'ディスク使用量'),
    ('free -h',            'メモリ使用量'),
    ('ip addr',            'ネットワーク情報'),
    ('ps aux | head -20',  'プロセス一覧'),
    ('cat /etc/passwd',    'ユーザー一覧'),
    ('env',                '環境変数ダンプ'),
    ('netstat -tuln',      '待受ポート一覧'),
]

def safe_exec(cmd_str, timeout=10):
    for blocked in BLACKLIST:
        if blocked in cmd_str:
            return None, f'[BLOCKED] 危険コマンド検知: {blocked}'
    try:
        result = subprocess.run(
            cmd_str, shell=True, capture_output=True,
            text=True, timeout=timeout
        )
        return result.returncode, result.stdout + result.stderr
    except subprocess.TimeoutExpired:
        return -1, '[TIMEOUT] タイムアウト'
    except Exception as e:
        return -1, f'[ERROR] {e}'

def run(write_log):
    history = []
    while True:
        os.system('clear')
        print(f"{C.RED}╔══════════════════════════════════════════╗")
        print(f"║  SHELL EXEC :: コマンドぶちこみ砲       ║")
        print(f"╚══════════════════════════════════════════╝{C.NC}\n")
        print(f"  {C.RED}[1]{C.NC}  コマンド直接入力")
        print(f"  {C.RED}[2]{C.NC}  クイックコマンド選択")
        print(f"  {C.RED}[3]{C.NC}  実行履歴")
        print(f"  {C.DIM}[q]{C.NC}  戻る\n")

        try:
            choice = input(f"{C.CYN}SHELL::# {C.NC}").strip().lower()
        except (EOFError, KeyboardInterrupt):
            break

        if choice == '1':
            try:
                cmd_str = input(f"{C.YLW}$ {C.NC}").strip()
            except (EOFError, KeyboardInterrupt):
                continue
            if not cmd_str:
                continue
            ts = datetime.now().strftime('%H:%M:%S')
            print(f"{C.DIM}[{ts}] 実行中...{C.NC}\n")
            rc, out = safe_exec(cmd_str)
            if rc is None:
                print(f"{C.RED}{out}{C.NC}")
            else:
                color = C.GRN if rc == 0 else C.YLW
                print(f"{color}{out}{C.NC}")
                print(f"{C.DIM}終了コード: {rc}{C.NC}")
                history.append((ts, cmd_str, rc))
                write_log('SHELLEXEC', f'rc={rc} cmd={cmd_str[:60]}')
            print(f"\n{C.DIM}Enterで戻る...{C.NC}"); input()

        elif choice == '2':
            print(f"\n{C.CYN}クイックコマンド:{C.NC}")
            for i, (cmd_str, label) in enumerate(QUICK_CMDS, 1):
                print(f"  {C.RED}[{i}]{C.NC} {label:<20} {C.DIM}{cmd_str}{C.NC}")
            try:
                sel = int(input(f"\n{C.CYN}番号 > {C.NC}").strip())
                cmd_str, label = QUICK_CMDS[sel-1]
            except (ValueError, IndexError, KeyboardInterrupt):
                continue
            ts = datetime.now().strftime('%H:%M:%S')
            print(f"\n{C.YLW}$ {cmd_str}{C.NC}\n")
            rc, out = safe_exec(cmd_str)
            color = C.GRN if rc == 0 else C.YLW
            print(f"{color}{out}{C.NC}")
            print(f"{C.DIM}終了コード: {rc}{C.NC}")
            history.append((ts, cmd_str, rc))
            write_log('SHELLEXEC', f'quick rc={rc} cmd={cmd_str}')
            print(f"\n{C.DIM}Enterで戻る...{C.NC}"); input()

        elif choice == '3':
            if not history:
                print(f"{C.YLW}[!] 履歴なし{C.NC}"); time.sleep(1); continue
            print(f"\n{C.CYN}── 実行履歴 ({len(history)}件) ──{C.NC}")
            for ts, cmd_str, rc in history[-20:]:
                color = C.GRN if rc == 0 else C.YLW
                print(f"  {C.DIM}[{ts}]{C.NC} {color}[{rc}]{C.NC} {cmd_str}")
            print(f"\n{C.DIM}Enterで戻る...{C.NC}"); input()

        elif choice == 'q':
            break
        else:
            print(f"{C.YLW}[?] そんな番号ない{C.NC}"); time.sleep(0.6)
EOF_SHELL

# ── パーミッション設定 ────────────────────────────────────────
chmod +x "$BASE/start.sh"

# ── iSH 自動起動設定 (任意) ─────────────────────────────────
PROFILE="$HOME/.profile"
AUTOSTART_LINE="cd \$HOME/LuciFeR0x0systeM && sh start.sh"

if grep -q 'LuciFeR0x0systeM' "$PROFILE" 2>/dev/null; then
    echo "[--] 自動起動は既に設定済み"
else
    printf '\n# LuciFeR0x0systeM 自動起動\n' >> "$PROFILE"
    printf '%s\n' "$AUTOSTART_LINE" >> "$PROFILE"
    echo "[OK] ~/.profile に自動起動を追記しました"
fi

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  インストール完了！                  ║"
echo "║                                      ║"
echo "║  起動:  cd ~/LuciFeR0x0systeM        ║"
echo "║         sh start.sh                  ║"
echo "║                                      ║"
echo "║  次回iSH起動時から自動スタート        ║"
echo "╚══════════════════════════════════════╝"
