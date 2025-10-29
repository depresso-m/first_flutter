import 'package:flutter/material.dart';

import '../features/shop/models/cart_item.dart';
import '../features/shop/models/medicine.dart';
import '../features/shop/models/order.dart';
import '../features/shop/screens/cart_screen.dart';
import '../features/shop/screens/medicines_screen.dart';
import '../features/shop/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final List<Medicine> medicines;
  final List<CartItem> cart;
  final List<Order> orders;
  final Set<Medicine> favourites;
  final void Function(Medicine) onAddToCart;
  final void Function(String) onMakeOrder;
  final void Function(Medicine) onToggleFavourite;
  final void Function(int)? onTabChange;
  final VoidCallback? onOpenOrders;
  final VoidCallback? onOpenFavourites;

  const MainScreen({
    super.key,
    this.initialIndex = 0,
    required this.medicines,
    required this.cart,
    required this.orders,
    required this.favourites,
    required this.onAddToCart,
    required this.onMakeOrder,
    required this.onToggleFavourite,
    this.onTabChange,
    this.onOpenOrders,
    this.onOpenFavourites,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final profileBody = ProfileScreen(
      onOpenOrders: () => widget.onOpenOrders?.call(),
      onOpenFavourites: () => widget.onOpenFavourites?.call(),
    );

    final screens = [
      MedicinesScreen(
        medicines: widget.medicines,
        onAdd: widget.onAddToCart,
        favourites: widget.favourites,
        onToggleFavourite: widget.onToggleFavourite,
      ),
      CartScreen(cart: widget.cart, onOrder: widget.onMakeOrder),
      profileBody,
    ];

    String appBarTitle;
    if (_selectedIndex == 0) {
      appBarTitle = 'Аптека';
    } else if (_selectedIndex == 1) {
      appBarTitle = 'Корзина';
    } else {
      appBarTitle = 'Профиль';
    }

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) {
          if (i == _selectedIndex) return;
          widget.onTabChange?.call(i);
        },
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
