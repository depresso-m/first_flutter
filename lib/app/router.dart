import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/models/medicine.dart';
import '../core/models/pharmacy.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/screens/cart_screen.dart';
import '../presentation/screens/checkout_screen.dart';
import '../presentation/screens/favourites_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/loyalty_screen.dart';
import '../presentation/screens/medicine_detail_screen.dart';
import '../presentation/screens/medicines_screen.dart';
import '../presentation/screens/order_failure_screen.dart';
import '../presentation/screens/order_success_screen.dart';
import '../presentation/screens/orders_screen.dart';
import '../presentation/screens/pharmacies_screen.dart';
import '../presentation/screens/pharmacy_detail_screen.dart';
import '../presentation/screens/pharmacy_map_screen.dart';
import '../presentation/screens/profile_screen.dart';
import '../presentation/screens/profile_settings_screen.dart';
import '../presentation/screens/register_screen.dart';
import 'main_screen.dart';

part 'router.g.dart';

abstract class AppRoutes {
  static const login = '/login';
  static const register = '/register';

  static const home = '/';
  static const cart = '/cart';
  static const profile = '/profile';

  static const medicineDetail = '/medicine';

  static const checkout = '/cart/checkout';
  static const orderSuccess = '/cart/order-success';
  static const orderFailure = '/cart/order-failure';

  static const orders = '/profile/orders';
  static const favourites = '/profile/favourites';
  static const pharmacies = '/profile/pharmacies';
  static const pharmacyDetail = '/profile/pharmacies/detail';
  static const pharmacyMap = '/profile/pharmacies/map';
  static const loyalty = '/profile/loyalty';
  static const profileSettings = '/profile/settings';

  static int getTabIndex(String location) {
    if (location.startsWith('/profile')) return 2;
    if (location.startsWith('/cart')) return 1;
    return 0;
  }
}

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.login;
      }

      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return MainScreen(
            currentIndex: AppRoutes.getTabIndex(state.matchedLocation),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'medicines',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MedicinesScreen(),
            ),
            routes: [
              GoRoute(
                path: 'medicine',
                name: 'medicineDetail',
                builder: (context, state) {
                  final medicine = state.extra as Medicine;
                  return MedicineDetailScreen(medicine: medicine);
                },
              ),
            ],
          ),

          GoRoute(
            path: AppRoutes.cart,
            name: 'cart',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CartScreen(),
            ),
            routes: [
              GoRoute(
                path: 'checkout',
                name: 'checkout',
                builder: (context, state) => const CheckoutScreen(),
              ),
              GoRoute(
                path: 'order-success',
                name: 'orderSuccess',
                builder: (context, state) => const OrderSuccessScreen(),
              ),
              GoRoute(
                path: 'order-failure',
                name: 'orderFailure',
                builder: (context, state) => const OrderFailureScreen(),
              ),
            ],
          ),

          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
            routes: [
              GoRoute(
                path: 'orders',
                name: 'orders',
                builder: (context, state) => const OrdersScreen(),
              ),
              GoRoute(
                path: 'favourites',
                name: 'favourites',
                builder: (context, state) => const FavouritesScreen(),
              ),
              GoRoute(
                path: 'pharmacies',
                name: 'pharmacies',
                builder: (context, state) => const PharmaciesScreen(),
                routes: [
                  GoRoute(
                    path: 'detail',
                    name: 'pharmacyDetail',
                    builder: (context, state) {
                      final pharmacy = state.extra as Pharmacy;
                      return PharmacyDetailScreen(pharmacy: pharmacy);
                    },
                  ),
                  GoRoute(
                    path: 'map',
                    name: 'pharmacyMap',
                    builder: (context, state) => const PharmacyMapScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: 'loyalty',
                name: 'loyalty',
                builder: (context, state) => const LoyaltyScreen(),
              ),
              GoRoute(
                path: 'settings',
                name: 'profileSettings',
                builder: (context, state) => const ProfileSettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
