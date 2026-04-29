import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Palette, Moon, Sun, Briefcase, ExternalLink } from 'lucide-react';
import { Logo } from './Logo';
import './Navbar.css';

const SKINS = [
  { id: 'default', label: 'Ocean',  color: '#00B4D8' },
  { id: 'sunset',  label: 'Sunset', color: '#F4845F' },
  { id: 'forest',  label: 'Forest', color: '#06D6A0' },
  { id: 'violet',  label: 'Violet', color: '#7b2ff7' },
];

function Navbar({ theme, onToggleTheme, skin, onChangeSkin }) {
  const [skinOpen, setSkinOpen] = useState(false);

  return (
    <nav className="navbar">
      <div className="navbar-inner">
        {/* Brand */}
        <motion.a 
          href="/" 
          className="brand" 
          aria-label="BalanceWave home"
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
        >
          <Logo size={32} className="brand-logo" />
          <span className="brand-text">BalanceWave</span>
        </motion.a>

        {/* Right-side controls */}
        <div className="nav-right">
          {/* Portfolio link */}
          <motion.a
            href="https://farmanullah1.github.io/My-Portfolio/"
            target="_blank"
            rel="noopener noreferrer"
            className="portfolio-link"
            title="Farmanullah's Portfolio"
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1 }}
            whileHover={{ y: -2, scale: 1.05 }}
          >
            <Briefcase size={16} />
            <span className="port-text">Portfolio</span>
            <ExternalLink size={12} className="ext-icon" />
          </motion.a>

          <div className="v-divider" />

          {/* Skin picker */}
          <div className="skin-wrap">
            <motion.button
              className="skin-toggle"
              onClick={() => setSkinOpen(o => !o)}
              title="Change color theme"
              aria-expanded={skinOpen}
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.9 }}
            >
              <Palette size={18} />
            </motion.button>
            
            <AnimatePresence>
              {skinOpen && (
                <motion.div 
                  className="skin-panel" 
                  role="menu"
                  initial={{ opacity: 0, scale: 0.8, y: 10 }}
                  animate={{ opacity: 1, scale: 1, y: 0 }}
                  exit={{ opacity: 0, scale: 0.8, y: 10 }}
                >
                  {SKINS.map(s => (
                    <motion.button
                      key={s.id}
                      className={`skin-dot ${skin === s.id ? 'active' : ''}`}
                      style={{ background: s.color }}
                      onClick={() => { onChangeSkin(s.id); setSkinOpen(false); }}
                      title={s.label}
                      aria-label={`${s.label} skin`}
                      whileHover={{ scale: 1.25 }}
                      whileTap={{ scale: 0.9 }}
                    />
                  ))}
                </motion.div>
              )}
            </AnimatePresence>
          </div>

          {/* Dark mode toggle */}
          <motion.button
            className="theme-btn"
            onClick={onToggleTheme}
            title={`Switch to ${theme === 'dark' ? 'light' : 'dark'} mode`}
            aria-label="Toggle theme"
            whileHover={{ scale: 1.1, rotate: theme === 'dark' ? 180 : 0 }}
            whileTap={{ scale: 0.9 }}
          >
            {theme === 'dark' ? <Sun size={18} /> : <Moon size={18} />}
          </motion.button>
        </div>
      </div>
    </nav>
  );
}

export default Navbar;
