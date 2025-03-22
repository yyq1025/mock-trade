import 'package:freezed_annotation/freezed_annotation.dart';

import '../../market/models/symbol_info.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String orderId,
    required String symbol,
    required String side,
    required String quantity,
    required String price,
    required SymbolInfo symbolInfo,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? executionPrice,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
