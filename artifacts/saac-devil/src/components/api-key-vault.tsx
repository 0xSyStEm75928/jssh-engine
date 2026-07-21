import React, { useState, useEffect } from "react";
import { useSystemLog } from "@/hooks/use-system-log";
import { Copy, RefreshCw } from "lucide-react";

const generateKey = (prefix: string) => {
  return `${prefix}_${Math.random().toString(36).substring(2, 15)}${Math.random().toString(36).substring(2, 15)}`;
};

export function ApiKeyVault() {
  const { addLog } = useSystemLog();
  const [dayKey, setDayKey] = useState("");
  const [nightKey, setNightKey] = useState("");

  useEffect(() => {
    const d = localStorage.getItem("devil_day_key") || "";
    const n = localStorage.getItem("devil_night_key") || "";
    setDayKey(d);
    setNightKey(n);
  }, []);

  const saveKey = (type: "day" | "night", val: string) => {
    const storageKey = type === "day" ? "devil_day_key" : "devil_night_key";
    localStorage.setItem(storageKey, val);
    if (type === "day") setDayKey(val);
    else setNightKey(val);
  };

  const regenKey = (type: "day" | "night") => {
    const newKey = generateKey(type === "day" ? "DEVIL_DAY" : "DEVIL_NGT");
    saveKey(type, newKey);
    addLog("KEY_VAULT", `Regenerated ${type.toUpperCase()} cryptographic key`, "warning");
  };

  const copyKey = (type: "day" | "night", val: string) => {
    if (!val) return;
    navigator.clipboard.writeText(val);
    addLog("KEY_VAULT", `Copied ${type.toUpperCase()} key to clipboard`, "info");
  };

  const KeyRow = ({ type, val }: { type: "day" | "night"; val: string }) => (
    <div className="flex items-center space-x-2">
      <div className="w-20 text-xs font-bold text-label uppercase text-right shrink-0">
        {type} MODE
      </div>
      <div className="flex-1 relative">
        <input
          type="password"
          value={val}
          readOnly
          placeholder="UNSET"
          className="w-full bg-input border border-border text-foreground text-sm p-2 font-mono focus:outline-none pr-24"
        />
        <div className="absolute right-2 top-2 flex items-center space-x-2">
          {val && (
            <span className="text-[10px] text-primary bg-primary/10 px-1 border border-primary/30 flex items-center">
              AUTH
            </span>
          )}
          <button
            onClick={() => copyKey(type, val)}
            className="text-muted-foreground hover:text-primary transition-colors"
          >
            <Copy size={14} />
          </button>
          <button
            onClick={() => regenKey(type)}
            className="text-muted-foreground hover:text-destructive transition-colors"
          >
            <RefreshCw size={14} />
          </button>
        </div>
      </div>
    </div>
  );

  return (
    <div className="panel-container p-4 mt-4 relative">
      <h2 className="text-destructive font-bold text-lg mb-4 flex items-center space-x-2">
        <span>API KEY VAULT</span>
        <span className="text-sm text-muted-foreground">// BUSINESS CREDENTIALS</span>
      </h2>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <KeyRow type="day" val={dayKey} />
        <KeyRow type="night" val={nightKey} />
      </div>
    </div>
  );
}
