import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/loyalty_transaction.dart';

part 'loyalty_provider.g.dart';

class LoyaltyState {
  final int totalPoints;
  final List<LoyaltyTransaction> transactions;

  const LoyaltyState({
    this.totalPoints = 0,
    this.transactions = const [],
  });

  LoyaltyState copyWith({
    int? totalPoints,
    List<LoyaltyTransaction>? transactions,
  }) {
    return LoyaltyState(
      totalPoints: totalPoints ?? this.totalPoints,
      transactions: transactions ?? this.transactions,
    );
  }
}

@Riverpod(keepAlive: true)
class LoyaltyNotifier extends _$LoyaltyNotifier {
  static const double pointsPercentage = 0.05; // 5% от суммы заказа

  @override
  LoyaltyState build() => const LoyaltyState();

  void addPointsFromOrder(double orderTotal) {
    final pointsEarned = (orderTotal * pointsPercentage).round();
    if (pointsEarned <= 0) return;

    final transaction = LoyaltyTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      points: pointsEarned,
      description: 'Начисление за заказ на ${orderTotal.toStringAsFixed(0)} ₽',
      date: DateTime.now(),
      type: TransactionType.earned,
    );

    state = state.copyWith(
      totalPoints: state.totalPoints + pointsEarned,
      transactions: [transaction, ...state.transactions],
    );
  }

  bool spendPoints(int points, String description) {
    if (points > state.totalPoints) return false;

    final transaction = LoyaltyTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      points: points,
      description: description,
      date: DateTime.now(),
      type: TransactionType.spent,
    );

    state = state.copyWith(
      totalPoints: state.totalPoints - points,
      transactions: [transaction, ...state.transactions],
    );
    return true;
  }
}

