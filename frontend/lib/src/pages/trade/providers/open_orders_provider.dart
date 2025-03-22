import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers.dart';
import '../models/order.dart';

part 'open_orders_provider.g.dart';

@riverpod
class OpenOrders extends _$OpenOrders {
  @override
  Future<List<Order>> build() async {
    final user = ref.read(authStateProvider).valueOrNull;
    final token = await user?.getIdToken();
    final backendDio = ref.read(backendDioProvider);
    if (token != null) {
      final response = await backendDio.get('/order/openOrders',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      final orders =
          (response.data as List).map((json) => Order.fromJson(json)).toList();
      return orders;
    }
    return [];
  }

  Future<void> createOrder(Map<String, dynamic> order) async {
    final user = ref.read(authStateProvider).valueOrNull;
    final token = await user?.getIdToken();
    final backendDio = ref.read(backendDioProvider);
    if (token != null) {
      await backendDio.post('/order',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: order);

      ref.invalidateSelf();
    }
  }

  Future<void> cancelOrder(String orderId) async {
    final user = ref.read(authStateProvider).valueOrNull;
    final token = await user?.getIdToken();
    final backendDio = ref.read(backendDioProvider);
    if (token != null) {
      await backendDio.delete('/order',
          data: {'orderId': orderId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      ref.invalidateSelf();
    }
  }
}
