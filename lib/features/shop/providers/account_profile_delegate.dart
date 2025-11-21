import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/auth_account.dart';
import 'auth_provider.dart';

part 'account_profile_delegate.g.dart';

class AccountProfileSnapshot {
  const AccountProfileSnapshot(this.account);

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
class AccountProfileDelegate extends _$AccountProfileDelegate {
  @override
  AccountProfileSnapshot build() {
    final account = ref.watch(authControllerProvider);
    return AccountProfileSnapshot(account);
  }
}
