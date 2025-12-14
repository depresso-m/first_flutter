import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection_container.dart';
import '../../core/exceptions/app_exception.dart';
import '../../core/models/auth_account.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/update_profile_usecase.dart';

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => getIt<LoginUseCase>(),
);

final registerUseCaseProvider = Provider<RegisterUseCase>(
  (ref) => getIt<RegisterUseCase>(),
);

final logoutUseCaseProvider = Provider<LogoutUseCase>(
  (ref) => getIt<LogoutUseCase>(),
);

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>(
  (ref) => getIt<GetCurrentUserUseCase>(),
);

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>(
  (ref) => getIt<UpdateProfileUseCase>(),
);

class AuthNotifier extends StateNotifier<AuthAccount?> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        super(null) {
    _loadSavedUser();
  }

  Future<void> _loadSavedUser() async {
    state = await _getCurrentUserUseCase.execute();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      state = await _loginUseCase.execute(email: email, password: password);
    } on AuthException {
      rethrow;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    String? firstName,
  }) async {
    try {
      state = await _registerUseCase.execute(
        email: email,
        password: password,
        firstName: firstName,
      );
    } on AuthException {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _logoutUseCase.execute();
    state = null;
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? city,
  }) async {
    state = await _updateProfileUseCase.execute(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      city: city,
    );
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthAccount?>((ref) {
  return AuthNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
    registerUseCase: ref.watch(registerUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    getCurrentUserUseCase: ref.watch(getCurrentUserUseCaseProvider),
    updateProfileUseCase: ref.watch(updateProfileUseCaseProvider),
  );
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider) != null;
});

final currentUserProvider = Provider<AuthAccount?>((ref) {
  return ref.watch(authNotifierProvider);
});
