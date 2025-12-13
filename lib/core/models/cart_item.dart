import 'medicine.dart';

class CartItem {
  final Medicine medicine;
  final int quantity;

  CartItem({
    required this.medicine,
    this.quantity = 1,
  }) {
    if (quantity < 1) {
      throw ArgumentError('Количество товара должно быть больше 0');
    }
  }

  double get totalPrice => medicine.price * quantity;

  String get totalPriceFormatted => '${totalPrice.toStringAsFixed(2)} ₽';

  CartItem copyWith({
    Medicine? medicine,
    int? quantity,
  }) {
    return CartItem(
      medicine: medicine ?? this.medicine,
      quantity: quantity ?? this.quantity,
    );
  }

  CartItem increment() => copyWith(quantity: quantity + 1);

  CartItem decrement() {
    if (quantity <= 1) {
      throw StateError('Нельзя уменьшить количество ниже 1');
    }
    return copyWith(quantity: quantity - 1);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          medicine == other.medicine;

  @override
  int get hashCode => medicine.hashCode;

  @override
  String toString() =>
      'CartItem(medicine: ${medicine.name}, quantity: $quantity)';
}
