import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mock_trade/main.gr.dart';

@RoutePage()
class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [
        GoogleProvider(
            clientId:
                '141802804685-3vnt2g3cvfved8mb822tbernk1em33le.apps.googleusercontent.com'),
        // Add other providers if needed
      ],
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) {
          print('User created: $state');
          context.router.replaceAll([WalletRoute()]);
        }),
        AuthStateChangeAction<SignedIn>((context, state) {
          print('Signed in: ${state.user}');
          context.router.replaceAll([WalletRoute()]);
        }),
      ],
    );
  }
}
