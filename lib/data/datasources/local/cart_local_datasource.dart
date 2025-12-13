import '../../../core/models/cart_item.dart';
import '../../../core/models/medicine.dart';

abstract class CartLocalDataSource {
  Future<List<CartItem>> getCartItems();
  Future<void> addToCart(Medicine medicine);
  Future<void> updateQuantity(String medicineId, int quantity);
  Future<void> removeFromCart(String medicineId);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final List<CartItem> _cart = [];

  @override
  Future<List<CartItem>> getCartItems() async {
    return List.from(_cart);
  }

  @override
  Future<void> addToCart(Medicine medicine) async {
    final existingIndex = _cart.indexWhere((item) => item.medicine.id == medicine.id);

    if (existingIndex >= 0) {
      final existing = _cart[existingIndex];
      _cart[existingIndex] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      _cart.add(CartItem(medicine: medicine));
    }
  }

  @override
  Future<void> updateQuantity(String medicineId, int quantity) async {
    final index = _cart.indexWhere((item) => item.medicine.id == medicineId);
    if (index >= 0) {
      if (quantity <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index] = _cart[index].copyWith(quantity: quantity);
      }
    }
  }

  @override
  Future<void> removeFromCart(String medicineId) async {
    _cart.removeWhere((item) => item.medicine.id == medicineId);
  }

  @override
  Future<void> clearCart() async {
    _cart.clear();
  }
}
