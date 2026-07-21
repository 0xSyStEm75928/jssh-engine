# jssh — JSON-driven SSH Automation Engine

![](https://img.shields.io/badge/jssh-v1.0-FFD700?style=flat-square)
![](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20iOS-FFD700?style=flat-square)
![](https://img.shields.io/badge/runtime-Node.js%20ESM-FFD700?style=flat-square)
![](https://img.shields.io/badge/license-MIT-FFD700?style=flat-square)
![](https://img.shields.io/badge/ChaosOS-extension%20pack-FFD700?style=flat-square)
![](https://img.shields.io/badge/iSH-iOS%20ready-FFD700?style=flat-square)

Run multi-server SSH workflows from a single JSON file.  
DAG execution · parallel groups · jump host · variable interpolation · retry control.

```bash
node index.js payload.json
```

---

## Why jssh?

Most SSH automation tools require you to learn a DSL (Ansible YAML, Fabric Python, etc.).  
jssh uses **plain JSON** — no new syntax, runs anywhere Node.js runs, including **iSH on iOS**.

---

## Features

| Feature | Description |
|---|---|
| **DAG execution** | `depends_on` + topological sort. Circular deps detected at load time. |
| **Parallel groups** | `parallel_group: "name"` runs steps concurrently |
| **Jump host** | Bastion tunneling via `ssh2` `direct-tcpip` |
| **Variable interpolation** | `{{VAR}}` expanded across all fields |
| **on_failure control** | `abort` / `continue` / `retry` per step |
| **Result saving** | `output.save_result: true` captures stdout to next step |

---

## Quickstart

```bash
git clone https://github.com/YOUR_GITHUB/jssh-engine
cd jssh-engine
npm install
node index.js demo-pack/01_multi-version-check.json
```

---

## Payload structure

```json
{
  "name": "Deploy Nginx",
  "variables": { "HOST": "192.168.1.100" },
  "connection_settings": {
    "host": "{{HOST}}", "port": 22,
    "username": "root", "privateKeyPath": "~/.ssh/id_rsa"
  },
  "jump_host": { "enabled": false },
  "execution_sequence": [
    {
      "step_id": 1, "name": "Install Nginx",
      "command": "apt-get install -y nginx",
      "depends_on": [], "on_failure": "abort"
    },
    {
      "step_id": 2, "name": "Start Nginx",
      "command": "systemctl enable --now nginx",
      "depends_on": [1], "on_failure": "continue"
    }
  ]
}
```

---

## Demo Pack (7 payloads)

| # | Payload | Description |
|---|---|---|
| 01 | multi-version-check | Parallel version check across languages |
| 02 | nginx-auto-deploy | Full Nginx install + config |
| 03 | git-deploy | git pull → process restart |
| 04 | docker-compose-stack | Docker Compose stack up |
| 05 | ish-alpine-setup | iSH / Alpine Linux initial setup |
| 06 | jump-host-multi | Multi-server via bastion |
| 07 | btcpay-server-deploy | BTCPay Server full deploy |

---

## File structure

```
jssh-engine/
├── index.js        Entry point · banner · summary output
├── dag.js          Topological sort · cycle detection (Kahn's algorithm)
├── interpolate.js  {{variable}} interpolation engine
├── ssh.js          ssh2 wrapper · jump_host tunnel · command exec
├── runner.js       on_failure / retry / parallel batch execution
├── demo-pack/      7 ready-to-run payloads
└── package.json
```

---

## Demo Pack — $29

Full demo-pack with all 7 payloads + inline documentation:  
**[lucifer0x0system.pages.dev](https://lucifer0x0system.pages.dev)**

EVM / ETH / USDT / MATIC accepted. No KYC.

---

## License

MIT — engine is free. Demo Pack is paid.
