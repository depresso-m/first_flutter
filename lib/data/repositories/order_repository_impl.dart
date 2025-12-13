import '../../core/models/cart_item.dart';
import '../../core/models/order.dart';
import '../../domain/interfaces/repositories/order_repository.dart';
import '../datasources/local/order_local_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource _localDataSource;

  OrderRepositoryImpl({required OrderLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<List<Order>> getAllOrders() async {
    return await _localDataSource.getAllOrders();
  }

  @override
  Future<Order?> getOrderById(String id) async {
    return await _localDataSource.getOrderById(id);
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
    return await _localDataSource.createOrder(
      items: items,
      total: total,
      finalTotal: finalTotal,
      address: address,
      pointsUsed: pointsUsed,
      pointsEarned: pointsEarned,
    );
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _localDataSource.updateOrderStatus(orderId, status);
  }

  @override
  Future<List<Order>> getOrdersByStatus(OrderStatus status) async {
    final orders = await getAllOrders();
    return orders.where((o) => o.status == status).toList();
  }
}
