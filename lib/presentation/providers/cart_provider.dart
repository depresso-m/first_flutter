import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection_container.dart';
import '../../core/models/cart_item.dart';
import '../../core/models/medicine.dart';
import '../../domain/usecases/cart/add_to_cart_usecase.dart';
import '../../domain/usecases/cart/clear_cart_usecase.dart';
import '../../domain/usecases/cart/get_cart_items_usecase.dart';
import '../../domain/usecases/cart/get_cart_total_usecase.dart';
import '../../domain/usecases/cart/update_cart_item_usecase.dart';

final getCartItemsUseCaseProvider = Provider<GetCartItemsUseCase>(
  (ref) => getIt<GetCartItemsUseCase>(),
);

final addToCartUseCaseProvider = Provider<AddToCartUseCase>(
  (ref) => getIt<AddToCartUseCase>(),
);

final updateCartItemUseCaseProvider = Provider<UpdateCartItemUseCase>(
  (ref) => getIt<UpdateCartItemUseCase>(),
);

final clearCartUseCaseProvider = Provider<ClearCartUseCase>(
  (ref) => getIt<ClearCartUseCase>(),
);

final getCartTotalUseCaseProvider = Provider<GetCartTotalUseCase>(
  (ref) => getIt<GetCartTotalUseCase>(),
);

class CartNotifier extends StateNotifier<List<CartItem>> {
  final GetCartItemsUseCase _getCartItemsUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final UpdateCartItemUseCase _updateCartItemUseCase;
  final ClearCartUseCase _clearCartUseCase;

  CartNotifier({
    required GetCartItemsUseCase getCartItemsUseCase,
    required AddToCartUseCase addToCartUseCase,
    required UpdateCartItemUseCase updateCartItemUseCase,
    required ClearCartUseCase clearCartUseCase,
  })  : _getCartItemsUseCase = getCartItemsUseCase,
        _addToCartUseCase = addToCartUseCase,
        _updateCartItemUseCase = updateCartItemUseCase,
        _clearCartUseCase = clearCartUseCase,
        super([]) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    state = await _getCartItemsUseCase.execute();
  }

  Future<void> addToCart(Medicine medicine) async {
    await _addToCartUseCase.execute(medicine);
    await _loadCart();
  }

  Future<void> updateQuantity(String medicineId, int quantity) async {
    await _updateCartItemUseCase.execute(medicineId, quantity);
    await _loadCart();
  }

  Future<void> clearCart() async {
    await _clearCartUseCase.execute();
    await _loadCart();
  }

  double get total => state.fold(0.0, (sum, item) => sum + item.totalPrice);
}

final cartNotifierProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier(
    getCartItemsUseCase: ref.watch(getCartItemsUseCaseProvider),
    addToCartUseCase: ref.watch(addToCartUseCaseProvider),
    updateCartItemUseCase: ref.watch(updateCartItemUseCaseProvider),
    clearCartUseCase: ref.watch(clearCartUseCaseProvider),
  );
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartNotifierProvider);
  return cart.fold(0.0, (sum, item) => sum + item.totalPrice);
});
