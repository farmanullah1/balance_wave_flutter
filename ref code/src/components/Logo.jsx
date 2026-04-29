import React from 'react';

export function Logo({ size = 32, className = "" }) {
  return (
    <svg 
      className={className} 
      width={size} 
      height={size} 
      viewBox="0 0 100 100" 
      xmlns="http://www.w3.org/2000/svg"
    >
      <defs>
        <linearGradient id="logoGrad" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stopColor="var(--grad-from)" />
          <stop offset="100%" stopColor="var(--grad-to)" />
        </linearGradient>
      </defs>
      {/* Premium rounded background */}
      <rect width="100" height="100" rx="24" fill="url(#logoGrad)" />
      
      {/* Stylized Wave Path */}
      <path 
        d="M20 50 C 35 20, 65 80, 80 50" 
        fill="none" 
        stroke="white" 
        strokeWidth="8" 
        strokeLinecap="round" 
      />
      
      {/* Secondary Accent Wave */}
      <path 
        d="M20 65 C 35 35, 65 95, 80 65" 
        fill="none" 
        stroke="rgba(255,255,255,0.4)" 
        strokeWidth="6" 
        strokeLinecap="round" 
      />
      
      {/* Connectivity Dot */}
      <circle cx="50" cy="25" r="7" fill="white" />
    </svg>
  );
}
