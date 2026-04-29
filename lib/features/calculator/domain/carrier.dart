import 'package:flutter/material.dart';

class Carrier {
  final String name;
  final List<String> prefixes;
  final String emoji;
  final Color color;
  final String logoAsset;

  const Carrier({
    required this.name,
    required this.prefixes,
    required this.emoji,
    required this.color,
    required this.logoAsset,
  });
}
