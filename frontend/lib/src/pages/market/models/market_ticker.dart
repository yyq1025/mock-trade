import 'package:decimal/decimal.dart';

class MarketTicker {
  final String symbol;
  Decimal openPrice;
  double highPrice;
  double lowPrice;
  Decimal lastPrice;
  double volume;
  double quoteVolume;

  MarketTicker({
    required this.symbol,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.lastPrice,
    required this.volume,
    required this.quoteVolume,
  });

  factory MarketTicker.fromRestJson(Map<String, dynamic> json) {
    return MarketTicker(
      symbol: json['symbol'],
      openPrice: Decimal.parse(json['openPrice']),
      highPrice: double.parse(json['highPrice']),
      lowPrice: double.parse(json['lowPrice']),
      lastPrice: Decimal.parse(json['lastPrice']),
      volume: double.parse(json['volume']),
      quoteVolume: double.parse(json['quoteVolume']),
    );
  }

  factory MarketTicker.fromWSJson(Map<String, dynamic> json) {
    return MarketTicker(
      symbol: json['s'],
      openPrice: Decimal.parse(json['o']),
      highPrice: double.parse(json['h']),
      lowPrice: double.parse(json['l']),
      lastPrice: Decimal.parse(json['c']),
      volume: double.parse(json['v']),
      quoteVolume: double.parse(json['q']),
    );
  }
}
