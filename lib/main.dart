import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app/main_screen.dart';
import 'features/shop/models/cart_item.dart';
import 'features/shop/models/medicine.dart';
import 'features/shop/models/order.dart';
import 'features/shop/screens/checkout_screen.dart';
import 'features/shop/screens/favourites_screen.dart';
import 'features/shop/screens/order_success_screen.dart';
import 'features/shop/screens/orders_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<CartItem> cart = [];
  List<Order> orders = [];
  final Set<Medicine> favourites = {};
  final ValueNotifier<int> _refreshNotifier = ValueNotifier<int>(0);

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
      _refreshNotifier.value++;
    });
  }

  void makeOrder(String fullName, String email, String phone, String address) {
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
      _refreshNotifier.value++;
    });
  }

  void toggleFavourite(Medicine med) {
    setState(() {
      if (favourites.contains(med)) {
        favourites.remove(med);
      } else {
        favourites.add(med);
      }
      _refreshNotifier.value++;
    });
  }

  late final GoRouter _router = GoRouter(
    refreshListenable: _refreshNotifier,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MainScreen(
          cart: cart,
          orders: orders,
          favourites: favourites,
          medicines: medicines,
          onAddToCart: addToCart,
          onMakeOrder: makeOrder,
          onToggleFavourite: toggleFavourite,
        ),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => OrdersScreen(orders: orders),
      ),
      GoRoute(
        path: '/favourites',
        builder: (context, state) => FavouritesScreen(
          favourites: favourites,
          onToggleFavourite: toggleFavourite,
          onAdd: addToCart,
        ),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final cartItems = extra?['cart'] as List<CartItem>? ?? [];
          final total = extra?['total'] as double? ?? 0.0;
          return CheckoutScreen(
            cart: cartItems,
            total: total,
            onOrder: makeOrder,
          );
        },
      ),
      GoRoute(
        path: '/order-success',
        builder: (context, state) => const OrderSuccessScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Аптека',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      routerConfig: _router,
    );
  }
}
