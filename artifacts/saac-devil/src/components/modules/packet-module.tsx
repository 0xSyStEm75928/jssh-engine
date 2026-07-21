import React, { useState, useEffect, useCallback } from "react";
import { useSystemLog } from "@/hooks/use-system-log";

type Commit = {
  sha: string;
  commit: {
    message: string;
  };
};

export function PacketModule() {
  const [commits, setCommits] = useState<Commit[]>([]);
  const [loading, setLoading] = useState(false);
  const [lastRefreshed, setLastRefreshed] = useState<Date>(new Date());
  const [countdown, setCountdown] = useState(30);
  const { addLog } = useSystemLog();

  const fetchCommits = useCallback(async (isManual = false) => {
    setLoading(true);
    if (isManual) addLog("PACKET_INJECT", "Manual override: fetching payload", "warning");

    try {
      const res = await fetch(
        "https://api.github.com/repos/gitcoinco/gitcoin_co_30/commits?per_page=3"
      );
      if (!res.ok) throw new Error(`HTTP error ${res.status}`);
      const data = await res.json();
      setCommits(data);
      setLastRefreshed(new Date());
      setCountdown(30);
      if (isManual) addLog("PACKET_INJECT", "Payload received successfully", "success");
    } catch (err) {
      addLog("PACKET_INJECT", "Failed to fetch remote payload", "error");
    } finally {
      setLoading(false);
    }
  }, [addLog]);

  useEffect(() => {
    fetchCommits();
    const interval = setInterval(() => fetchCommits(false), 30000);
    return () => clearInterval(interval);
  }, [fetchCommits]);

  useEffect(() => {
    const tick = setInterval(() => {
      setCountdown((prev) => (prev <= 1 ? 30 : prev - 1));
    }, 1000);
    return () => clearInterval(tick);
  }, [lastRefreshed]);

  return (
    <div className="panel-container p-4 flex flex-col h-full relative group">
      <div className="absolute top-0 right-0 p-2 opacity-50 group-hover:opacity-100 transition-opacity">
        <span className="text-xs text-muted-foreground border border-muted-foreground px-1">MOD_04</span>
      </div>
      <h2 className="text-accent font-bold text-lg mb-1 glitch-hover">PACKET INJECTION</h2>
      <div className="flex justify-between items-center mb-4">
        <p className="text-xs text-muted-foreground uppercase">Monitoring Logs</p>
        <span className="text-[10px] text-primary/50">T-{countdown}s</span>
      </div>

      <div className="flex-1 overflow-hidden flex flex-col bg-input/30 p-2 border border-border/20">
        {loading && commits.length === 0 ? (
          <div className="flex-1 flex items-center justify-center text-primary animate-pulse text-sm">
            INTERCEPTING PACKETS...
          </div>
        ) : (
          <div className="space-y-2 overflow-y-auto">
            {commits.map((c) => (
              <div key={c.sha} className="text-xs border-b border-border/20 pb-2 last:border-0">
                <span className="text-destructive font-bold">[{c.sha.slice(0, 7)}]</span>
                <span className="text-foreground ml-2 line-clamp-2" title={c.commit.message}>
                  {c.commit.message}
                </span>
              </div>
            ))}
          </div>
        )}
      </div>

      <button
        onClick={() => fetchCommits(true)}
        disabled={loading}
        className="glass-btn danger mt-4 py-2 px-4 w-full font-bold tracking-widest disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {loading ? "INJECTING..." : "INJECT / REFRESH"}
      </button>
    </div>
  );
}
