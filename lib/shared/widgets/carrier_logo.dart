import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarrierLogo extends StatelessWidget {
  final String carrier;
  final double size;

  const CarrierLogo({super.key, required this.carrier, this.size = 24});

  static const Map<String, String> _carrierAssets = {
    'Jazz': 'assets/carriers/jazz.svg',
    'Zong': 'assets/carriers/zong.svg',
    'Telenor': 'assets/carriers/telenor.svg',
    'Ufone': 'assets/carriers/ufone.svg',
    'Onic': 'assets/carriers/onic.svg',
    'SCOm': 'assets/carriers/scom.svg',
  };

  @override
  Widget build(BuildContext context) {
    final assetPath = _carrierAssets[carrier];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: assetPath != null
          ? SvgPicture.asset(
              assetPath,
              width: size,
              height: size,
              fit: BoxFit.cover,
            )
          : _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF455A64),
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      child: Center(
        child: Text(
          carrier.isNotEmpty ? carrier[0] : '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
