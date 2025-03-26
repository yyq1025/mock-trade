import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_trade/main.gr.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
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

class _EagerInitialization extends ConsumerStatefulWidget {
  final Widget child;
  const _EagerInitialization({required this.child});

  @override
  _EagerInitializationState createState() => _EagerInitializationState();
}

class _EagerInitializationState extends ConsumerState<_EagerInitialization> {
  late final AppLifecycleListener _listener;
  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onHide: () {
        ref.invalidate(pusherProvider);
        ref.invalidate(binanceWSChannelProvider);
      },
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  Future<void> _maintainBinanceWSConnection() async {
    final (channel, stream) = await ref.watch(binanceWSChannelProvider.future);
    stream.listen((event) {
      if (json.decode(event) == 'ping') {
        channel.sink.add('pong');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(pusherSubProvider);
    _maintainBinanceWSConnection();
    return widget.child;
  }
}

// class _EagerInitialization extends ConsumerWidget {
//   final Widget child;
//   const _EagerInitialization({required this.child});

//   Future<void> _maintainBinanceWSConnection(WidgetRef ref) async {
//     final (channel, stream) = await ref.watch(binanceWSChannelProvider.future);
//     stream.listen((event) {
//       if (json.decode(event) == 'ping') {
//         channel.sink.add('pong');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Eagerly initialize providers by watching them.
//     // By using "watch", the provider will stay alive and not be disposed.
//     ref.watch(pusherSubProvider);
//     _maintainBinanceWSConnection(ref);
//     return child;
//   }
// }

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _EagerInitialization(
        child: MaterialApp.router(
      title: 'Mock Trade',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: AppRouter(ref).config(),
    ));
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
