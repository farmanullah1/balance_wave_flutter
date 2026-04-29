import '../constants/carriers.dart';
import '../../models/carrier.dart';

class CalculatorUtils {
  static const double whtRate = 0.15;

  static Carrier? detectCarrier(String number) {
    if (number.length < 4) return null;
    final prefix = number.substring(0, 4);
    for (var carrier in CarrierConstants.carriers) {
      if (carrier.prefixes.contains(prefix)) {
        return carrier;
      }
    }
    return null;
  }

  static Map<String, double> calculateForward(double amount) {
    final net = amount / (1 + whtRate);
    final tax = amount - net;
    return {
      'net': net,
      'tax': tax,
      'amount': amount,
    };
  }

  static Map<String, double> calculateReverse(double desiredNet) {
    final required = desiredNet * (1 + whtRate);
    final tax = required - desiredNet;
    return {
      'net': desiredNet,
      'tax': tax,
      'amount': required,
    };
  }
}
