import '../../../core/exceptions/app_exception.dart';
import '../../../core/models/loyalty_state.dart';
import '../../interfaces/repositories/loyalty_repository.dart';

class SpendPointsUseCase {
  final LoyaltyRepository _repository;

  SpendPointsUseCase(this._repository);

  Future<LoyaltyState> execute(int points, String description) async {
    if (points <= 0) {
      throw ValidationException.insufficientPoints();
    }

    final canSpend = await _repository.canSpendPoints(points);
    if (!canSpend) {
      throw ValidationException.insufficientPoints();
    }

    return await _repository.spendPoints(points, description);
  }
}
