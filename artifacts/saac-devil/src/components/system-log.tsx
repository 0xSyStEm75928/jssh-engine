import React, { useEffect, useRef } from "react";
import { useSystemLog } from "@/hooks/use-system-log";

export function SystemLog() {
  const { logs } = useSystemLog();
  const bottomRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [logs]);

  const getColor = (type: string) => {
    switch (type) {
      case "error": return "text-destructive";
      case "warning": return "text-label";
      case "success": return "text-primary";
      default: return "text-foreground";
    }
  };

  return (
    <div className="panel-container flex flex-col h-48 mt-4 border-t-2 border-t-destructive">
      <div className="bg-destructive/20 border-b border-destructive px-4 py-1 flex justify-between items-center">
        <span className="text-xs font-bold text-destructive tracking-widest uppercase">SYSTEM LOG</span>
        <span className="text-[10px] text-destructive/70 animate-pulse">REC_ACTIVE</span>
      </div>
      
      <div className="flex-1 overflow-y-auto p-4 space-y-1 font-mono text-xs">
        {logs.length === 0 ? (
          <div className="text-muted-foreground italic opacity-50">Waiting for system events...</div>
        ) : (
          logs.map((log) => (
            <div key={log.id} className="flex space-x-3">
              <span className="text-muted-foreground shrink-0">[{log.timestamp}]</span>
              <span className="text-accent shrink-0 w-32 truncate">{log.action}</span>
              <span className="text-muted-foreground shrink-0">::</span>
              <span className={`\${getColor(log.type)} break-all`}>{log.result}</span>
            </div>
          ))
        )}
        <div ref={bottomRef} />
      </div>
    </div>
  );
}
