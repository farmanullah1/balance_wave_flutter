import React, { useState, useEffect } from 'react';
import { Copy, CheckCircle } from 'lucide-react';
import { CarrierLogo } from '../utils/CarrierLogos';
import './ResultCard.css';

/* ── Skeleton ── */
function Skeleton() {
  return (
    <div className="skeleton-wrap">
      <div className="skel" style={{ width: '45%', height: '14px' }} />
      <div className="skel" style={{ width: '68%', height: '52px', marginTop: '10px' }} />
      <div className="skel" style={{ width: '100%', height: '100px', marginTop: '22px' }} />
    </div>
  );
}

/* ── Empty state ── */
function EmptyState() {
  const bars = [14, 26, 38, 26, 14, 20, 32, 20];
  return (
    <div className="empty-state">
      <div className="wave-visual" aria-hidden="true">
        {bars.map((h, i) => (
          <div key={i} className="wv-bar" style={{ height: `${h}px`, animationDelay: `${i*0.1}s` }} />
        ))}
      </div>
      <p>Fill in the form to calculate your net balance</p>
    </div>
  );
}

/* ── Main result display ── */
function ResultDisplay({ result, onCopy, copied }) {
  const isReverse = result.mode === 'reverse';

  return (
    <div className="result-inner fade-in">
      {/* Big number */}
      <p className="net-label">
        {isReverse ? 'Required Recharge Amount' : 'Net Balance After Tax'}
      </p>
      <div className="balance-row">
        <span className="big-balance">
          Rs.&nbsp;{isReverse ? result.amount.toFixed(2) : result.net.toFixed(2)}
        </span>
        <button
          className="copy-btn"
          onClick={onCopy}
          title="Copy to clipboard"
          aria-label="Copy result"
        >
          {copied ? <CheckCircle size={18} className="success-icon" /> : <Copy size={18} />}
        </button>
      </div>
      {copied && <span className="copied-toast">Copied!</span>}

      {/* Breakdown */}
      <div className="breakdown">
        {isReverse ? (
          <>
            <div className="bd-row">
              <span>Desired Net Balance:</span>
              <strong className="bd-val">Rs. {result.net.toFixed(2)}</strong>
            </div>
            <div className="bd-row tax">
              <span>WHT (15% on net):</span>
              <strong className="bd-val">+ Rs. {result.tax.toFixed(2)}</strong>
            </div>
            <hr className="bd-hr" />
            <div className="bd-row total">
              <span>Recharge Needed:</span>
              <strong className="bd-val">Rs. {result.amount.toFixed(2)}</strong>
            </div>
          </>
        ) : (
          <>
            <div className="bd-row">
              <span>Recharge Amount:</span>
              <strong className="bd-val">Rs. {result.amount.toFixed(2)}</strong>
            </div>
            <div className="bd-row tax">
              <span>WHT (15% on net):</span>
              <strong className="bd-val">− Rs. {result.tax.toFixed(2)}</strong>
            </div>
            <hr className="bd-hr" />
            <div className="bd-row total">
              <span>Net Balance:</span>
              <strong className="bd-val">Rs. {result.net.toFixed(2)}</strong>
            </div>
          </>
        )}
        {result.carrier && result.carrier !== 'Unknown' && (
          <div className="bd-row carrier">
            <span>Carrier:</span>
            <strong className="bd-val">
              <CarrierLogo carrier={result.carrier} size={18} /> <span>{result.carrier}</span>
            </strong>
          </div>
        )}
      </div>
    </div>
  );
}

/* ── ResultCard ── */
function ResultCard({ result }) {
  const [showSkeleton,  setShowSkeleton]  = useState(false);
  const [showResult,    setShowResult]    = useState(false);
  const [currentResult, setCurrentResult] = useState(null);
  const [copied,        setCopied]        = useState(false);

  useEffect(() => {
    if (!result) return;
    setShowResult(false);
    setShowSkeleton(true);
    const t = setTimeout(() => {
      setCurrentResult(result);
      setShowSkeleton(false);
      setShowResult(true);
    }, 900);
    return () => clearTimeout(t);
  }, [result]);

  const handleCopy = () => {
    if (!currentResult) return;
    const isReverse = currentResult.mode === 'reverse';
    const text = isReverse
      ? `Required Recharge: Rs. ${currentResult.amount.toFixed(2)}\nWHT: Rs. ${currentResult.tax.toFixed(2)}\nDesired Balance: Rs. ${currentResult.net.toFixed(2)}`
      : `Net Balance: Rs. ${currentResult.net.toFixed(2)}\nWHT: Rs. ${currentResult.tax.toFixed(2)}\nRecharge: Rs. ${currentResult.amount.toFixed(2)}`;
    navigator.clipboard.writeText(text).then(() => {
      setCopied(true);
      if (navigator.vibrate) navigator.vibrate([40, 20, 40]);
      setTimeout(() => setCopied(false), 2200);
    });
  };

  return (
    <div className="glass-card result-card">
      {!result && !showSkeleton && <EmptyState />}
      {showSkeleton && <Skeleton />}
      {showResult && currentResult && (
        <ResultDisplay result={currentResult} onCopy={handleCopy} copied={copied} />
      )}
    </div>
  );
}

export default ResultCard;
