#!/usr/bin/env python3
# ============================================================
# MODULE: SYSTEM LOG VIEWER
# ============================================================

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
        print(f"{C.RED}╔══════════════════════════════════════════╗")
        print(f"║  SYSTEM LOG :: EVENT MONITOR             ║")
        print(f"╚══════════════════════════════════════════╝{C.NC}\n")

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
                    # 最後50行まで先出し
                    lines = f.readlines()
                    for line in lines[-20:]:
                        print(colorize_line(line))
                    # 以降リアルタイム追従
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
