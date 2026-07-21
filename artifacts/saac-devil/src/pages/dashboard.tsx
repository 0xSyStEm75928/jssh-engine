import React, { useEffect } from "react";
import { useTheme } from "@/components/theme-provider";
import { Sun, Moon } from "lucide-react";
import { ComplianceModule } from "@/components/modules/compliance-module";
import { TransactionModule } from "@/components/modules/transaction-module";
import { ContractModule } from "@/components/modules/contract-module";
import { PacketModule } from "@/components/modules/packet-module";
import { ApiKeyVault } from "@/components/api-key-vault";
import { SystemLog } from "@/components/system-log";
import { useSystemLog } from "@/hooks/use-system-log";
import { motion } from "framer-motion";

export default function Dashboard() {
  const { theme, setTheme } = useTheme();
  const { addLog } = useSystemLog();

  useEffect(() => {
    addLog("SYS_INIT", "Dashboard loaded. User granted ROOT access.", "success");
  // addLog は useCallback で安定しているが、マウント時1回だけで十分
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const toggleTheme = () => {
    const newTheme = theme === "dark" ? "light" : "dark";
    setTheme(newTheme);
    addLog("UI_THEME", `Environment mode switched to ${newTheme.toUpperCase()}`, "info");
  };

  return (
    <div className="min-h-screen p-4 md:p-8 flex flex-col max-w-[1600px] mx-auto">
      {/* HEADER */}
      <header className="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 border-b border-border/50 pb-4">
        <div className="flex items-center space-x-4 mb-4 md:mb-0">
          <h1 className="text-2xl md:text-3xl font-bold text-primary tracking-tighter text-glow flex items-center">
            <span>LuciFeR0x0systeM&gt;&gt;&gt;</span>
            <span className="blinking-cursor"></span>
          </h1>
          <div className="bg-destructive text-destructive-foreground text-[10px] font-bold px-2 py-0.5 border border-destructive shadow-[0_0_10px_rgba(255,0,0,0.5)]">
            [ROOT]
          </div>
        </div>

        <div className="flex items-center space-x-6">
          <div className="text-xs text-muted-foreground text-right hidden sm:block">
            <div>DARWIN RECONSTRUCT</div>
            <div>[Version 2026.07.19]</div>
          </div>

          <button
            onClick={toggleTheme}
            className="panel-container p-2 hover:bg-primary/20 hover:text-primary transition-colors cursor-pointer group"
            title="Toggle Day/Night Mode"
          >
            {theme === "dark" ? (
              <Sun className="w-5 h-5 text-label group-hover:text-primary transition-colors" />
            ) : (
              <Moon className="w-5 h-5 text-accent group-hover:text-primary transition-colors" />
            )}
          </button>
        </div>
      </header>

      {/* MODULES GRID */}
      <motion.div
        className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.1 }}>
          <ComplianceModule />
        </motion.div>
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.2 }}>
          <TransactionModule />
        </motion.div>
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.3 }}>
          <ContractModule />
        </motion.div>
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.4 }}>
          <PacketModule />
        </motion.div>
      </motion.div>

      {/* API VAULT */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.5, duration: 0.5 }}
      >
        <ApiKeyVault />
      </motion.div>

      {/* SYSTEM LOG */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.7, duration: 0.5 }}
      >
        <SystemLog />
      </motion.div>
    </div>
  );
}
