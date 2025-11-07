import 'package:flutter/material.dart';

import '../features/shop/models/cart_item.dart';
import '../features/shop/models/medicine.dart';
import '../features/shop/models/order.dart';

class AppState extends ChangeNotifier {
  List<CartItem> _cart = [];
  List<Order> _orders = [];
  final Set<Medicine> _favourites = {};

  final List<Medicine> medicines = [
    Medicine(
      name: 'Парацетамол',
      price: 120,
      imageUrl:
          "https://cdn.eapteka.ru/upload/offer_photo/234/898/1_7e5109f0fb5a68c6dc68fd151df84d1a.png?t=1634213074&_cvc=1760108554",
    ),
    Medicine(
      name: 'Ибупрофен',
      price: 150,
      imageUrl:
          "https://ozerki.ru/_next/image/?url=https%3A%2F%2Fozerki.ru%2Fer-pics%2Fimages%2Fgoods%2F77719%2Fmain&w=768&q=90",
    ),
    Medicine(
      name: 'Аспирин',
      price: 90,
      imageUrl:
          "https://evropharm.ru/Storage/Resized/w_480/aspirin-bajer-0-5-n20.jpg",
    ),
    Medicine(
      name: 'Азитромицин',
      price: 70,
      imageUrl:
          "https://evropharm.ru/Storage/azitromicin-500-mg-N3-tabl-verteks.jpg",
    ),
    Medicine(
      name: 'Черника Форте',
      price: 90,
      imageUrl:
          "https://cdn.eapteka.ru/upload/offer_photo/209/604/resized/450_450_1_2a2eb8f6df8c079a54c210b8ae3db676.png?t=1727348871&_cvc=1760730070",
    ),
  ];

  List<CartItem> get cart => List.unmodifiable(_cart);

  List<Order> get orders => List.unmodifiable(_orders);

  Set<Medicine> get favourites => Set.unmodifiable(_favourites);

  void addToCart(Medicine med) {
    final existing = _cart.where((item) => item.medicine == med).toList();
    if (existing.isNotEmpty) {
      existing.first.quantity++;
    } else {
      _cart.add(CartItem(medicine: med));
    }
    notifyListeners();
  }

  void updateCartItemQuantity(CartItem item, int quantity) {
    final index = _cart.indexOf(item);
    if (index == -1) return;

    if (quantity <= 0) {
      _cart.removeAt(index);
    } else {
      _cart[index].quantity = quantity;
    }
    notifyListeners();
  }

  void makeOrder(String fullName, String email, String phone, String address) {
    final total = _cart.fold(
      0.0,
      (sum, item) => sum + item.medicine.price * item.quantity,
    );
    _orders.add(
      Order(
        items: List.from(_cart),
        total: total,
        address: address,
        date: DateTime.now(),
      ),
    );
    _cart.clear();
    notifyListeners();
  }

  void toggleFavourite(Medicine med) {
    if (_favourites.contains(med)) {
      _favourites.remove(med);
    } else {
      _favourites.add(med);
    }
    notifyListeners();
  }

  bool isFavourite(Medicine med) {
    return _favourites.contains(med);
  }
}
