import 'package:flutter/material.dart';

import '../features/shop/models/cart_item.dart';
import '../features/shop/models/medicine.dart';
import '../features/shop/models/order.dart';
import '../features/shop/screens/cart_screen.dart';
import '../features/shop/screens/medicines_screen.dart';
import '../features/shop/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final List<CartItem> cart;
  final List<Order> orders;
  final Set<Medicine> favourites;
  final List<Medicine> medicines;
  final Function(Medicine) onAddToCart;
  final Function(String, String, String, String) onMakeOrder;
  final Function(Medicine) onToggleFavourite;

  const MainScreen({
    super.key,
    required this.cart,
    required this.orders,
    required this.favourites,
    required this.medicines,
    required this.onAddToCart,
    required this.onMakeOrder,
    required this.onToggleFavourite,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      MedicinesScreen(
        medicines: widget.medicines,
        onAdd: widget.onAddToCart,
        favourites: widget.favourites,
        onToggleFavourite: widget.onToggleFavourite,
      ),
      CartScreen(cart: widget.cart, onOrder: widget.onMakeOrder),
      ProfileScreen(
        orders: widget.orders,
        favourites: widget.favourites,
        onToggleFavourite: widget.onToggleFavourite,
        onAdd: widget.onAddToCart,
      ),
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
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
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
