// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
      orderId: json['orderId'] as String,
      symbol: json['symbol'] as String,
      side: json['side'] as String,
      quantity: json['quantity'] as String,
      price: json['price'] as String,
      symbolInfo:
          SymbolInfo.fromJson(json['symbolInfo'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      executionPrice: json['executionPrice'] as String?,
    );

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
      'orderId': instance.orderId,
      'symbol': instance.symbol,
      'side': instance.side,
      'quantity': instance.quantity,
      'price': instance.price,
      'symbolInfo': instance.symbolInfo,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'executionPrice': instance.executionPrice,
    };
