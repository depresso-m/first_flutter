import 'package:flutter/material.dart';

import '../models/order.dart';

class OrdersScreen extends StatelessWidget {
  final List<Order> orders;
  const OrdersScreen({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return Center(child: Text('Заказов пока нет'));

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (_, i) {
        final order = orders[i];
        return Card(
          margin: EdgeInsets.all(8),
          child: ExpansionTile(
            title: Text('Заказ от ${order.date.toLocal().toString().split(' ')[0]}'),
            subtitle: Text('Адрес: ${order.address}\nСумма: ${order.total} ₽'),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                itemBuilder: (_, j) {
                  final item = order.items[j];
                  final lineTotal = item.medicine.price * item.quantity;
                  return ListTile(
                    dense: true,
                    title: Text(item.medicine.name),
                    subtitle: Text('${item.medicine.price} ₽ x ${item.quantity}'),
                    trailing: Text('${lineTotal.toStringAsFixed(2)} ₽'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
