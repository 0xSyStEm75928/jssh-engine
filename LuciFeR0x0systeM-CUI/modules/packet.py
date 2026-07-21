#!/usr/bin/env python3
# ============================================================
# MODULE: PACKET INJECTION :: GitHub API
# urllib のみ使用（requests 不要）
# ============================================================

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

DEFAULT_REPO  = 'gitcoinco/gitcoin_co_30'
API_BASE      = 'https://api.github.com'
REFRESH_SECS  = 30

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
        sha     = c.get('sha', 'N/A')[:10]
        msg     = c.get('commit', {}).get('message', '').splitlines()[0][:48]
        author  = c.get('commit', {}).get('author', {}).get('name', 'unknown')
        date    = c.get('commit', {}).get('author', {}).get('date', '')[:10]
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
