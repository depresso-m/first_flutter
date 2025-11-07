import 'package:flutter/material.dart';

import '../../../app/service_locator.dart';
import '../../../app/app_state.dart';
import '../../../shared/widgets/empty_placeholder.dart';
import '../widgets/quantity_controls.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = getIt<AppState>();

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final cart = appState.cart;
        final total = cart.fold(
          0.0,
          (sum, item) => sum + item.medicine.price * item.quantity,
        );

        return Column(
          children: [
            Expanded(
              child: cart.isEmpty
                  ? EmptyPlaceholder(
                      icon: Icons.shopping_basket_outlined,
                      message: 'Корзина пуста',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      separatorBuilder: (_, __) => SizedBox(height: 8),
                      itemCount: cart.length,
                      itemBuilder: (_, i) {
                        final item = cart[i];
                        final lineTotal = item.medicine.price * item.quantity;
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                              child: Text(
                                item.quantity.toString(),
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                            title: Text(item.medicine.name),
                            subtitle: Row(
                              children: [
                                Text(
                                  '${item.medicine.price.toStringAsFixed(2)} ₽ за ед.',
                                ),
                                SizedBox(width: 12),
                                QuantityControls(
                                  onDecrement: () {
                                    appState.updateCartItemQuantity(item, item.quantity - 1);
                                  },
                                  onIncrement: () {
                                    appState.updateCartItemQuantity(item, item.quantity + 1);
                                  },
                                  quantityText: '${item.quantity}',
                                ),
                              ],
                            ),
                            trailing: Text('${lineTotal.toStringAsFixed(2)} ₽'),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Итого',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${total.toStringAsFixed(2)} ₽',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: cart.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CheckoutScreen(),
                              ),
                            );
                          },
                    icon: Icon(Icons.payment),
                    label: Text('Оформить'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
