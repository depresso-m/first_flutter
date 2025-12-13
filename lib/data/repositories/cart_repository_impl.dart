import '../../core/models/cart_item.dart';
import '../../core/models/medicine.dart';
import '../../domain/interfaces/repositories/cart_repository.dart';
import '../datasources/local/cart_local_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;

  CartRepositoryImpl({required CartLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<List<CartItem>> getCartItems() async {
    return await _localDataSource.getCartItems();
  }

  @override
  Future<void> addToCart(Medicine medicine) async {
    await _localDataSource.addToCart(medicine);
  }

  @override
  Future<void> updateQuantity(String medicineId, int quantity) async {
    await _localDataSource.updateQuantity(medicineId, quantity);
  }

  @override
  Future<void> removeFromCart(String medicineId) async {
    await _localDataSource.removeFromCart(medicineId);
  }

  @override
  Future<void> clearCart() async {
    await _localDataSource.clearCart();
  }

  @override
  Future<double> getCartTotal() async {
    final items = await getCartItems();
    double total = 0.0;
    for (final item in items) {
      total += item.totalPrice;
    }
    return total;
  }

  @override
  Future<int> getCartItemsCount() async {
    final items = await getCartItems();
    int count = 0;
    for (final item in items) {
      count += item.quantity;
    }
    return count;
  }
}
