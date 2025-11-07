import 'package:flutter/material.dart';

import 'app_state_widget.dart';
import '../features/shop/screens/cart_screen.dart';
import '../features/shop/screens/medicines_screen.dart';
import '../features/shop/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateWidget.of(context);

    String appBarTitle;
    if (_selectedIndex == 0) {
      appBarTitle = 'Аптека';
    } else if (_selectedIndex == 1) {
      appBarTitle = 'Корзина';
    } else {
      appBarTitle = 'Профиль';
    }

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final screens = [
          const MedicinesScreen(),
          const CartScreen(),
          const ProfileScreen(),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
          ),
          body: screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (i) => setState(() {
              _selectedIndex = i;
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
      },
    );
  }
}
