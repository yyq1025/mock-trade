import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../providers.dart';
import '../models/kline.dart';

part 'klines_provider.g.dart';

@riverpod
class Klines extends _$Klines {
  // WebSocketChannel? _channel;
  @override
  Future<List<Kline>> build(String symbol, {String interval = '15m'}) async {
    final dio = ref.read(binanceDioProvider);
    print('Fetching Klines for $symbol');
    final response = await dio.get('/api/v3/klines', queryParameters: {
      'symbol': symbol,
      'interval': interval,
      'limit': 96,
    });
    final data = response.data as List;

    _connectWebSocket();

    return data.map((json) => Kline.fromRestJson(json)).toList();
  }

  Future<void> _connectWebSocket() async {
    final (channel, stream) = await ref.watch(binanceWSChannelProvider.future);
    ref.onCancel(() {
      print('Unsubscribing from Kline updates');
      channel.sink.add(json.encode({
        "method": "UNSUBSCRIBE",
        "params": ["${symbol.toLowerCase()}@kline_$interval"],
        "id": "${symbol.toLowerCase()}_kline_$interval"
      }));
    });

    print('Subscribing to Kline updates');
    channel.sink.add(json.encode({
      "method": "SUBSCRIBE",
      "params": ["${symbol.toLowerCase()}@kline_$interval"],
      "id": "${symbol.toLowerCase()}_kline_$interval"
    }));
    stream.listen((event) async {
      final jsonData = jsonDecode(event);
      if (jsonData is Map && jsonData['e'] == 'kline') {
        final kline = Kline.fromWSJson(jsonData['k']);
        final previousKlines = await future;
        if (previousKlines.last.openTime != kline.openTime) {
          print('Unsubscribing from Kline updates');
          channel.sink.add(json.encode({
            "method": "UNSUBSCRIBE",
            "params": ["${symbol.toLowerCase()}@kline_$interval"],
            "id": "${symbol.toLowerCase()}_kline_$interval"
          }));
          ref.invalidateSelf();
        } else {
          final updatedKlines = List<Kline>.from(previousKlines);
          updatedKlines.last = kline;
          state = AsyncData(updatedKlines);
        }
      }
    });
  }
}
