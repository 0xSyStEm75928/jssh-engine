# ChaosOS Extension Pack for jssh

> Stealth OS — Kernel Chaos Detection Engine  
> XNU × Linux runtime conflict detection & mitigation via JSON-driven SSH automation

Based on the [Gitcoin submission](https://github.com/gitcoinco/gitcoin_co_30/issues/460) by [@0xSyStEm75928](https://github.com/0xSyStEm75928)

---

## What is ChaosOS?

A unified JSON schema and detection engine for XNU vs Linux kernel conflicts.  
When macOS (XNU microkernel) and Linux coexist in the same environment — iSH, UTM, Docker on Apple Silicon, WSL — chaos happens at the kernel boundary.

ChaosOS **detects, classifies, and routes** those conflicts.  
jssh **executes the detection pipelines** across any number of hosts via SSH.

---

## Payloads

| # | File | Layer | Description |
|---|---|---|---|
| 01 | `01_kernel-trigger-scan.json` | Layer 1 | XNU/Linux conflict detection |
| 02 | `02_system-state-dump.json` | Layer 2 | Raw kernel & filesystem snapshot |
| 03 | `03_chaos-analysis.json` | Layer 3 | Stability scoring & conflict classification |
| 04 | `04_chaos-routing.json` | Layer 4 | Mitigation routing & mode selection |
| 05 | `05_full-chaos-pipeline.json` | All | Full 4-layer pipeline in one run |

---

## Usage

```bash
# Single layer
node index.js chaos-pack/01_kernel-trigger-scan.json

# Full pipeline
node index.js chaos-pack/05_full-chaos-pipeline.json
```

---

## Chaos Modes

| Mode | Description |
|---|---|
| `SILENT_CHAOS_MODE` | Log only. No intervention. |
| `AGGRESSIVE_KERNEL_PANIC_MODE` | Force panic to reset conflict state. |
| `BEAUTIFUL_UI_WITH_CORRUPT_FILESYSTEM` | Let it burn. Aesthetically. |

---

## Purchase

**ChaosOS Extension Pack — $49**  
→ [lucifer0x0system.pages.dev](https://lucifer0x0system.pages.dev)

EVM / ETH / USDT / MATIC accepted. No KYC.
