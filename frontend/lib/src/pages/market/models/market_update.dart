class MarketUpdate {
  final String symbol;
  final double price;
  final double percentChange;
  final double volume;

  MarketUpdate({
    required this.symbol,
    required this.price,
    required this.percentChange,
    required this.volume,
  });

  factory MarketUpdate.fromJson(Map<String, dynamic> json) {
    return MarketUpdate(
      symbol: json['s'],
      price: double.parse(json['c']),
      percentChange:
          (double.parse(json['c']) / double.parse(json['o']) - 1) * 100,
      volume: double.parse(json['q']),
    );
  }
}
