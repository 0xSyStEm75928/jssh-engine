import React, { useState, useEffect } from "react";
import { motion } from "framer-motion";
import { useLocation } from "wouter";

const ASCII_LOGO = `
   _____             _____   ____             _ __
  / ___/____ _____  / ___/  / __ \\___   _   _(_) /
  \\__ \\/ __ \`/ __ \`/ /__   / / / / _ \\ | | / / /
 ___/ / /_/ / /_/ / /___  / /_/ /  __/ |/ / / /
/____/\\__,_/\\__,_/\\___/  /_____/\\___/|___/_/_/

     E N T E R P R I S E   I N T E R F A C E
`;

const BOOT_SEQUENCE = [
  { text: "INITIALIZING DARWIN RECONSTRUCT...", delay: 500 },
  { text: "DEPTH_COLLAPSE: 0x999", delay: 1000 },
  { text: "SECURE_KERNEL_EMULATION: ACTIVE", delay: 1500 },
  { text: "LOADING DEVIL_LOGIC MODULES...", delay: 2000 },
  { text: "INJECTING POLYMORPHIC PROTOCOLS...", delay: 2800 },
  { text: "MOUNTING /dev/null/sanity...", delay: 3200 },
  { text: "SYSTEM VERIFIED. NO SAFETY GUARANTEES.", delay: 3800 },
];

export default function BootScreen() {
  const [, setLocation] = useLocation();
  const [lines, setLines] = useState<string[]>([]);
  const [showPrompt, setShowPrompt] = useState(false);
  const [glitchingOut, setGlitchingOut] = useState(false);

  useEffect(() => {
    const timeouts: ReturnType<typeof setTimeout>[] = [];

    BOOT_SEQUENCE.forEach((item, index) => {
      const t = setTimeout(() => {
        setLines((prev) => [...prev, item.text]);
        if (index === BOOT_SEQUENCE.length - 1) {
          setTimeout(() => setShowPrompt(true), 500);
        }
      }, item.delay);
      timeouts.push(t);
    });

    return () => timeouts.forEach(clearTimeout);
  }, []);

  useEffect(() => {
    const handleKeyPress = () => {
      if (!showPrompt || glitchingOut) return;
      setGlitchingOut(true);
      setTimeout(() => {
        setLocation("/dashboard");
      }, 400);
    };

    window.addEventListener("keydown", handleKeyPress);
    window.addEventListener("click", handleKeyPress);
    return () => {
      window.removeEventListener("keydown", handleKeyPress);
      window.removeEventListener("click", handleKeyPress);
    };
  }, [showPrompt, glitchingOut, setLocation]);

  const ts = new Date().toISOString().split("T")[1].slice(0, 8);

  return (
    <motion.div
      className={`min-h-screen w-full flex flex-col justify-center items-center bg-black p-4 ${glitchingOut ? "ambient-glitch" : ""}`}
      initial={{ opacity: 0 }}
      animate={{
        opacity: 1,
        filter: glitchingOut ? "invert(1) hue-rotate(180deg)" : "none",
        scale: glitchingOut ? 1.05 : 1,
      }}
      transition={{ duration: 0.2 }}
    >
      <div className="max-w-4xl w-full">
        <motion.pre
          className="text-destructive font-bold text-xs sm:text-sm md:text-base leading-tight mb-8 text-glow"
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
        >
          {ASCII_LOGO}
        </motion.pre>

        <div className="space-y-2 mb-12 min-h-[200px]">
          {lines.map((line, i) => (
            <motion.div
              key={i}
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              className="text-foreground text-sm md:text-base tracking-wider"
            >
              <span className="text-muted-foreground mr-2">[{ts}]</span>
              {line}
            </motion.div>
          ))}
        </div>

        {showPrompt && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: [0, 1, 0] }}
            transition={{ repeat: Infinity, duration: 1.5, ease: "linear" }}
            className="text-center mt-12"
          >
            <span className="text-accent text-xl md:text-2xl font-bold tracking-widest uppercase">
              KERNEL READY — PRESS ANY KEY
            </span>
          </motion.div>
        )}
      </div>
    </motion.div>
  );
}
