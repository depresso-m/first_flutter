import 'cartItem.dart';

enum OrderStatus { received, formed, assembled, handed }

class Order {
  final List<CartItem> items;
  final double total;
  final String address;
  final DateTime date;

  static const Duration receivedDuration = Duration(seconds: 15);
  static const Duration formedDuration = Duration(seconds: 30);
  static const Duration assembledDuration = Duration(seconds: 30);

  Order({required this.items, required this.total, required this.address, required this.date});

  OrderStatus getStatusAt(DateTime now) {
    final elapsed = now.difference(date);
    if (elapsed < receivedDuration) return OrderStatus.received;
    if (elapsed < receivedDuration + formedDuration) return OrderStatus.formed;
    if (elapsed < receivedDuration + formedDuration + assembledDuration) return OrderStatus.assembled;
    return OrderStatus.handed;
  }

  double getProgressAt(DateTime now) {
    final elapsed = now.difference(date);
    final totalDuration = receivedDuration + formedDuration + assembledDuration;
    if (elapsed.isNegative) return 0.0;
    if (elapsed >= totalDuration) return 1.0;
    return (elapsed.inMilliseconds / totalDuration.inMilliseconds).clamp(0.0, 1.0);
  }
}