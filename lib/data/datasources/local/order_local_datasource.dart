import '../../../core/models/cart_item.dart';
import '../../../core/models/order.dart';

abstract class OrderLocalDataSource {
  Future<List<Order>> getAllOrders();
  Future<Order?> getOrderById(String id);
  Future<Order> createOrder({
    required List<CartItem> items,
    required double total,
    required double finalTotal,
    required String address,
    int pointsUsed,
    int pointsEarned,
  });
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final List<Order> _orders = [];

  @override
  Future<List<Order>> getAllOrders() async {
    return List.from(_orders);
  }

  @override
  Future<Order?> getOrderById(String id) async {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Order> createOrder({
    required List<CartItem> items,
    required double total,
    required double finalTotal,
    required String address,
    int pointsUsed = 0,
    int pointsEarned = 0,
  }) async {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: items,
      total: total,
      finalTotal: finalTotal,
      pointsUsed: pointsUsed,
      pointsEarned: pointsEarned,
      address: address,
      createdAt: DateTime.now(),
    );
    _orders.add(order);
    return order;
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _orders[index] = _orders[index].copyWith(status: status);
    }
  }
}
