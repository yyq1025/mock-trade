import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_trade/main.gr.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/utils/auth_guard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  usePathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        AutoRoute(page: MyHomeRoute.page, initial: true, guards: [
          AuthGuard(_ref)
        ], children: [
          RedirectRoute(path: '', redirectTo: 'wallet'),
          AutoRoute(
              page: WalletRoute.page,
              path: 'wallet',
              guards: [AuthGuard(_ref)]),
          AutoRoute(
              page: MarketRoute.page,
              path: 'market/:quoteAsset',
              guards: [AuthGuard(_ref)]),
        ]),
        AutoRoute(
            page: TradeRoute.page,
            path: '/trade/:symbol',
            guards: [AuthGuard(_ref)]),
      ];
}

@RoutePage()
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
