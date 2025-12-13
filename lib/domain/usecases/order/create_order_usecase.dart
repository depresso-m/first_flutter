import '../../../core/models/cart_item.dart';
import '../../../core/models/loyalty_state.dart';
import '../../../core/models/order.dart';
import '../../interfaces/repositories/cart_repository.dart';
import '../../interfaces/repositories/loyalty_repository.dart';
import '../../interfaces/repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository _orderRepository;
  final CartRepository _cartRepository;
  final LoyaltyRepository _loyaltyRepository;

  CreateOrderUseCase(
    this._orderRepository,
    this._cartRepository,
    this._loyaltyRepository,
  );

  Future<Order> execute({
    required String address,
    int pointsToUse = 0,
  }) async {
    final cartItems = await _cartRepository.getCartItems();
    if (cartItems.isEmpty) {
      throw ArgumentError('Корзина пуста');
    }

    final total = await _cartRepository.getCartTotal();

    final discount = pointsToUse.toDouble();
    final finalTotal = (total - discount).clamp(0.0, total);

    final pointsEarned =
        (finalTotal * LoyaltyState.pointsPercentage).round();

    final order = await _orderRepository.createOrder(
      items: List<CartItem>.from(cartItems),
      total: total,
      finalTotal: finalTotal,
      address: address,
      pointsUsed: pointsToUse,
      pointsEarned: pointsEarned,
    );

    if (pointsToUse > 0) {
      await _loyaltyRepository.spendPoints(
        pointsToUse,
        'Оплата заказа на ${total.toStringAsFixed(0)} ₽',
      );
    }

    await _loyaltyRepository.addPointsFromOrder(finalTotal);

    await _cartRepository.clearCart();

    return order;
  }
}
