import 'market_update.dart';
import 'symbol_info.dart';
import 'market_init.dart';

class MarketData {
  final String symbol;
  final String baseAsset;
  final String quoteAsset;
  double price;
  double percentChange;
  double volume;

  MarketData({
    required this.symbol,
    required this.baseAsset,
    required this.quoteAsset,
    required this.price,
    required this.percentChange,
    required this.volume,
  });

  factory MarketData.fromSymbolInfo(SymbolInfo symbolInfo) {
    return MarketData(
      symbol: symbolInfo.symbol,
      baseAsset: symbolInfo.baseAsset,
      quoteAsset: symbolInfo.quoteAsset,
      price: 0.0,
      percentChange: 0.0,
      volume: 0.0,
    );
  }

  void init(MarketInit marketInit) {
    price = marketInit.price;
    percentChange = marketInit.percentChange;
    volume = marketInit.volume;
  }

  void update(MarketUpdate marketUpdate) {
    price = marketUpdate.price;
    percentChange = marketUpdate.percentChange;
    volume = marketUpdate.volume;
  }
}
