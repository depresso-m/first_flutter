import '../../../core/models/medicine.dart';
import '../../interfaces/repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository _repository;

  AddToCartUseCase(this._repository);

  Future<void> execute(Medicine medicine) async {
    await _repository.addToCart(medicine);
  }
}
