import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'router.dart';

class MainScreen extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const MainScreen({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  static const _routes = [
    AppRoutes.home,
    AppRoutes.cart,
    AppRoutes.profile,
  ];

  static const _titles = ['Аптека', 'Корзина', 'Профиль'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[currentIndex]),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => context.go(_routes[index]),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy),
            label: 'Лекарства',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
