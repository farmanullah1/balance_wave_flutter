/* Carrier prefix map for Pakistan */
const PREFIXES = {
  Jazz: [
    '0300','0301','0302','0303','0304','0305','0306','0307','0308','0309',
    '0320','0321','0322','0323','0324','0325',
  ],
  Zong:    ['0310','0311','0312','0313','0314','0315','0316','0317','0318','0319'],
  Ufone:   ['0330','0331','0332','0333','0334','0335','0336','0337','0338'],
  Onic:    ['0339'],
  Telenor: ['0340','0341','0342','0343','0344','0345','0346','0347','0348','0349'],
  SCOm:    ['0355'],
};

export const CARRIER_EMOJI = {
  Jazz:    '🟠',
  Zong:    '⚫',
  Ufone:   '🟣',
  Telenor: '🔵',
  Onic:    '🟪',
  SCOm:    '🟦',
};

export function detectCarrier(number) {
  if (!number || number.length < 4) return null;
  const prefix = number.substring(0, 4);
  for (const [carrier, prefixList] of Object.entries(PREFIXES)) {
    if (prefixList.includes(prefix)) return carrier;
  }
  return null;
}

export default PREFIXES;
