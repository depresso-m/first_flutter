import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection_container.dart';
import '../../core/models/order.dart';
import '../../domain/usecases/order/create_order_usecase.dart';
import '../../domain/usecases/order/get_orders_usecase.dart';

final getOrdersUseCaseProvider = Provider<GetOrdersUseCase>(
  (ref) => getIt<GetOrdersUseCase>(),
);

final createOrderUseCaseProvider = Provider<CreateOrderUseCase>(
  (ref) => getIt<CreateOrderUseCase>(),
);

class OrdersNotifier extends StateNotifier<List<Order>> {
  final GetOrdersUseCase _getOrdersUseCase;
  final CreateOrderUseCase _createOrderUseCase;

  OrdersNotifier({
    required GetOrdersUseCase getOrdersUseCase,
    required CreateOrderUseCase createOrderUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase,
        _createOrderUseCase = createOrderUseCase,
        super([]) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    state = await _getOrdersUseCase.execute();
  }

  Future<Order> createOrder({
    required String address,
    int pointsToUse = 0,
  }) async {
    final order = await _createOrderUseCase.execute(
      address: address,
      pointsToUse: pointsToUse,
    );
    await _loadOrders();
    return order;
  }
}

final ordersNotifierProvider =
    StateNotifierProvider<OrdersNotifier, List<Order>>((ref) {
  return OrdersNotifier(
    getOrdersUseCase: ref.watch(getOrdersUseCaseProvider),
    createOrderUseCase: ref.watch(createOrderUseCaseProvider),
  );
});
