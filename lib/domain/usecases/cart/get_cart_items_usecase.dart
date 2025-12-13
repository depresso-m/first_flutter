import '../../../core/models/cart_item.dart';
import '../../interfaces/repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository _repository;

  GetCartItemsUseCase(this._repository);

  Future<List<CartItem>> execute() async {
    return await _repository.getCartItems();
  }
}
