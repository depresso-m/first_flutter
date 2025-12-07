import 'cart_item.dart';

class Order {
  final List<CartItem> items;
  final double total;
  final double finalTotal;
  final int pointsUsed;
  final int pointsEarned;
  final String address;
  final DateTime date;

  Order({
    required this.items,
    required this.total,
    required this.finalTotal,
    this.pointsUsed = 0,
    this.pointsEarned = 0,
    required this.address,
    required this.date,
  });
}
