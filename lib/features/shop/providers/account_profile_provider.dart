import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/auth_account.dart';
import 'auth_provider.dart';

part 'account_profile_provider.g.dart';

class AccountProfile {
  const AccountProfile(this.account);

  final AuthAccount? account;

  String get fullName {
    final acc = account;
    if (acc == null) return 'Пользователь';

    final parts = [
      if ((acc.firstName ?? '').isNotEmpty) acc.firstName,
      if ((acc.lastName ?? '').isNotEmpty) acc.lastName,
    ].whereType<String>().toList();

    if (parts.isEmpty) return acc.email;
    return parts.join(' ');
  }
}

@Riverpod(keepAlive: true)
class AccountProfileNotifier extends _$AccountProfileNotifier {
  @override
  AccountProfile build() {
    final account = ref.watch(authControllerProvider);
    return AccountProfile(account);
  }
}

