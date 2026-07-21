#!/bin/sh
# ============================================================
# LuciFeR0x0systeM :: BOOT SEQUENCE
# iSH / Alpine Linux / POSIX sh
# ============================================================

RED='\033[1;31m'
GRN='\033[1;32m'
CYN='\033[1;36m'
YLW='\033[1;33m'
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

# Python3チェック
if ! command -v python3 >/dev/null 2>&1; then
    printf "${RED}[!] python3 not found. Run: apk add python3${NC}\n"
    exit 1
fi

python3 "$(dirname "$0")/main.py"
