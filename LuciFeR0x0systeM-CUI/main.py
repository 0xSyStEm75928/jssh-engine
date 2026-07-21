#!/usr/bin/env python3
# ============================================================
# LuciFeR0x0systeM :: MAIN CONTROL HUB
# iSH / Alpine Linux / Python3 stdlib only
# ============================================================

import os
import sys
import time
from datetime import datetime

# ANSI カラー定義
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
