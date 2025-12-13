import '../../../core/models/order.dart';
import '../../interfaces/repositories/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<List<Order>> execute() async {
    return await _repository.getAllOrders();
  }
}
