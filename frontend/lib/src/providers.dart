import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_trade/src/pages/market/models/market_ticker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import 'pages/market/models/symbol_info.dart';

part 'providers.g.dart';

@riverpod
Dio backendDio(Ref ref) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment('BACKEND_URL'),
      connectTimeout: Duration(seconds: 5), // 5 seconds timeout
      receiveTimeout: Duration(seconds: 5), // 5 seconds timeout
    ),
  );
  return dio;
}

@riverpod
Dio binanceDio(Ref ref) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment('BINANCE_REST_URL'),
      connectTimeout: Duration(seconds: 5), // 5 seconds timeout
      receiveTimeout: Duration(seconds: 5), // 5 seconds timeout
    ),
  );
  return dio;
}

@riverpod
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@riverpod
Stream<User?> authState(Ref ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
}

@riverpod
Future<PusherChannelsFlutter> pusher(Ref ref) async {
  final pusher = PusherChannelsFlutter.getInstance();
  ref.onDispose(() async {
    await pusher.disconnect();
  });
  await pusher.init(
    apiKey: const String.fromEnvironment('PUSHER_KEY'),
    cluster: const String.fromEnvironment('PUSHER_CLUSTER'),
  );
  await pusher.connect();
  return pusher;
}

@riverpod
Future<Map<String, SymbolInfo>> exchangeInfo(Ref ref) async {
  final Dio dio = ref.watch(backendDioProvider);
  try {
    final response = await dio.get('/exchangeInfo');
    final infos = response.data as List;
    return Map.fromIterable(infos.map((json) => SymbolInfo.fromJson(json)),
        key: (info) => info.symbol);
  } catch (e) {
    print('Failed to fetch exchange info: $e');
    return {};
  }
}

@riverpod
class BinanceTickers extends _$BinanceTickers {
  WebSocketChannel? _channel;

  @override
  Future<Map<String, MarketTicker>> build() async {
    ref.onDispose(() {
      _closeWebSocket();
    });

    return _initialize();
  }

  Future<Map<String, MarketTicker>> _initialize() async {
    // Fetch initial full state
    final binanceDio = ref.read(binanceDioProvider);
    final response = await binanceDio
        .get('/api/v3/ticker/24hr', queryParameters: {'type': 'MINI'});

    final tickers = (response.data as List)
        .map((json) => MarketTicker.fromRestJson(json))
        .toList();

    // Connect to WebSocket for incremental updates
    _connectWebSocket();

    return Map.fromEntries(
        tickers.map((ticker) => MapEntry(ticker.symbol, ticker)));
  }

  void _connectWebSocket() {
    _closeWebSocket();

    _channel = WebSocketChannel.connect(
      Uri.parse(
          '${const String.fromEnvironment('BINANCE_WS_URL')}/!miniTicker@arr'),
    );

    _channel!.stream.listen((event) async {
      final jsonData = jsonDecode(event);

      if (jsonData == 'ping') {
        _channel!.sink.add('pong');
        return;
      }

      if (jsonData is List) {
        final previousTickers = await future;
        // Create a new map with existing data
        final updatedTickers = Map<String, MarketTicker>.from(previousTickers);

        // Process incremental updates
        final updates =
            jsonData.map((json) => MarketTicker.fromWSJson(json)).toList();

        // Apply incremental updates to the state
        for (var ticker in updates) {
          updatedTickers[ticker.symbol] = ticker;
        }

        // Update state with merged data
        state = AsyncData(updatedTickers);
      }
    }, onError: (e) {
      print('Error in ticker WebSocket: $e');
    });
  }

  void _closeWebSocket() {
    _channel?.sink.close();
    _channel = null;
  }

  // // Optional: Add method to refresh data manually
  // Future<void> refresh() async {
  //   state = const AsyncLoading();
  //   try {
  //     final fresh = await _initialize();
  //     state = AsyncData(fresh);
  //   } catch (e, stack) {
  //     state = AsyncError(e, stack);
  //   }
  // }
}
