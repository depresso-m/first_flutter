import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection_container.dart';
import '../../core/models/loyalty_state.dart';
import '../../domain/usecases/loyalty/get_loyalty_state_usecase.dart';
import '../../domain/usecases/loyalty/spend_points_usecase.dart';

final getLoyaltyStateUseCaseProvider = Provider<GetLoyaltyStateUseCase>(
  (ref) => getIt<GetLoyaltyStateUseCase>(),
);

final spendPointsUseCaseProvider = Provider<SpendPointsUseCase>(
  (ref) => getIt<SpendPointsUseCase>(),
);

class LoyaltyNotifier extends StateNotifier<LoyaltyState> {
  final GetLoyaltyStateUseCase _getLoyaltyStateUseCase;
  final SpendPointsUseCase _spendPointsUseCase;

  LoyaltyNotifier({
    required GetLoyaltyStateUseCase getLoyaltyStateUseCase,
    required SpendPointsUseCase spendPointsUseCase,
  })  : _getLoyaltyStateUseCase = getLoyaltyStateUseCase,
        _spendPointsUseCase = spendPointsUseCase,
        super(const LoyaltyState()) {
    _loadState();
  }

  Future<void> _loadState() async {
    state = await _getLoyaltyStateUseCase.execute();
  }

  Future<void> spendPoints(int points, String description) async {
    state = await _spendPointsUseCase.execute(points, description);
  }

  Future<void> refresh() async {
    await _loadState();
  }
}

final loyaltyNotifierProvider =
    StateNotifierProvider<LoyaltyNotifier, LoyaltyState>((ref) {
  return LoyaltyNotifier(
    getLoyaltyStateUseCase: ref.watch(getLoyaltyStateUseCaseProvider),
    spendPointsUseCase: ref.watch(spendPointsUseCaseProvider),
  );
});

final totalPointsProvider = Provider<int>((ref) {
  return ref.watch(loyaltyNotifierProvider).totalPoints;
});
