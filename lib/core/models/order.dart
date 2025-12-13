import 'cart_item.dart';

enum OrderStatus { received, formed, assembled, handed }

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final double finalTotal;
  final int pointsUsed;
  final int pointsEarned;
  final String address;
  final DateTime createdAt;
  final OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.finalTotal,
    this.pointsUsed = 0,
    this.pointsEarned = 0,
    required this.address,
    required this.createdAt,
    this.status = OrderStatus.received,
  }) {
    if (items.isEmpty) {
      throw ArgumentError('Заказ не может быть пустым');
    }
    if (address.trim().isEmpty) {
      throw ArgumentError('Адрес доставки не может быть пустым');
    }
    if (finalTotal < 0) {
      throw ArgumentError('Итоговая сумма не может быть отрицательной');
    }
  }

  static const Duration _receivedDuration = Duration(seconds: 15);
  static const Duration _formedDuration = Duration(seconds: 30);
  static const Duration _assembledDuration = Duration(seconds: 30);

  int get itemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get discount => total - finalTotal;

  bool get hasDiscount => discount > 0;

  String get totalFormatted => '${total.toStringAsFixed(2)} ₽';

  String get finalTotalFormatted => '${finalTotal.toStringAsFixed(2)} ₽';

  String get discountFormatted => '-${discount.toStringAsFixed(2)} ₽';

  OrderStatus getStatusAt(DateTime now) {
    final elapsed = now.difference(createdAt);
    if (elapsed < _receivedDuration) return OrderStatus.received;
    if (elapsed < _receivedDuration + _formedDuration) return OrderStatus.formed;
    if (elapsed < _receivedDuration + _formedDuration + _assembledDuration) {
      return OrderStatus.assembled;
    }
    return OrderStatus.handed;
  }

  double getProgressAt(DateTime now) {
    final elapsed = now.difference(createdAt);
    final totalDuration =
        _receivedDuration + _formedDuration + _assembledDuration;
    if (elapsed.isNegative) return 0.0;
    if (elapsed >= totalDuration) return 1.0;
    return (elapsed.inMilliseconds / totalDuration.inMilliseconds).clamp(
      0.0,
      1.0,
    );
  }

  bool get isCompleted => status == OrderStatus.handed;

  Order copyWith({
    String? id,
    List<CartItem>? items,
    double? total,
    double? finalTotal,
    int? pointsUsed,
    int? pointsEarned,
    String? address,
    DateTime? createdAt,
    OrderStatus? status,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      total: total ?? this.total,
      finalTotal: finalTotal ?? this.finalTotal,
      pointsUsed: pointsUsed ?? this.pointsUsed,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Order(id: $id, items: ${items.length}, total: $finalTotal)';
}
