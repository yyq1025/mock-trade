import 'package:freezed_annotation/freezed_annotation.dart';

part 'symbol_info.freezed.dart';
part 'symbol_info.g.dart';

@freezed
abstract class SymbolInfo with _$SymbolInfo {
  const factory SymbolInfo({
    required String symbol,
    required String baseAsset,
    required String quoteAsset,
  }) = _SymbolInfo;

  factory SymbolInfo.fromJson(Map<String, dynamic> json) =>
      _$SymbolInfoFromJson(json);
}
