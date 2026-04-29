import React from 'react';

export function CarrierLogo({ carrier, size = 20 }) {
  const gradientId = `grad-${carrier.toLowerCase().replace(/\s/g, '-')}`;
  
  switch (carrier) {
    case 'Jazz':
      return (
        <svg width={size} height={size} viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <linearGradient id={gradientId} x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stopColor="#FF0000" />
              <stop offset="100%" stopColor="#B30000" />
            </linearGradient>
          </defs>
          <rect width="100" height="100" rx="22" fill={`url(#${gradientId})`} />
          <path d="M50 20L58 40H78L62 52L68 72L50 60L32 72L38 52L22 40H42L50 20Z" fill="#FFC107" />
          <path d="M30 80C40 85 60 85 70 80" stroke="white" strokeWidth="6" strokeLinecap="round" opacity="0.6" />
        </svg>
      );
    case 'Zong':
      return (
        <svg width={size} height={size} viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <linearGradient id={gradientId} x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stopColor="#E6007E" />
              <stop offset="100%" stopColor="#8C004D" />
            </linearGradient>
          </defs>
          <rect width="100" height="100" rx="22" fill={`url(#${gradientId})`} />
          <path d="M20 50C20 30 50 20 80 50C80 70 50 80 20 50Z" fill="#8DC63F" opacity="0.9" />
          <path d="M35 40H65L35 65H65" stroke="white" strokeWidth="10" strokeLinecap="round" strokeLinejoin="round" />
        </svg>
      );
    case 'Ufone':
      return (
        <svg width={size} height={size} viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <linearGradient id={gradientId} x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stopColor="#FF7900" />
              <stop offset="100%" stopColor="#CC6100" />
            </linearGradient>
          </defs>
          <rect width="100" height="100" rx="22" fill={`url(#${gradientId})`} />
          <path d="M30 30V55C30 70 40 80 50 80C60 80 70 70 70 55V30" stroke="white" strokeWidth="14" strokeLinecap="round" />
          <circle cx="50" cy="45" r="8" fill="white" opacity="0.3" />
        </svg>
      );
    case 'Telenor':
      return (
        <svg width={size} height={size} viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <linearGradient id={gradientId} x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stopColor="#00A5CF" />
              <stop offset="100%" stopColor="#007291" />
            </linearGradient>
          </defs>
          <rect width="100" height="100" rx="22" fill={`url(#${gradientId})`} />
          <circle cx="50" cy="35" r="12" fill="white" />
          <circle cx="32" cy="65" r="12" fill="white" />
          <circle cx="68" cy="65" r="12" fill="white" />
          <path d="M50 35Q50 65 32 65" stroke="white" strokeWidth="8" strokeLinecap="round" />
          <path d="M50 35Q50 65 68 65" stroke="white" strokeWidth="8" strokeLinecap="round" />
        </svg>
      );
    case 'Onic':
      return (
        <svg width={size} height={size} viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
          <rect width="100" height="100" rx="22" fill="#1A1A1A" />
          <circle cx="50" cy="50" r="30" stroke="#E6007E" strokeWidth="12" />
          <path d="M50 20V35" stroke="white" strokeWidth="6" strokeLinecap="round" />
          <circle cx="50" cy="50" r="8" fill="white" />
        </svg>
      );
    case 'SCOm':
      return (
        <svg width={size} height={size} viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
          <rect width="100" height="100" rx="22" fill="#0D47A1" />
          <path d="M20 50C35 25 65 75 80 50" stroke="#FF9800" strokeWidth="14" strokeLinecap="round" />
          <circle cx="80" cy="50" r="6" fill="white" />
        </svg>
      );
    default:
      return (
        <svg width={size} height={size} viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
          <rect width="100" height="100" rx="22" fill="#455A64" />
          <circle cx="50" cy="50" r="20" stroke="white" strokeWidth="8" opacity="0.5" />
        </svg>
      );
  }
}
