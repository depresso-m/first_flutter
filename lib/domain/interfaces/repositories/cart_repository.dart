import '../../../core/models/cart_item.dart';
import '../../../core/models/medicine.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();

  Future<void> addToCart(Medicine medicine);

  Future<void> updateQuantity(String medicineId, int quantity);

  Future<void> removeFromCart(String medicineId);

  Future<void> clearCart();

  Future<double> getCartTotal();

  Future<int> getCartItemsCount();
}
