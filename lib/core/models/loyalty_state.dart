import 'loyalty_transaction.dart';

class LoyaltyState {
  final int totalPoints;
  final List<LoyaltyTransaction> transactions;

  const LoyaltyState({
    this.totalPoints = 0,
    this.transactions = const [],
  });

  static const double pointsPercentage = 0.05;

  bool get hasPoints => totalPoints > 0;

  bool get hasTransactions => transactions.isNotEmpty;

  bool canSpendPoints(int points) => points <= totalPoints && points > 0;

  int calculatePointsFromOrder(double orderTotal) {
    return (orderTotal * pointsPercentage).round();
  }

  double calculateDiscount(int pointsToUse) {
    if (pointsToUse > totalPoints) return 0;
    return pointsToUse.toDouble();
  }

  String get totalPointsFormatted {
    final suffix = _getPointsSuffix(totalPoints);
    return '$totalPoints $suffix';
  }

  static String _getPointsSuffix(int points) {
    final absPoints = points.abs();
    if (absPoints % 100 >= 11 && absPoints % 100 <= 19) {
      return 'баллов';
    }
    switch (absPoints % 10) {
      case 1:
        return 'балл';
      case 2:
      case 3:
      case 4:
        return 'балла';
      default:
        return 'баллов';
    }
  }

  LoyaltyState copyWith({
    int? totalPoints,
    List<LoyaltyTransaction>? transactions,
  }) {
    return LoyaltyState(
      totalPoints: totalPoints ?? this.totalPoints,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoyaltyState &&
          runtimeType == other.runtimeType &&
          totalPoints == other.totalPoints &&
          transactions.length == other.transactions.length;

  @override
  int get hashCode => totalPoints.hashCode ^ transactions.length.hashCode;

  @override
  String toString() =>
      'LoyaltyState(totalPoints: $totalPoints, transactions: ${transactions.length})';
}
