import React from 'react';
import { motion } from 'framer-motion';
import { Briefcase, ArrowUp, Mail, Globe, Code } from 'lucide-react';
import { Logo } from './Logo';

// Custom Brand Icons to avoid build errors with lucide-react brand icons
const Github = ({ size = 20 }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M15 22v-4a4.8 4.8 0 0 0-1-3.5c3 0 6-2 6-5.5.08-1.25-.27-2.48-1-3.5.28-1.15.28-2.35 0-3.5 0 0-1 0-3 1.5-2.64-.5-5.36-.5-8 0C6 2 5 2 5 2c-.3 1.15-.3 2.35 0 3.5A5.403 5.403 0 0 0 4 9c0 3.5 3 5.5 6 5.5-.39.49-.68 1.05-.85 1.65-.17.6-.22 1.23-.15 1.85v4"/><path d="M9 18c-4.51 2-5-2-7-2"/></svg>
);

const Linkedin = ({ size = 20 }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"/><rect width="4" height="12" x="2" y="9"/><circle cx="4" cy="4" r="2"/></svg>
);

const Twitter = ({ size = 20 }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M22 4s-.7 2.1-2 3.4c1.6 10-9.4 17.3-18 11.6 2.2.1 4.4-.6 6-2C3 15.5.5 9.6 3 5c2.2 2.6 5.6 4.1 9 4-.9-4.2 4-6.6 7-3.8 1.1 0 3-1.2 3-1.2z"/></svg>
);
import './Footer.css';

function Footer() {
  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const currentYear = new Date().getFullYear();

  return (
    <footer className="app-footer">
      <div className="footer-inner">
        <div className="footer-grid">
          <motion.div 
            className="footer-brand-col"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
          >
            <div className="f-logo">
              <Logo size={24} className="f-logo-icon" />
              <span className="logo-text">BalanceWave</span>
            </div>
            <p className="f-desc">
              Your smart & reliable mobile balance tax calculator for Pakistan. 
              Built with precision for the 2026 tax regulations.
            </p>
            <div className="social-links">
              <motion.a whileHover={{ y: -3 }} href="https://github.com/farmanullah1" target="_blank" rel="noreferrer" aria-label="GitHub"><Github size={20} /></motion.a>
              <motion.a whileHover={{ y: -3 }} href="https://linkedin.com/in/farmanullah1" target="_blank" rel="noreferrer" aria-label="LinkedIn"><Linkedin size={20} /></motion.a>
              <motion.a whileHover={{ y: -3 }} href="https://twitter.com/farmanullah1" target="_blank" rel="noreferrer" aria-label="Twitter"><Twitter size={20} /></motion.a>
              <motion.a whileHover={{ y: -3 }} href="mailto:contact@farmanullah.com" aria-label="Email"><Mail size={20} /></motion.a>
            </div>
          </motion.div>

          <motion.div 
            className="footer-links-col"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.1 }}
          >
            <h4>Resources</h4>
            <ul>
              <li><a href="https://farmanullah1.github.io/My-Portfolio/" target="_blank" rel="noreferrer"><Briefcase size={14} /> Portfolio</a></li>
              <li><a href="#"><Globe size={14} /> API Docs</a></li>
              <li><a href="#"><Code size={14} /> Open Source</a></li>
            </ul>
          </motion.div>

          <motion.div 
            className="footer-cta-col"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.2 }}
          >
            <button className="back-to-top" onClick={scrollToTop}>
              <ArrowUp size={18} />
              <span>Back to Top</span>
            </button>
          </motion.div>
        </div>

        <div className="footer-bottom">
          <p>&copy; {currentYear} BalanceWave. Designed & Developed by <strong>Farmanullah Ansari</strong>.</p>
          <div className="f-badges">
            <span className="badge">v2.0.0</span>
            <span className="badge">Pakistan 2026</span>
          </div>
        </div>
      </div>
    </footer>
  );
}

export default Footer;
