enum TransactionType { earned, spent }

class LoyaltyTransaction {
  final String id;
  final int points;
  final String description;
  final DateTime date;
  final TransactionType type;

  const LoyaltyTransaction({
    required this.id,
    required this.points,
    required this.description,
    required this.date,
    required this.type,
  });

  bool get isEarned => type == TransactionType.earned;

  bool get isSpent => type == TransactionType.spent;

  String get pointsFormatted {
    final sign = isEarned ? '+' : '-';
    return '$sign$points';
  }

  String get pointsWithSuffix {
    final suffix = _getPointsSuffix(points);
    return '$pointsFormatted $suffix';
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

  LoyaltyTransaction copyWith({
    String? id,
    int? points,
    String? description,
    DateTime? date,
    TransactionType? type,
  }) {
    return LoyaltyTransaction(
      id: id ?? this.id,
      points: points ?? this.points,
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoyaltyTransaction &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'LoyaltyTransaction(id: $id, points: $pointsFormatted, type: $type)';
}
