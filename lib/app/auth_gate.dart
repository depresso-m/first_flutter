import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/shop/providers/auth_provider.dart';
import '../features/shop/screens/auth_flow.dart';
import 'main_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    if (authState != null) {
      return const MainScreen();
    }

    return const AuthFlow();
  }
}
