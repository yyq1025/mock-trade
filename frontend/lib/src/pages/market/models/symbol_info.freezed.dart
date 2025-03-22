// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'symbol_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SymbolInfo {
  String get symbol;
  String get baseAsset;
  String get quoteAsset;

  /// Create a copy of SymbolInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SymbolInfoCopyWith<SymbolInfo> get copyWith =>
      _$SymbolInfoCopyWithImpl<SymbolInfo>(this as SymbolInfo, _$identity);

  /// Serializes this SymbolInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SymbolInfo &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.baseAsset, baseAsset) ||
                other.baseAsset == baseAsset) &&
            (identical(other.quoteAsset, quoteAsset) ||
                other.quoteAsset == quoteAsset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, symbol, baseAsset, quoteAsset);

  @override
  String toString() {
    return 'SymbolInfo(symbol: $symbol, baseAsset: $baseAsset, quoteAsset: $quoteAsset)';
  }
}

/// @nodoc
abstract mixin class $SymbolInfoCopyWith<$Res> {
  factory $SymbolInfoCopyWith(
          SymbolInfo value, $Res Function(SymbolInfo) _then) =
      _$SymbolInfoCopyWithImpl;
  @useResult
  $Res call({String symbol, String baseAsset, String quoteAsset});
}

/// @nodoc
class _$SymbolInfoCopyWithImpl<$Res> implements $SymbolInfoCopyWith<$Res> {
  _$SymbolInfoCopyWithImpl(this._self, this._then);

  final SymbolInfo _self;
  final $Res Function(SymbolInfo) _then;

  /// Create a copy of SymbolInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? baseAsset = null,
    Object? quoteAsset = null,
  }) {
    return _then(_self.copyWith(
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      baseAsset: null == baseAsset
          ? _self.baseAsset
          : baseAsset // ignore: cast_nullable_to_non_nullable
              as String,
      quoteAsset: null == quoteAsset
          ? _self.quoteAsset
          : quoteAsset // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SymbolInfo implements SymbolInfo {
  const _SymbolInfo(
      {required this.symbol,
      required this.baseAsset,
      required this.quoteAsset});
  factory _SymbolInfo.fromJson(Map<String, dynamic> json) =>
      _$SymbolInfoFromJson(json);

  @override
  final String symbol;
  @override
  final String baseAsset;
  @override
  final String quoteAsset;

  /// Create a copy of SymbolInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SymbolInfoCopyWith<_SymbolInfo> get copyWith =>
      __$SymbolInfoCopyWithImpl<_SymbolInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SymbolInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SymbolInfo &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.baseAsset, baseAsset) ||
                other.baseAsset == baseAsset) &&
            (identical(other.quoteAsset, quoteAsset) ||
                other.quoteAsset == quoteAsset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, symbol, baseAsset, quoteAsset);

  @override
  String toString() {
    return 'SymbolInfo(symbol: $symbol, baseAsset: $baseAsset, quoteAsset: $quoteAsset)';
  }
}

/// @nodoc
abstract mixin class _$SymbolInfoCopyWith<$Res>
    implements $SymbolInfoCopyWith<$Res> {
  factory _$SymbolInfoCopyWith(
          _SymbolInfo value, $Res Function(_SymbolInfo) _then) =
      __$SymbolInfoCopyWithImpl;
  @override
  @useResult
  $Res call({String symbol, String baseAsset, String quoteAsset});
}

/// @nodoc
class __$SymbolInfoCopyWithImpl<$Res> implements _$SymbolInfoCopyWith<$Res> {
  __$SymbolInfoCopyWithImpl(this._self, this._then);

  final _SymbolInfo _self;
  final $Res Function(_SymbolInfo) _then;

  /// Create a copy of SymbolInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symbol = null,
    Object? baseAsset = null,
    Object? quoteAsset = null,
  }) {
    return _then(_SymbolInfo(
      symbol: null == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      baseAsset: null == baseAsset
          ? _self.baseAsset
          : baseAsset // ignore: cast_nullable_to_non_nullable
              as String,
      quoteAsset: null == quoteAsset
          ? _self.quoteAsset
          : quoteAsset // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
