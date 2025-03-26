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
import 'pages/trade/providers/open_orders_provider.dart';
import 'pages/trade/providers/trade_history_provider.dart';
import 'pages/wallet/providers/balances_provider.dart';

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
    print('Disconnecting from Pusher');
    await pusher.disconnect();
  });
  await pusher.init(
      apiKey: const String.fromEnvironment('PUSHER_KEY'),
      cluster: const String.fromEnvironment('PUSHER_CLUSTER'),
      onEvent: (event) {
        if (event.eventName == 'order') {
          ref.invalidate(openOrdersProvider);
          ref.invalidate(balancesProvider);
          if (json.decode(event.data)['status'] == 'FILLED') {
            ref.invalidate(tradeHistoryProvider);
          }
        }
      });
  print('Connecting to Pusher');

  await pusher.connect();
  return pusher;
}

@riverpod
class PusherSub extends _$PusherSub {
  PusherChannel? userChannel;
  @override
  Future<void> build() async {
    final pusher = await ref.watch(pusherProvider.future);
    final user = ref.watch(authStateProvider).valueOrNull;
    ref.onCancel(() async {
      await userChannel?.unsubscribe();
      userChannel = null;
    });
    if (userChannel != null) {
      await userChannel!.unsubscribe();
      userChannel = null;
    }
    if (user != null) {
      userChannel = await pusher.subscribe(channelName: user.uid);
    }
  }
}

@riverpod
Future<(WebSocketChannel, Stream<dynamic>)> binanceWSChannel(Ref ref) async {
  final channel = WebSocketChannel.connect(
    Uri.parse(const String.fromEnvironment('BINANCE_WS_URL')),
  );
  ref.onDispose(() {
    print('Closing WebSocket channel');
    channel.sink.close();
  });
  print('Connecting to WebSocket channel');
  await channel.ready;
  return (channel, channel.stream.asBroadcastStream());
}

@riverpod
Future<Map<String, SymbolInfo>> exchangeInfo(Ref ref) async {
  final Dio dio = ref.read(backendDioProvider);
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
  @override
  Future<Map<String, MarketTicker>> build() async {
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

  Future<void> _connectWebSocket() async {
    final (channel, stream) = await ref.watch(binanceWSChannelProvider.future);
    ref.onCancel(() {
      print('Unsubscribing from all mini tickers');
      channel.sink.add(json.encode({
        "method": "UNSUBSCRIBE",
        "params": ["!miniTicker@arr"],
        "id": "miniTicker_arr"
      }));
    });

    print('Subscribing to all mini tickers');
    channel.sink.add(json.encode({
      "method": "SUBSCRIBE",
      "params": ["!miniTicker@arr"],
      "id": "miniTicker_arr"
    }));
    stream.listen((event) async {
      final jsonData = jsonDecode(event);

      if (jsonData is List &&
          jsonData.isNotEmpty &&
          jsonData.first['e'] == '24hrMiniTicker') {
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
    });
  }
}
