import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_trade/main.gr.dart';
import '../providers.dart';

class AuthGuard extends AutoRouteGuard {
  final WidgetRef ref;

  AuthGuard(this.ref);
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final user = ref.read(authStateProvider).valueOrNull;

    if (user != null) {
      resolver.next(true);
    } else {
      resolver.redirect(SignInRoute(onResult: (success) {
        resolver.next(success);
      }));
    }
  }
}
