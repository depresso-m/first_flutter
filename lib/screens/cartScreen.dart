import 'package:flutter/material.dart';

import '../models/cartItem.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;
  final Function(String) onOrder;
  const CartScreen({required this.cart, required this.onOrder});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final total = widget.cart.fold(0.0, (sum, item) => sum + item.medicine.price * item.quantity);

    return Column(
      children: [
        Expanded(
          child: widget.cart.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_basket_outlined, size: 56, color: Theme.of(context).colorScheme.outline),
                      SizedBox(height: 8),
                      Text('Корзина пуста', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          child: Text(item.quantity.toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer)),
                        ),
                        title: Text(item.medicine.name),
                        subtitle: Row(
                          children: [
                            Text('${item.medicine.price.toStringAsFixed(2)} ₽ за ед.'),
                            SizedBox(width: 12),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      if (item.quantity > 1) item.quantity--;
                                    });
                                  },
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints.tightFor(width: 32, height: 32),
                                ),
                                SizedBox(width: 4),
                                Text('${item.quantity}'),
                                SizedBox(width: 4),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      item.quantity++;
                                    });
                                  },
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints.tightFor(width: 32, height: 32),
                                ),
                              ],
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
                    Text('Итого', style: Theme.of(context).textTheme.labelMedium),
                    SizedBox(height: 4),
                    Text('${total.toStringAsFixed(2)} ₽', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: widget.cart.isEmpty
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            final controller = TextEditingController();
                            return AlertDialog(
                              title: Text('Адрес доставки'),
                              content: TextField(
                                controller: controller,
                                decoration: InputDecoration(hintText: 'Введите адрес'),
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Отмена')),
                                FilledButton(
                                  onPressed: () {
                                    final address = controller.text.trim();
                                    Navigator.pop(dialogContext);
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      widget.onOrder(address);
                                    });
                                  },
                                  child: Text('Подтвердить'),
                                ),
                              ],
                            );
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
