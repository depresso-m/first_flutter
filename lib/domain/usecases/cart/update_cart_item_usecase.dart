import '../../interfaces/repositories/cart_repository.dart';

class UpdateCartItemUseCase {
  final CartRepository _repository;

  UpdateCartItemUseCase(this._repository);

  Future<void> execute(String medicineId, int quantity) async {
    if (quantity <= 0) {
      await _repository.removeFromCart(medicineId);
    } else {
      await _repository.updateQuantity(medicineId, quantity);
    }
  }
}
