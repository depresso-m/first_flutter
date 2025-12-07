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
}

enum TransactionType {
  earned,
  spent,
}

