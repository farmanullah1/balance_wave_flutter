import { Logo } from './Logo';
import './HeroCard.css';

const BARS = [8,14,22,28,36,28,22,14,8,16,24,16,8];

function HeroCard() {
  return (
    <div className="glass-card hero-card fade-in">
      <div className="hero-icon-wrap">
        <Logo size={48} className="hero-icon" />
      </div>
      <h1 className="hero-title">BalanceWave</h1>
      <p className="hero-sub">Smart SIM balance calculation for Pakistan</p>
      <div className="wave-line" aria-hidden="true">
        {BARS.map((h, i) => (
          <span
            key={i}
            className="wave-bar"
            style={{
              height: `${h}px`,
              animationDelay: `${i * 0.09}s`,
              background: i === 4 ? 'var(--wave)'
                        : i >= 9  ? 'var(--danger)'
                        : 'var(--accent)',
            }}
          />
        ))}
      </div>
    </div>
  );
}

export default HeroCard;
