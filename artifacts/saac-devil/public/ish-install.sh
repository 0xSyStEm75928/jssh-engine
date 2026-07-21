#!/bin/sh
# ============================================================
# LuciFeR0x0systeM :: iSH ONE-PASTE INSTALLER
# iSH 上でそのままペーストして実行するだけ
# ============================================================

set -e

BASE="$HOME/LuciFeR0x0systeM"
mkdir -p "$BASE/modules" "$BASE/logs"

echo "[*] Writing files..."

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

printf "\n${CYN}>>> KERNEL READY — PRESS ENTER TO CONTINUE...${NC}\n"
read -r _

if ! command -v python3 >/dev/null 2>&1; then
    printf "${RED}[!] python3 not found. Run: apk add python3${NC}\n"
    exit 1
fi

python3 "$(dirname "$0")/main.py"
EOF_START

# ── main.py ─────────────────────────────────────────────────
cat << 'EOF_MAIN' > "$BASE/main.py"
#!/usr/bin/env python3
# ============================================================
# LuciFeR0x0systeM :: MAIN CONTROL HUB
# ============================================================

import os
import sys
import time
from datetime import datetime

class C:
    RED    = '\033[1;31m'
    GRN    = '\033[1;32m'
    CYN    = '\033[1;36m'
    YLW    = '\033[1;33m'
    MAG    = '\033[1;35m'
    DIM    = '\033[2;37m'
    BOLD   = '\033[1m'
    NC     = '\033[0m'

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
    print(f"  {C.RED}[1]{C.NC}  COMPLIANCE SCAN     {C.DIM}// audit & monitor{C.NC}")
    print(f"  {C.RED}[2]{C.NC}  RAW TX GENERATOR    {C.DIM}// hex transaction{C.NC}")
    print(f"  {C.RED}[3]{C.NC}  PACKET INJECTION    {C.DIM}// GitHub API fetch{C.NC}")
    print(f"  {C.RED}[4]{C.NC}  SYSTEM LOG          {C.DIM}// view/clear logs{C.NC}")
    print(f"  {C.DIM}[q]{C.NC}  EXIT / SUSPEND\n")
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
            from modules.compliance import run
            run(write_log)
        elif choice == '2':
            write_log('MENU', 'Launched RAW TX GENERATOR')
            from modules.rawtx import run
            run(write_log)
        elif choice == '3':
            write_log('MENU', 'Launched PACKET INJECTION')
            from modules.packet import run
            run(write_log)
        elif choice == '4':
            write_log('MENU', 'Opened SYSTEM LOG')
            from modules.syslog_mod import run
            run(LOG_DIR, write_log)
        elif choice in ('q', 'exit', 'quit'):
            break
        else:
            print(f"{C.YLW}[?] Invalid option{C.NC}")
            time.sleep(0.8)

    print(f"\n{C.RED}[!] System suspended. Connection terminated.{C.NC}\n")
    sys.exit(0)

if __name__ == '__main__':
    main()
EOF_MAIN

# ── modules/__init__.py ──────────────────────────────────────
cat << 'EOF_INIT' > "$BASE/modules/__init__.py"
EOF_INIT

# ── modules/compliance.py ────────────────────────────────────
cat << 'EOF_COMP' > "$BASE/modules/compliance.py"
#!/usr/bin/env python3
# MODULE: COMPLIANCE SCAN

import time
import random
import sys

class C:
    RED  = '\033[1;31m'
    GRN  = '\033[1;32m'
    CYN  = '\033[1;36m'
    YLW  = '\033[1;33m'
    DIM  = '\033[2;37m'
    NC   = '\033[0m'

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
    ('PASS', C.GRN, 'clean'),
    ('PASS', C.GRN, 'nominal'),
    ('WARN', C.YLW, 'anomaly detected — non-critical'),
    ('PASS', C.GRN, 'verified'),
    ('WARN', C.YLW, 'entropy low — monitor'),
    ('PASS', C.GRN, 'stable'),
    ('FAIL', C.RED, 'VIOLATION — quarantine flag set'),
    ('PASS', C.GRN, 'signed & verified'),
]

def progress_bar(label: str, width: int = 30):
    sys.stdout.write(f"  {C.DIM}[{label}]{C.NC} [")
    sys.stdout.flush()
    for i in range(width):
        time.sleep(random.uniform(0.02, 0.06))
        char = '#' if i % 3 != 2 else '|'
        sys.stdout.write(f"{C.GRN}{char}{C.NC}")
        sys.stdout.flush()
    sys.stdout.write(f"] {C.GRN}DONE{C.NC}\n")
    sys.stdout.flush()

def run(write_log):
    print(f"\n{C.RED}╔══════════════════════════════════════════╗")
    print(f"║  COMPLIANCE SCAN :: AUDIT ENGINE v2.7   ║")
    print(f"╚══════════════════════════════════════════╝{C.NC}\n")

    print(f"{C.CYN}[*] Initializing scan surface...{C.NC}")
    time.sleep(0.5)
    progress_bar('INIT', 20)
    print()

    fail_count = 0
    warn_count = 0

    for target in SCAN_TARGETS:
        v_label, v_color, v_msg = random.choice(VERDICTS)
        time.sleep(random.uniform(0.15, 0.4))
        status = f"{v_color}[{v_label}]{C.NC}"
        print(f"  {status}  {C.DIM}{target}{C.NC}")
        print(f"         └─ {v_color}{v_msg}{C.NC}")
        write_log('COMPLIANCE', f'{v_label} :: {target} :: {v_msg}')
        if v_label == 'FAIL':
            fail_count += 1
        elif v_label == 'WARN':
            warn_count += 1

    print(f"\n{C.DIM}{'─'*46}{C.NC}")
    print(f"  {C.CYN}SCAN COMPLETE{C.NC}")
    print(f"  Targets  : {len(SCAN_TARGETS)}")
    print(f"  {C.GRN}PASS{C.NC}     : {len(SCAN_TARGETS) - fail_count - warn_count}")
    print(f"  {C.YLW}WARN{C.NC}     : {warn_count}")
    print(f"  {C.RED}FAIL{C.NC}     : {fail_count}")

    if fail_count > 0:
        print(f"\n  {C.RED}[!!] CRITICAL FLAGS DETECTED — MANUAL REVIEW REQUIRED{C.NC}")
    elif warn_count > 0:
        print(f"\n  {C.YLW}[!]  Warnings present — system degraded but operational{C.NC}")
    else:
        print(f"\n  {C.GRN}[OK] All systems nominal{C.NC}")

    write_log('COMPLIANCE', f'Scan complete. FAIL={fail_count} WARN={warn_count}')
    print(f"\n{C.DIM}Press Enter to return...{C.NC}")
    input()
EOF_COMP

# ── modules/rawtx.py ─────────────────────────────────────────
cat << 'EOF_TX' > "$BASE/modules/rawtx.py"
#!/usr/bin/env python3
# MODULE: RAW TX GENERATOR

import os
import time
import random

class C:
    RED  = '\033[1;31m'
    GRN  = '\033[1;32m'
    CYN  = '\033[1;36m'
    YLW  = '\033[1;33m'
    MAG  = '\033[1;35m'
    DIM  = '\033[2;37m'
    NC   = '\033[0m'

NODES = [
    'node-alpha  :: 192.168.0x1::7777',
    'node-beta   :: 10.0.dead.beef::8888',
    'node-gamma  :: fd00::c0de:f00d::9999',
    'node-omega  :: 127.0.0x0::1337',
    'relay-null  :: /dev/null/upstream',
]

TX_TYPES = ['TRANSFER', 'INVOKE', 'DELEGATE', 'DESTROY', 'MINT', 'INJECT']

def rand_hex(n: int) -> str:
    return os.urandom(n).hex()

def format_block(data: dict) -> str:
    lines = []
    for k, v in data.items():
        lines.append(f"  {C.DIM}{k:<16}{C.NC}: {C.GRN}{v}{C.NC}")
    return '\n'.join(lines)

def run(write_log):
    print(f"\n{C.RED}╔══════════════════════════════════════════╗")
    print(f"║  RAW TX GENERATOR :: HEX ENGINE v3.1    ║")
    print(f"╚══════════════════════════════════════════╝{C.NC}\n")

    print(f"{C.CYN}Select target node:{C.NC}")
    for i, node in enumerate(NODES, 1):
        print(f"  {C.RED}[{i}]{C.NC} {node}")
    print(f"  {C.DIM}[0]{C.NC} Random\n")

    try:
        sel = input(f"{C.CYN}Node # > {C.NC}").strip()
        idx = int(sel)
        if idx == 0 or idx > len(NODES):
            target = random.choice(NODES)
        else:
            target = NODES[idx - 1]
    except (ValueError, KeyboardInterrupt):
        target = random.choice(NODES)

    try:
        count_raw = input(f"{C.CYN}TX count [1-10, default=3] > {C.NC}").strip()
        count = max(1, min(10, int(count_raw))) if count_raw else 3
    except ValueError:
        count = 3

    print(f"\n{C.YLW}[*] Generating {count} transaction(s) → {target.split('::')[0].strip()}{C.NC}\n")
    time.sleep(0.4)

    for i in range(1, count + 1):
        tx_type = random.choice(TX_TYPES)
        tx_id   = rand_hex(16)
        nonce   = rand_hex(4)
        payload = rand_hex(random.randint(16, 64))
        gas     = random.randint(21000, 500000)
        sig_r   = rand_hex(32)
        sig_s   = rand_hex(32)
        sig_v   = random.choice(['1b', '1c'])

        tx = {
            'TX_ID':   f'0x{tx_id}',
            'TYPE':    tx_type,
            'NONCE':   f'0x{nonce}',
            'TARGET':  target.split('::')[1].strip() if '::' in target else target,
            'PAYLOAD': f'0x{payload}',
            'GAS':     f'{gas:,}',
            'SIG_R':   f'0x{sig_r}',
            'SIG_S':   f'0x{sig_s}',
            'SIG_V':   f'0x{sig_v}',
        }

        print(f"{C.MAG}── TX #{i} {'─'*36}{C.NC}")
        print(format_block(tx))
        print()

        write_log('RAWTX', f'TX#{i} id=0x{tx_id[:8]}... type={tx_type}')
        time.sleep(0.25)

    print(f"{C.GRN}[OK] {count} transaction(s) generated & signed.{C.NC}")
    print(f"{C.DIM}(Broadcast disabled in offline mode){C.NC}\n")
    write_log('RAWTX', f'Batch complete. count={count}')
    print(f"{C.DIM}Press Enter to return...{C.NC}")
    input()
EOF_TX

# ── modules/packet.py ────────────────────────────────────────
cat << 'EOF_PKT' > "$BASE/modules/packet.py"
#!/usr/bin/env python3
# MODULE: PACKET INJECTION :: GitHub API

import urllib.request
import urllib.error
import json
import time
import sys
from datetime import datetime

class C:
    RED  = '\033[1;31m'
    GRN  = '\033[1;32m'
    CYN  = '\033[1;36m'
    YLW  = '\033[1;33m'
    MAG  = '\033[1;35m'
    DIM  = '\033[2;37m'
    NC   = '\033[0m'

DEFAULT_REPO = 'gitcoinco/gitcoin_co_30'
API_BASE     = 'https://api.github.com'
REFRESH_SECS = 30

def fetch_commits(repo: str, token: str = '') -> list:
    url = f'{API_BASE}/repos/{repo}/commits?per_page=10'
    req = urllib.request.Request(url)
    req.add_header('Accept', 'application/vnd.github.v3+json')
    req.add_header('User-Agent', 'LuciFeR0x0systeM-CUI/1.0')
    if token:
        req.add_header('Authorization', f'token {token}')
    with urllib.request.urlopen(req, timeout=15) as resp:
        return json.loads(resp.read().decode('utf-8'))

def print_commits(commits: list, repo: str):
    ts = datetime.now().strftime('%H:%M:%S')
    print(f"\n{C.CYN}[{ts}] PACKET INJECTION :: {repo}{C.NC}")
    print(f"{C.DIM}{'─'*56}{C.NC}")
    for i, c in enumerate(commits, 1):
        sha    = c.get('sha', 'N/A')[:10]
        msg    = c.get('commit', {}).get('message', '').splitlines()[0][:48]
        author = c.get('commit', {}).get('author', {}).get('name', 'unknown')
        date   = c.get('commit', {}).get('author', {}).get('date', '')[:10]
        print(f"  {C.RED}#{i:02d}{C.NC} {C.YLW}{sha}{C.NC}  {C.GRN}{author:<18}{C.NC} {C.DIM}{date}{C.NC}")
        print(f"       └─ {msg}")
    print(f"{C.DIM}{'─'*56}{C.NC}")

def countdown(secs: int):
    for remaining in range(secs, 0, -1):
        sys.stdout.write(f"\r  {C.DIM}Next fetch in {remaining:2d}s  [q+Enter to quit]{C.NC} ")
        sys.stdout.flush()
        time.sleep(1)
    sys.stdout.write('\r' + ' '*50 + '\r')
    sys.stdout.flush()

def run(write_log):
    print(f"\n{C.RED}╔══════════════════════════════════════════╗")
    print(f"║  PACKET INJECTION :: GitHub API v4.0    ║")
    print(f"╚══════════════════════════════════════════╝{C.NC}\n")

    repo_input = input(f"{C.CYN}Target repo [{DEFAULT_REPO}] > {C.NC}").strip()
    repo = repo_input if '/' in repo_input else DEFAULT_REPO

    token = input(f"{C.CYN}GitHub token (空白=なし) > {C.NC}").strip()

    auto_input = input(f"{C.CYN}Auto-refresh {REFRESH_SECS}s? [y/N] > {C.NC}").strip().lower()
    auto_refresh = auto_input == 'y'

    write_log('PACKET', f'Starting fetch :: repo={repo} auto={auto_refresh}')

    try:
        while True:
            print(f"{C.YLW}[*] Fetching commits...{C.NC}")
            try:
                commits = fetch_commits(repo, token)
                print_commits(commits, repo)
                write_log('PACKET', f'Fetched {len(commits)} commits from {repo}')
            except urllib.error.HTTPError as e:
                print(f"{C.RED}[!] HTTP {e.code}: {e.reason}{C.NC}")
                write_log('PACKET', f'HTTP error {e.code} :: {repo}')
            except urllib.error.URLError as e:
                print(f"{C.RED}[!] Network error: {e.reason}{C.NC}")
                write_log('PACKET', f'Network error :: {repo}')
            except Exception as e:
                print(f"{C.RED}[!] Error: {e}{C.NC}")
                write_log('PACKET', f'Error :: {e}')

            if not auto_refresh:
                break
            countdown(REFRESH_SECS)

    except KeyboardInterrupt:
        print(f"\n{C.YLW}[*] Auto-refresh stopped.{C.NC}")
        write_log('PACKET', 'Auto-refresh terminated by user')

    print(f"\n{C.DIM}Press Enter to return...{C.NC}")
    input()
EOF_PKT

# ── modules/syslog_mod.py ────────────────────────────────────
cat << 'EOF_LOG' > "$BASE/modules/syslog_mod.py"
#!/usr/bin/env python3
# MODULE: SYSTEM LOG VIEWER

import os
import time

class C:
    RED  = '\033[1;31m'
    GRN  = '\033[1;32m'
    CYN  = '\033[1;36m'
    YLW  = '\033[1;33m'
    DIM  = '\033[2;37m'
    NC   = '\033[0m'

TAG_COLORS = {
    'MENU':       C.DIM,
    'COMPLIANCE': C.GRN,
    'RAWTX':      C.YLW,
    'PACKET':     C.CYN,
    'SYS_INIT':   C.RED,
}

def colorize_line(line: str) -> str:
    for tag, color in TAG_COLORS.items():
        if f'[{tag}]' in line:
            return f"{color}{line.rstrip()}{C.NC}"
    return f"{C.DIM}{line.rstrip()}{C.NC}"

def run(log_dir: str, write_log):
    log_path = os.path.join(log_dir, 'system.log')

    while True:
        os.system('clear')
        print(f"\033[1;31m╔══════════════════════════════════════════╗")
        print(f"║  SYSTEM LOG :: EVENT MONITOR             ║")
        print(f"╚══════════════════════════════════════════╝\033[0m\n")

        print(f"  {C.RED}[1]{C.NC}  View log (last 40 lines)")
        print(f"  {C.RED}[2]{C.NC}  Tail log (live, Ctrl+C to stop)")
        print(f"  {C.RED}[3]{C.NC}  Clear log")
        print(f"  {C.DIM}[q]{C.NC}  Back to main menu\n")

        try:
            choice = input(f"{C.CYN}SYSLOG::# {C.NC}").strip().lower()
        except (EOFError, KeyboardInterrupt):
            break

        if choice == '1':
            if not os.path.exists(log_path):
                print(f"{C.YLW}[!] No log file found.{C.NC}")
            else:
                with open(log_path, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                tail = lines[-40:] if len(lines) > 40 else lines
                os.system('clear')
                print(f"{C.CYN}── SYSTEM LOG ({len(lines)} total lines) ──{C.NC}\n")
                for line in tail:
                    print(colorize_line(line))
            print(f"\n{C.DIM}Press Enter to continue...{C.NC}")
            input()

        elif choice == '2':
            if not os.path.exists(log_path):
                print(f"{C.YLW}[!] No log file found. Start other modules first.{C.NC}")
                time.sleep(1.5)
                continue
            print(f"{C.CYN}[*] Tailing log... (Ctrl+C to stop){C.NC}\n")
            try:
                with open(log_path, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    for line in lines[-20:]:
                        print(colorize_line(line))
                    while True:
                        line = f.readline()
                        if line:
                            print(colorize_line(line), end='', flush=True)
                        else:
                            time.sleep(0.5)
            except KeyboardInterrupt:
                print(f"\n{C.YLW}[*] Tail stopped.{C.NC}")
                time.sleep(0.5)

        elif choice == '3':
            confirm = input(f"{C.RED}[!] Clear ALL logs? [yes/N] > {C.NC}").strip().lower()
            if confirm == 'yes':
                with open(log_path, 'w', encoding='utf-8') as f:
                    f.write('')
                write_log('SYSLOG', 'Log cleared by user')
                print(f"{C.GRN}[OK] Log cleared.{C.NC}")
            else:
                print(f"{C.DIM}[--] Cancelled.{C.NC}")
            time.sleep(1)

        elif choice == 'q':
            break
        else:
            print(f"{C.YLW}[?] Invalid option{C.NC}")
            time.sleep(0.6)
EOF_LOG

# ── パーミッション設定 ────────────────────────────────────────
chmod +x "$BASE/start.sh"

echo ""
echo "[OK] Install complete!"
echo "     cd ~/LuciFeR0x0systeM && sh start.sh"
