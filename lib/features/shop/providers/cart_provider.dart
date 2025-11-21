import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/cart_item.dart';
import '../models/medicine.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  @override
  List<CartItem> build() => [];

  void addToCart(Medicine med) {
    final cart = List<CartItem>.from(state);
    final existing = cart.where((item) => item.medicine == med).toList();
    if (existing.isNotEmpty) {
      final index = cart.indexOf(existing.first);
      cart[index] = CartItem(medicine: med, quantity: cart[index].quantity + 1);
    } else {
      cart.add(CartItem(medicine: med));
    }
    state = cart;
  }

  void updateCartItemQuantity(CartItem item, int quantity) {
    final cart = List<CartItem>.from(state);
    final index = cart.indexWhere(
      (cartItem) => cartItem.medicine == item.medicine,
    );
    if (index == -1) return;

    if (quantity <= 0) {
      cart.removeAt(index);
    } else {
      cart[index] = CartItem(medicine: item.medicine, quantity: quantity);
    }
    state = cart;
  }

  void clearCart() {
    state = [];
  }
}



