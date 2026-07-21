#!/usr/bin/env python3
# ============================================================
# MODULE: RAW TX GENERATOR
# ============================================================

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
        tx_type  = random.choice(TX_TYPES)
        tx_id    = rand_hex(16)
        nonce    = rand_hex(4)
        payload  = rand_hex(random.randint(16, 64))
        gas      = random.randint(21000, 500000)
        sig_r    = rand_hex(32)
        sig_s    = rand_hex(32)
        sig_v    = random.choice(['1b', '1c'])

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

        write_log('RAWTX', f'TX#{i} id=0x{tx_id[:8]}... type={tx_type} target={target.split()[0]}')
        time.sleep(0.25)

    print(f"{C.GRN}[OK] {count} transaction(s) generated & signed.{C.NC}")
    print(f"{C.DIM}(Broadcast disabled in offline mode){C.NC}\n")
    write_log('RAWTX', f'Batch complete. count={count}')
    print(f"{C.DIM}Press Enter to return...{C.NC}")
    input()
