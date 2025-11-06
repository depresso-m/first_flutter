import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/empty_placeholder.dart';
import '../models/cart_item.dart';
import '../widgets/quantity_controls.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;
  final Function(String, String, String, String) onOrder;

  const CartScreen({super.key, required this.cart, required this.onOrder});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final total = widget.cart.fold(
      0.0,
      (sum, item) => sum + item.medicine.price * item.quantity,
    );

    return Column(
      children: [
        Expanded(
          child: widget.cart.isEmpty
              ? EmptyPlaceholder(
                  icon: Icons.shopping_basket_outlined,
                  message: 'Корзина пуста',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  separatorBuilder: (_, __) => SizedBox(height: 8),
                  itemCount: widget.cart.length,
                  itemBuilder: (_, i) {
                    final item = widget.cart[i];
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
                                setState(() {
                                  if (item.quantity > 1) item.quantity--;
                                });
                              },
                              onIncrement: () {
                                setState(() {
                                  item.quantity++;
                                });
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
                onPressed: widget.cart.isEmpty
                    ? null
                    : () {
                        context.push(
                          '/checkout',
                          extra: {
                            'cart': widget.cart,
                            'total': total,
                          },
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
  }
}
