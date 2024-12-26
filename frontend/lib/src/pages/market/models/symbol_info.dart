class SymbolInfo {
  final String symbol;
  final String baseAsset;
  final String quoteAsset;

  SymbolInfo({
    required this.symbol,
    required this.baseAsset,
    required this.quoteAsset,
  });

  factory SymbolInfo.fromJson(Map<String, dynamic> json) {
    return SymbolInfo(
      symbol: json['symbol'],
      baseAsset: json['baseAsset'],
      quoteAsset: json['quoteAsset'],
    );
  }
}
