import React, { useState } from 'react';
import { Smartphone, Zap, Target, Wallet } from 'lucide-react';
import { detectCarrier } from '../utils/carriers';
import { CarrierLogo } from '../utils/CarrierLogos';
import './CalculatorForm.css';

const CARRIERS = ['Jazz', 'Zong', 'Telenor', 'Ufone', 'Onic', 'SCOm'];
const WHT_RATE = 0.15; // 15% tax on the net balance

function CalculatorForm({ onCalculate }) {
  const [mobile,   setMobile]   = useState('');
  const [carrier,  setCarrier]  = useState('');
  const [amount,   setAmount]   = useState('');
  const [loading,  setLoading]  = useState(false);
  const [errors,   setErrors]   = useState({});
  const [mode,     setMode]     = useState('forward'); // 'forward' | 'reverse'

  /* ── Carrier auto-detect ── */
  const handleMobileChange = (e) => {
    const val = e.target.value.replace(/[^0-9]/g, '').slice(0, 11);
    setMobile(val);
    const detected = detectCarrier(val);
    if (detected) setCarrier(detected);
    if (errors.mobile) setErrors(p => ({ ...p, mobile: '' }));
  };

  /* ── Validation ── */
  const validate = () => {
    const errs = {};
    // Mobile is optional; but if entered it must be 11 digits
    if (mobile && (mobile.length !== 11 || !mobile.startsWith('0'))) {
      errs.mobile = 'Enter a valid 11-digit number (e.g. 03XXXXXXXXX)';
    }
    const amt = parseFloat(amount);
    if (!amount || isNaN(amt) || amt <= 0) {
      errs.amount = 'Enter a valid positive amount';
    }
    return errs;
  };

  /* ── Submit ── */
  const handleSubmit = (e) => {
    e.preventDefault();
    const errs = validate();
    if (Object.keys(errs).length > 0) { setErrors(errs); return; }
    setErrors({});
    setLoading(true);
    if (navigator.vibrate) navigator.vibrate(50);

    setTimeout(() => {
      const amt = parseFloat(amount);
      const resolvedCarrier = carrier || 'Unknown';
      if (mode === 'forward') {
        const net = amt / (1 + WHT_RATE);
        const tax = amt - net;
        onCalculate({ mobile, carrier: resolvedCarrier, amount: amt, tax, net, mode: 'forward' });
      } else {
        // Reverse: user wants 'amt' in account — how much to recharge?
        const required = amt * (1 + WHT_RATE);
        const tax      = required - amt;
        onCalculate({ mobile, carrier: resolvedCarrier, amount: required, tax, net: amt, desiredNet: amt, mode: 'reverse' });
      }
      setLoading(false);
    }, 900);
  };

  return (
    <div className="glass-card fade-in-delay form-card">
      {/* Mode toggle */}
      <div className="mode-toggle" role="group" aria-label="Calculation mode">
        <button
          type="button"
          className={`mode-btn ${mode === 'forward' ? 'active' : ''}`}
          onClick={() => setMode('forward')}
        >
          <Zap size={14} /> <span>Recharge → Balance</span>
        </button>
        <button
          type="button"
          className={`mode-btn ${mode === 'reverse' ? 'active' : ''}`}
          onClick={() => setMode('reverse')}
        >
          <Target size={14} /> <span>Target Balance</span>
        </button>
      </div>

      <form onSubmit={handleSubmit} noValidate>
        {/* Mobile Number (optional) */}
        <div className="field">
          <label className="field-label" htmlFor="mobile">
            <Smartphone size={14} /> <span>Mobile Number</span> <span className="optional">(optional)</span>
          </label>
          <input
            id="mobile"
            className={`neu-input ${errors.mobile ? 'input-error' : ''}`}
            type="tel"
            value={mobile}
            onChange={handleMobileChange}
            placeholder="03XXXXXXXXX"
            autoComplete="off"
            inputMode="numeric"
          />
          {errors.mobile && <p className="err-msg">{errors.mobile}</p>}
        </div>

        {/* Carrier (optional / auto-detected) */}
        <div className="field">
          <label className="field-label" htmlFor="carrier">
            Carrier <span className="optional">(optional)</span>
          </label>
          <div className="carrier-wrap">
            {carrier && (
              <span className="carrier-badge">
                <CarrierLogo carrier={carrier} size={18} /> {carrier}
              </span>
            )}
            <select
              id="carrier"
              className="neu-input carrier-select"
              value={carrier}
              onChange={(e) => setCarrier(e.target.value)}
            >
              <option value="">Auto-detect or select…</option>
              {CARRIERS.map(c => (
                <option key={c} value={c}>{c}</option>
              ))}
            </select>
          </div>
        </div>

        {/* Amount */}
        <div className="field">
          <label className="field-label" htmlFor="amount">
            <Wallet size={14} /> <span>{mode === 'forward' ? 'Recharge Amount' : 'Desired Balance'}</span>
          </label>
          <div className="amt-wrap">
            <span className="amt-prefix">Rs.</span>
            <input
              id="amount"
              className={`neu-input amt-input ${errors.amount ? 'input-error' : ''}`}
              type="number"
              min="1"
              step="0.01"
              value={amount}
              onChange={(e) => {
                setAmount(e.target.value);
                if (errors.amount) setErrors(p => ({ ...p, amount: '' }));
              }}
              placeholder={mode === 'forward' ? '100' : '86.96'}
              inputMode="decimal"
            />
          </div>
          {errors.amount && <p className="err-msg">{errors.amount}</p>}
          {mode === 'reverse' && (
            <p className="hint-msg">
              We'll calculate the recharge needed to get this amount after 15% WHT (inclusive).
            </p>
          )}
        </div>

        <button
          type="submit"
          className={`calc-btn ${loading ? 'loading' : ''}`}
          disabled={loading}
        >
          {loading
            ? <span className="loading-dots">Processing<span>.</span><span>.</span><span>.</span></span>
            : mode === 'forward'
              ? <><Zap size={18} /> <span>Calculate Balance</span></>
              : <><Target size={18} /> <span>Calculate Recharge</span></>
          }
        </button>
      </form>
    </div>
  );
}

export default CalculatorForm;
