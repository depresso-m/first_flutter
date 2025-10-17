import 'package:flutter/material.dart';


import '../features/shop/models/cart_item.dart';
import '../features/shop/models/medicine.dart';
import '../features/shop/models/order.dart';
import '../features/shop/screens/cart_screen.dart';
import '../features/shop/screens/medicines_screen.dart';
import '../features/shop/screens/orders_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<CartItem> cart = [];
  List<Order> orders = [];

  final List<Medicine> medicines = [
    Medicine(name: 'Парацетамол', price: 120),
    Medicine(name: 'Ибупрофен', price: 150),
    Medicine(name: 'Аспирин', price: 90),
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
    final total = cart.fold(0.0, (sum, item) => sum + item.medicine.price * item.quantity);
    setState(() {
      orders.add(Order(items: List.from(cart), total: total, address: address, date: DateTime.now()));
      cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      MedicinesScreen(medicines: medicines, onAdd: addToCart),
      CartScreen(cart: cart, onOrder: makeOrder),
      OrdersScreen(orders: orders),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Аптека')),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_pharmacy), label: 'Лекарства'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Заказы'),
        ],
      ),
    );
  }
}


