import '../../interfaces/repositories/cart_repository.dart';

class GetCartTotalUseCase {
  final CartRepository _repository;

  GetCartTotalUseCase(this._repository);

  Future<double> execute() async {
    return await _repository.getCartTotal();
  }
}
