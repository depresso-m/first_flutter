import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/order.dart';
import 'cart_provider.dart';
import 'loyalty_provider.dart';

part 'orders_provider.g.dart';

@Riverpod(keepAlive: true)
class OrdersNotifier extends _$OrdersNotifier {
  @override
  List<Order> build() => [];

  void makeOrder(
    String fullName,
    String email,
    String phone,
    String address, {
    int pointsToUse = 0,
  }) {
    final cart = ref.read(cartNotifierProvider);
    final total = cart.fold(
      0.0,
      (sum, item) => sum + item.medicine.price * item.quantity,
    );

    // Вычисляем финальную сумму с учётом баллов
    final discount = pointsToUse.toDouble(); // 1 балл = 1 рубль
    final finalTotal = (total - discount).clamp(0.0, total);

    // Начисляем баллы только на оплаченную деньгами часть
    final pointsEarned = (finalTotal * LoyaltyNotifier.pointsPercentage).round();

    final orders = List<Order>.from(state);
    orders.add(
      Order(
        items: List.from(cart),
        total: total,
        finalTotal: finalTotal,
        pointsUsed: pointsToUse,
        pointsEarned: pointsEarned,
        address: address,
        date: DateTime.now(),
      ),
    );
    state = orders;

    // Списываем баллы
    if (pointsToUse > 0) {
      ref.read(loyaltyNotifierProvider.notifier).spendPoints(
            pointsToUse,
            'Оплата заказа на ${total.toStringAsFixed(0)} ₽',
          );
    }

    // Начисляем баллы лояльности (5% от оплаченной суммы)
    ref.read(loyaltyNotifierProvider.notifier).addPointsFromOrder(finalTotal);

    // Очищаем корзину после создания заказа
    ref.read(cartNotifierProvider.notifier).clearCart();
  }
}
