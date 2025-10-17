import 'cart_item.dart';

class Order {
  final List<CartItem> items;
  final double total;
  final String address;
  final DateTime date;

  Order({
    required this.items,
    required this.total,
    required this.address,
    required this.date,
  });
}
