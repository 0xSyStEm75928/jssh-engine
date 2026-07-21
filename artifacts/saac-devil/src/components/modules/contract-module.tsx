import React, { useState } from "react";
import { useSystemLog } from "@/hooks/use-system-log";

const ARCH_DIAGRAM_NORMAL = `
 [DEVIL_CORE]
      |
      +--[PROXY_ROUTER]
      |       |
      |       +-> [STAGING_ENV]
      |
      +--[MEM_POOL_WATCHER]
`;

const ARCH_DIAGRAM_SYNCING = `
 [DEVIL_CORE]*
      |
      +--[PROXY_ROUTER]*~.
      |       |
      |       +-> [SYNCING...]
      |
      +--[MEM_POOL_WATCHER]
`;

export function ContractModule() {
  const [syncing, setSyncing] = useState(false);
  const { addLog } = useSystemLog();

  const sync = () => {
    setSyncing(true);
    addLog("CONTRACT_SYNC", "Injecting polymorphic interface", "warning");

    setTimeout(() => {
      setSyncing(false);
      addLog("CONTRACT_SYNC", "Polymorphic state adaptation complete", "success");
    }, 2000);
  };

  return (
    <div className="panel-container p-4 flex flex-col h-full relative group">
      <div className="absolute top-0 right-0 p-2 opacity-50 group-hover:opacity-100 transition-opacity">
        <span className="text-xs text-muted-foreground border border-muted-foreground px-1">MOD_03</span>
      </div>
      <h2 className="text-accent font-bold text-lg mb-1 glitch-hover">MUTABLE CONTRACT</h2>
      <p className="text-xs text-muted-foreground mb-4 uppercase">DEVIL_LOGIC Architecture</p>

      <div className="flex-1 flex flex-col">
        <div className="flex items-center space-x-2 mb-2">
          <div className={`w-2 h-2 ${syncing ? "bg-label animate-ping" : "bg-primary"}`} />
          <span className="text-xs uppercase text-foreground">
            Polymorphic State:{" "}
            <span className={syncing ? "text-label" : "text-primary"}>
              {syncing ? "ADAPTING..." : "ACTIVE"}
            </span>
          </span>
        </div>

        <pre className="flex-1 bg-input/50 border border-border/30 p-2 text-xs text-primary overflow-hidden">
          {syncing ? ARCH_DIAGRAM_SYNCING : ARCH_DIAGRAM_NORMAL}
        </pre>
      </div>

      <button
        onClick={sync}
        disabled={syncing}
        className="glass-btn mt-4 py-2 px-4 w-full font-bold tracking-widest disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {syncing ? "SYNCING..." : "SYNC ARCHITECTURE"}
      </button>
    </div>
  );
}
