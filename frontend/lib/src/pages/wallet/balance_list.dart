import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/balances_provider.dart';

class BalanceList extends ConsumerWidget {
  const BalanceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balances = ref.watch(balancesProvider).valueOrNull;
    return balances == null
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () => ref.refresh(balancesProvider.future),
            child: ListView.separated(
              itemCount: balances.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final balance = balances[index];
                return ListTile(
                  title: Text(balance.asset),
                  subtitle: Text((balance.free + balance.locked).toString()),
                );
              },
            ),
          );
  }
}
