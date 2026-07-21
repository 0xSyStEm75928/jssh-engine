import { createContext, useContext, useState, useCallback, ReactNode } from "react";

export type LogEntry = {
  id: string;
  timestamp: string;
  action: string;
  result: string;
  type: "info" | "success" | "warning" | "error";
};

type LogContextType = {
  logs: LogEntry[];
  addLog: (action: string, result: string, type?: LogEntry["type"]) => void;
  clearLogs: () => void;
};

const LogContext = createContext<LogContextType | undefined>(undefined);

export function LogProvider({ children }: { children: ReactNode }) {
  const [logs, setLogs] = useState<LogEntry[]>([]);

  const addLog = useCallback((action: string, result: string, type: LogEntry["type"] = "info") => {
    const now = new Date();
    const timestamp = `${now.getHours().toString().padStart(2, "0")}:${now
      .getMinutes()
      .toString()
      .padStart(2, "0")}:${now.getSeconds().toString().padStart(2, "0")}`;

    const newLog: LogEntry = {
      id: Math.random().toString(36).substring(2, 9),
      timestamp,
      action,
      result,
      type,
    };

    setLogs((prev) => [...prev, newLog]);
  }, []);

  const clearLogs = useCallback(() => setLogs([]), []);

  return (
    <LogContext.Provider value={{ logs, addLog, clearLogs }}>
      {children}
    </LogContext.Provider>
  );
}

export function useSystemLog() {
  const context = useContext(LogContext);
  if (!context) {
    throw new Error("useSystemLog must be used within a LogProvider");
  }
  return context;
}
