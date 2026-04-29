enum CalculationMode { forward, reverse }

class HistoryEntry {
  final int id;
  final DateTime ts;
  final String carrier;
  final double amount;
  final double tax;
  final double net;
  final CalculationMode mode;

  HistoryEntry({
    required this.id,
    required this.ts,
    required this.carrier,
    required this.amount,
    required this.tax,
    required this.net,
    required this.mode,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'ts': ts.toIso8601String(),
        'carrier': carrier,
        'amount': amount,
        'tax': tax,
        'net': net,
        'mode': mode.index,
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        id: json['id'],
        ts: DateTime.parse(json['ts']),
        carrier: json['carrier'],
        amount: json['amount'],
        tax: json['tax'],
        net: json['net'],
        mode: CalculationMode.values[json['mode']],
      );
}
