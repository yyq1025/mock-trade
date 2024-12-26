class MarketInit {
  final String symbol;
  final double price;
  final double percentChange;
  final double volume;

  MarketInit({
    required this.symbol,
    required this.price,
    required this.percentChange,
    required this.volume,
  });

  factory MarketInit.fromJson(Map<String, dynamic> json) {
    return MarketInit(
      symbol: json['symbol'],
      price: double.parse(json['lastPrice']),
      percentChange:
          (double.parse(json['lastPrice']) / double.parse(json['openPrice']) -
                  1) *
              100,
      volume: double.parse(json['quoteVolume']),
    );
  }
}
