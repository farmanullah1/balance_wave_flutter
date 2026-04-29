import 'package:flutter/material.dart';
import '../../features/calculator/domain/carrier.dart';

class CarrierConstants {
  static const List<Carrier> carriers = [
    Carrier(
      name: 'Jazz',
      prefixes: [
        '0300', '0301', '0302', '0303', '0304', '0305', '0306', '0307', '0308', '0309',
        '0320', '0321', '0322', '0323', '0324', '0325',
      ],
      emoji: '🟠',
      color: Color(0xFFFF6B00),
      logoAsset: 'assets/logos/jazz.svg',
    ),
    Carrier(
      name: 'Zong',
      prefixes: ['0310', '0311', '0312', '0313', '0314', '0315', '0316', '0317', '0318', '0319'],
      emoji: '⚫',
      color: Color(0xFF000000),
      logoAsset: 'assets/logos/zong.svg',
    ),
    Carrier(
      name: 'Ufone',
      prefixes: ['0330', '0331', '0332', '0333', '0334', '0335', '0336', '0337', '0338'],
      emoji: '🟣',
      color: Color(0xFF5A2D82),
      logoAsset: 'assets/logos/ufone.svg',
    ),
    Carrier(
      name: 'Telenor',
      prefixes: ['0340', '0341', '0342', '0343', '0344', '0345', '0346', '0347', '0348', '0349'],
      emoji: '🔵',
      color: Color(0xFF00A9E0),
      logoAsset: 'assets/logos/telenor.svg',
    ),
    Carrier(
      name: 'Onic',
      prefixes: ['0339'],
      emoji: '🟪',
      color: Color(0xFF8E44AD),
      logoAsset: 'assets/logos/onic.svg',
    ),
    Carrier(
      name: 'SCOm',
      prefixes: ['0355'],
      emoji: '🟦',
      color: Color(0xFF2980B9),
      logoAsset: 'assets/logos/scom.svg',
    ),
  ];
}
