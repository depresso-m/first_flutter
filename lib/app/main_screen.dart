import 'package:flutter/material.dart';

import '../features/shop/models/cart_item.dart';
import '../features/shop/models/medicine.dart';
import '../features/shop/models/order.dart';
import '../features/shop/screens/cart_screen.dart';
import '../features/shop/screens/favourites_screen.dart';
import '../features/shop/screens/medicines_screen.dart';
import '../features/shop/screens/orders_screen.dart';
import '../features/shop/screens/profile_screen.dart';

enum ProfileSubpage { none, orders, favourites }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<CartItem> cart = [];
  List<Order> orders = [];
  final Set<Medicine> favourites = {};

  ProfileSubpage _profileSubpage = ProfileSubpage.none;

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

  void addToCart(Medicine med) {
    setState(() {
      final existing = cart.where((item) => item.medicine == med).toList();
      if (existing.isNotEmpty) {
        existing.first.quantity++;
      } else {
        cart.add(CartItem(medicine: med));
      }
    });
  }

  void makeOrder(String address) {
    final total = cart.fold(
      0.0,
      (sum, item) => sum + item.medicine.price * item.quantity,
    );
    setState(() {
      orders.add(
        Order(
          items: List.from(cart),
          total: total,
          address: address,
          date: DateTime.now(),
        ),
      );
      cart.clear();
    });
  }

  void toggleFavourite(Medicine med) {
    setState(() {
      if (favourites.contains(med)) {
        favourites.remove(med);
      } else {
        favourites.add(med);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget profileBody;
    if (_profileSubpage == ProfileSubpage.none) {
      profileBody = ProfileScreen(
        onShowOrders: () =>
            setState(() => _profileSubpage = ProfileSubpage.orders),
        onShowFavourites: () =>
            setState(() => _profileSubpage = ProfileSubpage.favourites),
      );
    } else if (_profileSubpage == ProfileSubpage.orders) {
      profileBody = OrdersScreen(orders: orders);
    } else {
      profileBody = FavouritesScreen(
        favourites: favourites,
        onToggleFavourite: toggleFavourite,
        onAdd: addToCart,
      );
    }

    final screens = [
      MedicinesScreen(
        medicines: medicines,
        onAdd: addToCart,
        favourites: favourites,
        onToggleFavourite: toggleFavourite,
      ),
      CartScreen(cart: cart, onOrder: makeOrder),
      profileBody,
    ];

    final bool showBackInProfile =
        _selectedIndex == 2 && _profileSubpage != ProfileSubpage.none;
    String appBarTitle;
    if (_selectedIndex == 0) {
      appBarTitle = 'Аптека';
    } else if (_selectedIndex == 1) {
      appBarTitle = 'Корзина';
    } else {
      if (_profileSubpage == ProfileSubpage.none) {
        appBarTitle = 'Профиль';
      } else if (_profileSubpage == ProfileSubpage.orders) {
        appBarTitle = 'История покупок';
      } else {
        appBarTitle = 'Избранное';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: showBackInProfile
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () =>
                    setState(() => _profileSubpage = ProfileSubpage.none),
              )
            : null,
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() {
          _selectedIndex = i;
          if (_selectedIndex != 2) {
            _profileSubpage = ProfileSubpage.none;
          }
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy),
            label: 'Лекарства',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}
