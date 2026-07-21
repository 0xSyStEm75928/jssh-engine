import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { Route, Switch, Router as WouterRouter } from 'wouter';
import { ThemeProvider } from '@/components/theme-provider';
import { LogProvider } from '@/hooks/use-system-log';
import BootScreen from '@/pages/boot';
import Dashboard from '@/pages/dashboard';

const queryClient = new QueryClient();

function NotFound() {
  return (
    <div className="min-h-screen w-full flex items-center justify-center bg-background text-foreground">
      <div className="text-center panel-container p-8">
        <h1 className="text-4xl font-bold text-destructive glitch-hover mb-4">
          ERR_404
        </h1>
        <p className="text-sm text-muted-foreground uppercase tracking-widest">
          Sector not found in memory core.
        </p>
        <a href="/" className="mt-8 inline-block glass-btn px-4 py-2 text-sm">
          REBOOT SYSTEM
        </a>
      </div>
    </div>
  );
}

function Router() {
  return (
    <Switch>
      <Route path="/" component={BootScreen} />
      <Route path="/dashboard" component={Dashboard} />
      <Route component={NotFound} />
    </Switch>
  );
}

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider defaultTheme="dark" storageKey="saac-devil-theme">
        <LogProvider>
          <WouterRouter base={import.meta.env.BASE_URL.replace(/\/$/, '')}>
            <Router />
          </WouterRouter>
        </LogProvider>
      </ThemeProvider>
    </QueryClientProvider>
  );
}

export default App;
