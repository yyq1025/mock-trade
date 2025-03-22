import 'package:dio/dio.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_trade/src/pages/wallet/providers/balances_provider.dart';

import '../../providers.dart';

@RoutePage()
class SignInPage extends ConsumerWidget {
  final Function(bool) onResult;
  const SignInPage({super.key, required this.onResult});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backendDio = ref.read(backendDioProvider);
    return SignInScreen(
      providers: [
        EmailAuthProvider(),
        GoogleProvider(
            clientId: const String.fromEnvironment('GOOGLE_CLIENT_ID')),
      ],
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) async {
          final token = await state.credential.user!.getIdToken();
          try {
            await backendDio.post('/user',
                options: Options(headers: {
                  'Authorization': 'Bearer $token',
                }));
            ref.invalidate(balancesProvider);
            onResult(true);
          } catch (e) {
            print('Failed to create user: $e');
            onResult(false);
          }
        }),
        AuthStateChangeAction<SignedIn>((context, state) {
          onResult(true);
        }),
      ],
    );
  }
}
