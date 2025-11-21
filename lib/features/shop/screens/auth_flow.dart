import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'register_screen.dart';

class AuthFlow extends StatelessWidget {
  const AuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'login',
      onGenerateRoute: (settings) {
        late final Widget page;

        switch (settings.name) {
          case 'register':
            page = const RegisterScreen();
            break;
          case 'login':
          default:
            page = const LoginScreen();
            break;
        }

        return MaterialPageRoute<void>(
          builder: (_) => page,
          settings: settings,
        );
      },
    );
  }
}
