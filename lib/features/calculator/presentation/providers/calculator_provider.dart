import 'dart:convert';
import 'package:flutter_riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/calculator_utils.dart';
import '../domain/carrier.dart';
import '../domain/history_entry.dart';

class CalculatorState {
  final String mobileNumber;
  final Carrier? selectedCarrier;
  final String amountString;
  final CalculationMode mode;
  final Map<String, double>? result;
  final bool isLoading;
  final List<HistoryEntry> history;

  CalculatorState({
    this.mobileNumber = '',
    this.selectedCarrier,
    this.amountString = '',
    this.mode = CalculationMode.forward,
    this.result,
    this.isLoading = false,
    this.history = const [],
  });

  CalculatorState copyWith({
    String? mobileNumber,
    Carrier? selectedCarrier,
    String? amountString,
    CalculationMode? mode,
    Map<String, double>? result,
    bool? isLoading,
    List<HistoryEntry>? history,
  }) {
    return CalculatorState(
      mobileNumber: mobileNumber ?? this.mobileNumber,
      selectedCarrier: selectedCarrier ?? this.selectedCarrier,
      amountString: amountString ?? this.amountString,
      mode: mode ?? this.mode,
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      history: history ?? this.history,
    );
  }
}

class CalculatorNotifier extends Notifier<CalculatorState> {
  static const int maxHistory = 8;
  late SharedPreferences _prefs;

  @override
  CalculatorState build() {
    _init();
    return CalculatorState();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final historyJson = _prefs.getString('bw-history');
    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      state = state.copyWith(
        history: decoded.map((item) => HistoryEntry.fromJson(item)).toList(),
      );
    }
  }

  Future<void> _saveHistory(List<HistoryEntry> history) async {
    final historyJson = jsonEncode(history.map((e) => e.toJson()).toList());
    await _prefs.setString('bw-history', historyJson);
  }

  void setMobileNumber(String value) {
    final detected = CalculatorUtils.detectCarrier(value);
    state = state.copyWith(
      mobileNumber: value,
      selectedCarrier: detected ?? state.selectedCarrier,
    );
  }

  void setSelectedCarrier(Carrier? carrier) {
    state = state.copyWith(selectedCarrier: carrier);
  }

  void setAmount(String value) {
    state = state.copyWith(amountString: value);
  }

  void setMode(CalculationMode mode) {
    state = state.copyWith(mode: mode, result: null);
  }

  Future<void> calculate() async {
    if (state.amountString.isEmpty) return;
    
    final amt = double.tryParse(state.amountString);
    if (amt == null || amt <= 0) return;

    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 900));

    Map<String, double> res;
    if (state.mode == CalculationMode.forward) {
      res = CalculatorUtils.calculateForward(amt);
    } else {
      res = CalculatorUtils.calculateReverse(amt);
    }

    final entry = HistoryEntry(
      id: DateTime.now().millisecondsSinceEpoch,
      ts: DateTime.now(),
      carrier: state.selectedCarrier?.name ?? 'Unknown',
      amount: res['amount']!,
      tax: res['tax']!,
      net: res['net']!,
      mode: state.mode,
    );

    final newHistory = [entry, ...state.history];
    if (newHistory.length > maxHistory) {
      newHistory.removeLast();
    }
    
    await _saveHistory(newHistory);

    state = state.copyWith(
      isLoading: false,
      result: res,
      history: newHistory,
    );
  }

  void clearHistory() async {
    await _prefs.remove('bw-history');
    state = state.copyWith(history: []);
  }

  void reset() {
    state = state.copyWith(
      mobileNumber: '',
      selectedCarrier: null,
      amountString: '',
      result: null,
    );
  }
}

final calculatorProvider = NotifierProvider<CalculatorNotifier, CalculatorState>(() {
  return CalculatorNotifier();
});
