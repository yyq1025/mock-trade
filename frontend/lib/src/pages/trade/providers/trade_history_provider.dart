import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers.dart';
import '../models/order.dart';

part 'trade_history_provider.g.dart';

@riverpod
Future<List<Order>> tradeHistory(Ref ref) async {
  final user = ref.read(authStateProvider).valueOrNull;
  final token = await user?.getIdToken();
  final backendDio = ref.read(backendDioProvider);
  if (token != null) {
    final response = await backendDio.get('/order/tradeHistory',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    final orders =
        (response.data as List).map((json) => Order.fromJson(json)).toList();
    orders.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return orders;
  }
  return [];
}
