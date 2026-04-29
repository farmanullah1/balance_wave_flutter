import React, { useState, useEffect } from 'react';
import Navbar from './components/Navbar';
import HeroCard from './components/HeroCard';
import CalculatorForm from './components/CalculatorForm';
import ResultCard from './components/ResultCard';
import Footer from './components/Footer';
import './App.css';

const MAX_HISTORY = 8;

function formatTime(ts) {
  const d = new Date(ts);
  return d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}

function App() {
  /* ── Theme & Skin (persisted) ── */
  const [theme, setTheme] = useState(() => localStorage.getItem('bw-theme') || 'light');
  const [skin,  setSkin]  = useState(() => localStorage.getItem('bw-skin')  || 'default');

  /* ── Calculation result & history ── */
  const [result,  setResult]  = useState(null);
  const [history, setHistory] = useState(() => {
    try { return JSON.parse(localStorage.getItem('bw-history')) || []; }
    catch { return []; }
  });

  /* Apply theme & skin to <html> */
  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('bw-theme', theme);
  }, [theme]);

  useEffect(() => {
    document.documentElement.setAttribute('data-skin', skin === 'default' ? '' : skin);
    localStorage.setItem('bw-skin', skin);
  }, [skin]);

  const toggleTheme = () => {
    setTheme(p => p === 'dark' ? 'light' : 'dark');
    if (navigator.vibrate) navigator.vibrate(20);
  };

  /* ── Handle calculation ── */
  const handleCalculate = (data) => {
    setResult(data);

    // Push to history
    const entry = {
      id:      Date.now(),
      ts:      Date.now(),
      carrier: data.carrier,
      amount:  data.amount,
      tax:     data.tax,
      net:     data.net,
      mode:    data.mode,
    };
    setHistory(prev => {
      const next = [entry, ...prev].slice(0, MAX_HISTORY);
      localStorage.setItem('bw-history', JSON.stringify(next));
      return next;
    });
  };

  const clearHistory = () => {
    setHistory([]);
    localStorage.removeItem('bw-history');
  };

  return (
    <div className="app">
      {/* Ambient blobs */}
      <div className="blob blob-a" />
      <div className="blob blob-b" />

      {/* Animated wave ribbon */}
      <div className="wave-ribbon" aria-hidden="true">
        <svg viewBox="0 0 1440 80" preserveAspectRatio="none" fill="none">
          <path
            d="M0,40 C180,80 360,0 540,40 C720,80 900,0 1080,40 C1260,80 1440,0 1440,40
               C1620,80 1800,0 1980,40 C2160,80 2340,0 2520,40 C2700,80 2880,0 2880,40 L2880,80 L0,80 Z"
            fill="var(--accent)"
          />
        </svg>
      </div>

      <Navbar
        theme={theme}
        onToggleTheme={toggleTheme}
        skin={skin}
        onChangeSkin={setSkin}
      />

      <main className="page">
        <HeroCard />

        <div className="grid">
          <CalculatorForm onCalculate={handleCalculate} />
          <ResultCard result={result} />
        </div>

        {/* Calculation history */}
        {history.length > 0 && (
          <section className="history-section">
            <div className="history-header">
              <span className="history-title">Recent Calculations</span>
              <button className="clear-btn" onClick={clearHistory}>Clear history</button>
            </div>
            <div className="history-list">
              {history.map(item => (
                <div className="history-item glass-card" key={item.id} style={{ padding: '0.8rem 1.2rem' }}>
                  <div className="history-left">
                    <span className="history-carrier">
                      {item.mode === 'reverse' ? '🎯 Reverse' : '⚡ Forward'} · {item.carrier}
                    </span>
                    <span className="history-amt">
                      Rs. {item.amount.toFixed(2)} recharged
                    </span>
                    <span className="history-time">{formatTime(item.ts)}</span>
                  </div>
                  <span className="history-net">Rs. {item.net.toFixed(2)}</span>
                </div>
              ))}
            </div>
          </section>
        )}
      </main>
      <Footer />
    </div>
  );
}

export default App;
