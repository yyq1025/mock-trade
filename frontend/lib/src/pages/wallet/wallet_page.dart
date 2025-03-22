import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_trade/main.gr.dart';

import '../../providers.dart';
import 'balance_list.dart';

@RoutePage()
class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Wallet', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: user != null
                ? BalanceList()
                : const Center(
                    child: Text('Sign in to view balances'),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: user != null
                ? OutlinedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    child: const Text('Sign Out'),
                  )
                : FilledButton(
                    onPressed: () {
                      context.router.push(SignInRoute(onResult: (success) {
                        if (success) {
                          context.router.replace(WalletRoute());
                        }
                      }));
                    },
                    child: const Text('Sign In'),
                  ),
          ),
        ],
      ),
    );
  }
}
