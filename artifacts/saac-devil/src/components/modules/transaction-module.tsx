import React, { useState, useEffect } from "react";
import { useSystemLog } from "@/hooks/use-system-log";

const generateHex = (len: number) => {
  const chars = "0123456789abcdef";
  let result = "";
  for (let i = 0; i < len; i++) result += chars[Math.floor(Math.random() * chars.length)];
  return result;
};

export function TransactionModule() {
  const [txId, setTxId] = useState("");
  const [target, setTarget] = useState("LOCAL_ENV");
  const [generating, setGenerating] = useState(false);
  const [rawTx, setRawTx] = useState("");
  const { addLog } = useSystemLog();

  useEffect(() => {
    setTxId(`0x${generateHex(16)}`);
  }, []);

  const generateTx = () => {
    setGenerating(true);
    setRawTx("");
    addLog("TX_GEN", `Preparing payload for ${target}`, "warning");

    let count = 0;
    const interval = setInterval(() => {
      setRawTx((prev) => prev + generateHex(8) + " ");
      count++;
      if (count > 8) {
        clearInterval(interval);
        setGenerating(false);
        setTxId(`0x${generateHex(16)}`);
        addLog("TX_GEN", "Raw transaction data successfully computed", "success");
      }
    }, 150);
  };

  return (
    <div className="panel-container p-4 flex flex-col h-full relative group">
      <div className="absolute top-0 right-0 p-2 opacity-50 group-hover:opacity-100 transition-opacity">
        <span className="text-xs text-muted-foreground border border-muted-foreground px-1">MOD_02</span>
      </div>
      <h2 className="text-accent font-bold text-lg mb-1 glitch-hover">RAW TX GENERATOR</h2>
      <p className="text-xs text-muted-foreground mb-4 uppercase">Broadcast Preparation</p>

      <div className="flex-1 space-y-3">
        <div>
          <label className="text-xs text-label uppercase block mb-1">Transaction ID</label>
          <input
            type="text"
            readOnly
            value={txId}
            className="w-full bg-input border border-border/50 text-muted-foreground text-sm p-1 font-mono focus:outline-none"
          />
        </div>

        <div>
          <label className="text-xs text-label uppercase block mb-1">Target Node</label>
          <select
            value={target}
            onChange={(e) => {
              setTarget(e.target.value);
              addLog("TX_TARGET", `Changed to ${e.target.value}`);
            }}
            className="w-full bg-input border border-border text-foreground text-sm p-1 font-mono focus:outline-none focus:border-primary appearance-none cursor-pointer"
          >
            <option value="LOCAL_ENV">LOCAL_ENV</option>
            <option value="STAGING">STAGING</option>
            <option value="PRODUCTION">PRODUCTION</option>
          </select>
        </div>

        <div className="text-xs text-primary/80 h-10 overflow-hidden font-mono mt-2 break-all">
          {rawTx || "Ready to create non-malleable cryptographic contract transaction."}
        </div>
      </div>

      <button
        onClick={generateTx}
        disabled={generating}
        className="glass-btn mt-4 py-2 px-4 w-full font-bold tracking-widest disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {generating ? "COMPUTING..." : "GENERATE TX"}
      </button>
    </div>
  );
}
