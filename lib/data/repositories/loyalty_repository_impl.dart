import '../../core/models/loyalty_state.dart';
import '../../core/models/loyalty_transaction.dart';
import '../../domain/interfaces/repositories/loyalty_repository.dart';
import '../datasources/local/loyalty_local_datasource.dart';

class LoyaltyRepositoryImpl implements LoyaltyRepository {
  final LoyaltyLocalDataSource _localDataSource;

  LoyaltyRepositoryImpl({required LoyaltyLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<LoyaltyState> getLoyaltyState() async {
    return await _localDataSource.getLoyaltyState();
  }

  @override
  Future<int> getTotalPoints() async {
    final state = await getLoyaltyState();
    return state.totalPoints;
  }

  @override
  Future<List<LoyaltyTransaction>> getTransactions() async {
    final state = await getLoyaltyState();
    return state.transactions;
  }

  @override
  Future<LoyaltyState> addPointsFromOrder(double orderTotal) async {
    final pointsEarned = (orderTotal * LoyaltyState.pointsPercentage).round();
    if (pointsEarned <= 0) return await getLoyaltyState();

    return await _localDataSource.addPoints(
      pointsEarned,
      'Начисление за заказ на ${orderTotal.toStringAsFixed(0)} ₽',
    );
  }

  @override
  Future<LoyaltyState> spendPoints(int points, String description) async {
    return await _localDataSource.spendPoints(points, description);
  }

  @override
  Future<bool> canSpendPoints(int points) async {
    final state = await getLoyaltyState();
    return state.canSpendPoints(points);
  }
}
