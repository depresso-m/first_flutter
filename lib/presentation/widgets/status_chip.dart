import 'package:flutter/material.dart';

import '../../core/models/order.dart';

class StatusChip extends StatelessWidget {
  final OrderStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      OrderStatus.received => ('Заказ получен', Colors.blue),
      OrderStatus.formed => ('Заказ сформирован', Colors.orange),
      OrderStatus.assembled => ('Заказ собран', Colors.green),
      OrderStatus.handed => ('Передан в доставку', Colors.purple),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
