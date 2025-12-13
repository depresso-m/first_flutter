import '../../../core/models/loyalty_state.dart';
import '../../interfaces/repositories/loyalty_repository.dart';

class GetLoyaltyStateUseCase {
  final LoyaltyRepository _repository;

  GetLoyaltyStateUseCase(this._repository);

  Future<LoyaltyState> execute() async {
    return await _repository.getLoyaltyState();
  }
}
