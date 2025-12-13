import '../../../core/models/cart_item.dart';
import '../../../core/models/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getAllOrders();

  Future<Order?> getOrderById(String id);

  Future<Order> createOrder({
    required List<CartItem> items,
    required double total,
    required double finalTotal,
    required String address,
    int pointsUsed = 0,
    int pointsEarned = 0,
  });

  Future<void> updateOrderStatus(String orderId, OrderStatus status);

  Future<List<Order>> getOrdersByStatus(OrderStatus status);
}
