import '../../interfaces/repositories/cart_repository.dart';

class ClearCartUseCase {
  final CartRepository _repository;

  ClearCartUseCase(this._repository);

  Future<void> execute() async {
    await _repository.clearCart();
  }
}
