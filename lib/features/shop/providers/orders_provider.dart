import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/order.dart';
import 'cart_provider.dart';

part 'orders_provider.g.dart';

@Riverpod(keepAlive: true)
class OrdersNotifier extends _$OrdersNotifier {
  @override
  List<Order> build() => [];

  void makeOrder(String fullName, String email, String phone, String address) {
    final cart = ref.read(cartNotifierProvider);
    final total = cart.fold(
      0.0,
      (sum, item) => sum + item.medicine.price * item.quantity,
    );
    final orders = List<Order>.from(state);
    orders.add(
      Order(
        items: List.from(cart),
        total: total,
        address: address,
        date: DateTime.now(),
      ),
    );
    state = orders;
    // Очищаем корзину после создания заказа
    ref.read(cartNotifierProvider.notifier).clearCart();
  }
}
