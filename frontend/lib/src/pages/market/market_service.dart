import 'package:dio/dio.dart';
import 'models/symbol_info.dart';
import 'models/market_init.dart';

class MarketService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
      connectTimeout: Duration(seconds: 5), // 5 seconds timeout
      receiveTimeout: Duration(seconds: 5), // 5 seconds timeout
    ),
  );

  final Dio _binanceDio = Dio(
    BaseOptions(
      baseUrl: 'https://data-api.binance.vision',
      connectTimeout: Duration(seconds: 5), // 5 seconds timeout
      receiveTimeout: Duration(seconds: 5), // 5 seconds timeout
    ),
  );

  Future<List<SymbolInfo>> fetchExchangeInfo() async {
    try {
      final response = await _dio.get('/exchangeInfo');
      final symbols = response.data as List;
      return symbols.map((json) => SymbolInfo.fromJson(json)).toList();
    } catch (e) {
      print('Failed to fetch exchange info: $e');
      return [];
    }
  }

  Future<List<MarketInit>> fetchInitMarketData() async {
    try {
      final response = await _binanceDio.get('/api/v3/ticker/24hr');
      final marketData = response.data as List;
      return marketData.map((json) => MarketInit.fromJson(json)).toList();
    } catch (e) {
      print('Failed to fetch market init data: $e');
      return [];
    }
  }
}
