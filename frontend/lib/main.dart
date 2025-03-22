import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_trade/main.gr.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mock_trade/src/pages/trade/providers/open_orders_provider.dart';
import 'package:mock_trade/src/pages/trade/providers/trade_history_provider.dart';
import 'package:mock_trade/src/pages/wallet/providers/balances_provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'firebase_options.dart';
import 'src/providers.dart';
import 'src/utils/auth_guard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  usePathUrlStrategy();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (previous, user) async {
      final prevUser = previous?.valueOrNull;
      final curUser = user.valueOrNull;
      final pusher = await ref.watch(pusherProvider.future);
      if (prevUser != null) {
        pusher.unsubscribe(channelName: prevUser.uid);
        print('Unsubscribed from channel: ${prevUser.uid}');
      }
      if (curUser != null) {
        pusher.subscribe(
            channelName: curUser.uid,
            onEvent: (event) {
              if (event is PusherEvent) {
                switch (event.eventName) {
                  case 'order':
                    ref.invalidate(openOrdersProvider);
                    if (jsonDecode(event.data)['status'] == 'FILLED') {
                      ref.invalidate(tradeHistoryProvider);
                    }
                  case 'balance':
                    ref.invalidate(balancesProvider);
                  default:
                    break;
                }
              }
            });
        print('Subscribed to channel: ${curUser.uid}');
      }
    });
    return MaterialApp.router(
      title: 'Mock Trade',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: AppRouter(ref).config(),
    );
  }
}

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  WidgetRef _ref;

  AppRouter(this._ref) : super();
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SignInRoute.page, path: '/sign-in'),
        AutoRoute(page: MyHomeRoute.page, path: '/', children: [
          RedirectRoute(path: '', redirectTo: 'wallet'),
          AutoRoute(
            page: WalletRoute.page,
            path: 'wallet',
            initial: true,
          ),
          AutoRoute(page: MarketRoute.page, path: 'market/:quoteAsset'),
        ]),
        AutoRoute(
            page: TradeRoute.page,
            path: '/trade/:symbol',
            guards: [AuthGuard(_ref)]),
      ];
}

@RoutePage()
class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoTabsScaffold(
      routes: [
        WalletRoute(),
        MarketRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Markets',
            ),
          ],
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
        );
      },
    );
  }
}
