import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_trade/main.gr.dart';
import './auth_providers.dart';

class AuthGuard extends AutoRouteGuard {
  final WidgetRef ref;

  AuthGuard(this.ref);
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final user = ref.watch(userStateChangesProvider);

    user.when(
      data: (user) {
        if (user != null) {
          resolver.next(true);
        } else {
          router.push(SignInRoute());
        }
      },
      loading: () => resolver.next(false),
      error: (error, stackTrace) {
        print('Error: $error');
        resolver.next(false);
      },
    );
  }
}
