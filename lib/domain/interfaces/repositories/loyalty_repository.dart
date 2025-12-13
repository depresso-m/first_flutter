import '../../../core/models/loyalty_state.dart';
import '../../../core/models/loyalty_transaction.dart';

abstract class LoyaltyRepository {
  Future<LoyaltyState> getLoyaltyState();

  Future<int> getTotalPoints();

  Future<List<LoyaltyTransaction>> getTransactions();

  Future<LoyaltyState> addPointsFromOrder(double orderTotal);

  Future<LoyaltyState> spendPoints(int points, String description);

  Future<bool> canSpendPoints(int points);
}
