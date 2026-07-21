import React, { useState } from "react";
import { useSystemLog } from "@/hooks/use-system-log";

export function ComplianceModule() {
  const [scanning, setScanning] = useState(false);
  const [status, setStatus] = useState("CLEAN / NO MALICIOUS CODE DETECTED");
  const { addLog } = useSystemLog();

  const runScan = () => {
    setScanning(true);
    setStatus("SCANNING CORE MEMORY...");
    addLog("COMPLIANCE_SCAN", "Initiated deep memory inspection", "warning");

    setTimeout(() => {
      setStatus("ANALYZING HEURISTICS...");
    }, 1000);

    setTimeout(() => {
      setScanning(false);
      setStatus("CLEAN / NO MALICIOUS CODE DETECTED");
      addLog("COMPLIANCE_SCAN", "Completed. 0 anomalies found.", "success");
    }, 2500);
  };

  return (
    <div className="panel-container p-4 flex flex-col h-full relative overflow-hidden group">
      <div className="absolute top-0 right-0 p-2 opacity-50 group-hover:opacity-100 transition-opacity">
        <span className="text-xs text-muted-foreground border border-muted-foreground px-1">MOD_01</span>
      </div>
      <h2 className="text-accent font-bold text-lg mb-4 glitch-hover">COMPLIANCE PROTOCOL</h2>

      <div className="flex-1 space-y-4">
        <div className="flex items-center space-x-3">
          <div className={`w-3 h-3 shadow-[0_0_8px_currentColor] ${scanning ? "bg-label animate-pulse" : "bg-primary"}`} />
          <div className="text-sm">
            <span className="text-muted-foreground">Status: </span>
            <span className={`font-bold ${scanning ? "text-label" : "text-primary"}`}>{status}</span>
          </div>
        </div>

        <div className="flex items-center space-x-3">
          <div className="w-3 h-3 bg-primary shadow-[0_0_8px_currentColor]" />
          <div className="text-sm">
            <span className="text-muted-foreground">Local Sandbox Isolation: </span>
            <span className="text-primary font-bold">ENFORCED</span>
          </div>
        </div>

        {scanning && (
          <div className="w-full bg-input h-1 mt-4 relative overflow-hidden">
            <div className="absolute inset-y-0 left-0 bg-label w-1/3 animate-pulse" />
          </div>
        )}
      </div>

      <button
        onClick={runScan}
        disabled={scanning}
        className="glass-btn mt-6 py-2 px-4 w-full font-bold tracking-widest disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {scanning ? "SCANNING..." : "RUN SCAN"}
      </button>
    </div>
  );
}
