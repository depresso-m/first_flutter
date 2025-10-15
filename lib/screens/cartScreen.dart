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
          child: ListView.builder(
            itemCount: widget.cart.length,
            itemBuilder: (_, i) {
              final item = widget.cart[i];
              return ListTile(
                title: Text(item.medicine.name),
                subtitle: Text('${item.medicine.price} ₽ x ${item.quantity}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: Icon(Icons.remove), onPressed: () {
                      setState(() {
                        if (item.quantity > 1) item.quantity--;
                      });
                    }),
                    IconButton(icon: Icon(Icons.add), onPressed: () {
                      setState(() {
                        item.quantity++;
                      });
                    }),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Итого: $total ₽', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          child: Text('Купить'),
          onPressed: widget.cart.isEmpty ? null : () {
            showDialog(
              context: context,
              builder: (dialogContext) {
                final controller = TextEditingController();
                return AlertDialog(
                  title: Text('Адрес доставки'),
                  content: TextField(controller: controller, decoration: InputDecoration(hintText: 'Введите адрес')),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Отмена')),
                    ElevatedButton(
                      onPressed: () {
                        final address = controller.text;
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
        ),
      ],
    );
  }
}
