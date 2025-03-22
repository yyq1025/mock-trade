import 'package:decimal/decimal.dart';

class Balance {
  final String asset;
  final Decimal free;
  final Decimal locked;

  Balance({
    required this.asset,
    required this.free,
    required this.locked,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      asset: json['asset'],
      free: Decimal.parse(json['free']),
      locked: Decimal.parse(json['locked']),
    );
  }
}
