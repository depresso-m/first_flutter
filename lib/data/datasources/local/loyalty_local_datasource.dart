import '../../../core/models/loyalty_state.dart';
import '../../../core/models/loyalty_transaction.dart';

abstract class LoyaltyLocalDataSource {
  Future<LoyaltyState> getLoyaltyState();
  Future<LoyaltyState> addPoints(int points, String description);
  Future<LoyaltyState> spendPoints(int points, String description);
}

class LoyaltyLocalDataSourceImpl implements LoyaltyLocalDataSource {
  LoyaltyState _state = const LoyaltyState();

  @override
  Future<LoyaltyState> getLoyaltyState() async {
    return _state;
  }

  @override
  Future<LoyaltyState> addPoints(int points, String description) async {
    if (points <= 0) return _state;

    final transaction = LoyaltyTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      points: points,
      description: description,
      date: DateTime.now(),
      type: TransactionType.earned,
    );

    _state = _state.copyWith(
      totalPoints: _state.totalPoints + points,
      transactions: [transaction, ..._state.transactions],
    );

    return _state;
  }

  @override
  Future<LoyaltyState> spendPoints(int points, String description) async {
    if (points <= 0 || points > _state.totalPoints) return _state;

    final transaction = LoyaltyTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      points: points,
      description: description,
      date: DateTime.now(),
      type: TransactionType.spent,
    );

    _state = _state.copyWith(
      totalPoints: _state.totalPoints - points,
      transactions: [transaction, ..._state.transactions],
    );

    return _state;
  }
}
