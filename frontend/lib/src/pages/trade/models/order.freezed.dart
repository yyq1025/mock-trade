// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {
  String get orderId;
  String get symbol;
  String get side;
  String get quantity;
  String get price;
  SymbolInfo get symbolInfo;
  DateTime get createdAt;
  DateTime get updatedAt;
  String? get executionPrice;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderCopyWith<Order> get copyWith =>
      _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Order &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.symbolInfo, symbolInfo) ||
                other.symbolInfo == symbolInfo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.executionPrice, executionPrice) ||
                other.executionPrice == executionPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, orderId, symbol, side, quantity,
      price, symbolInfo, createdAt, updatedAt, executionPrice);

  @override
  String toString() {
    return 'Order(orderId: $orderId, symbol: $symbol, side: $side, quantity: $quantity, price: $price, symbolInfo: $symbolInfo, createdAt: $createdAt, updatedAt: $updatedAt, executionPrice: $executionPrice)';
  }
}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) =
      _$OrderCopyWithImpl;
  @useResult
  $Res call(
      {String orderId,
      String symbol,
      String side,
      String quantity,
      String price,
      SymbolInfo symbolInfo,
      DateTime createdAt,
      DateTime updatedAt,
      String? executionPrice});

  $SymbolInfoCopyWith<$Res> get symbolInfo;
}

/// @nodoc
class _$OrderCopyWithImpl<$Res> implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? symbol = null,
    Object? side = null,
    Object? quantity = null,
    Object? price = null,
    Object? symbolInfo = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? executionPrice = freezed,
  }) {
    return _then(_self.copyWith(
      orderId: null == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      side: null == side
          ? _self.side
          : side // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      symbolInfo: null == symbolInfo
          ? _self.symbolInfo
          : symbolInfo // ignore: cast_nullable_to_non_nullable
              as SymbolInfo,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      executionPrice: freezed == executionPrice
          ? _self.executionPrice
          : executionPrice // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SymbolInfoCopyWith<$Res> get symbolInfo {
    return $SymbolInfoCopyWith<$Res>(_self.symbolInfo, (value) {
      return _then(_self.copyWith(symbolInfo: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Order implements Order {
  const _Order(
      {required this.orderId,
      required this.symbol,
      required this.side,
      required this.quantity,
      required this.price,
      required this.symbolInfo,
      required this.createdAt,
      required this.updatedAt,
      this.executionPrice});
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  @override
  final String orderId;
  @override
  final String symbol;
  @override
  final String side;
  @override
  final String quantity;
  @override
  final String price;
  @override
  final SymbolInfo symbolInfo;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? executionPrice;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderCopyWith<_Order> get copyWith =>
      __$OrderCopyWithImpl<_Order>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Order &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.symbolInfo, symbolInfo) ||
                other.symbolInfo == symbolInfo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.executionPrice, executionPrice) ||
                other.executionPrice == executionPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, orderId, symbol, side, quantity,
      price, symbolInfo, createdAt, updatedAt, executionPrice);

  @override
  String toString() {
    return 'Order(orderId: $orderId, symbol: $symbol, side: $side, quantity: $quantity, price: $price, symbolInfo: $symbolInfo, createdAt: $createdAt, updatedAt: $updatedAt, executionPrice: $executionPrice)';
  }
}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) =
      __$OrderCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String orderId,
      String symbol,
      String side,
      String quantity,
      String price,
      SymbolInfo symbolInfo,
      DateTime createdAt,
      DateTime updatedAt,
      String? executionPrice});

  @override
  $SymbolInfoCopyWith<$Res> get symbolInfo;
}

/// @nodoc
class __$OrderCopyWithImpl<$Res> implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? orderId = null,
    Object? symbol = null,
    Object? side = null,
    Object? quantity = null,
    Object? price = null,
    Object? symbolInfo = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? executionPrice = freezed,
  }) {
    return _then(_Order(
      orderId: null == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      side: null == side
          ? _self.side
          : side // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      symbolInfo: null == symbolInfo
          ? _self.symbolInfo
          : symbolInfo // ignore: cast_nullable_to_non_nullable
              as SymbolInfo,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      executionPrice: freezed == executionPrice
          ? _self.executionPrice
          : executionPrice // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SymbolInfoCopyWith<$Res> get symbolInfo {
    return $SymbolInfoCopyWith<$Res>(_self.symbolInfo, (value) {
      return _then(_self.copyWith(symbolInfo: value));
    });
  }
}

// dart format on
