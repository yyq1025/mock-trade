import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers.dart';
import '../models/balance.dart';

part 'balances_provider.g.dart';

@riverpod
Future<List<Balance>> balances(Ref ref) async {
  final user = ref.read(authStateProvider).valueOrNull;
  final token = await user?.getIdToken();
  final backendDio = ref.read(backendDioProvider);
  if (token != null) {
    final response = await backendDio.get('/user',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    final balances = (response.data['balances'] as List)
        .map((json) => Balance.fromJson(json))
        .toList();
    return balances;
  }
  return [];
}
