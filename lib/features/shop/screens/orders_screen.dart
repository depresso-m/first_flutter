import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/empty_placeholder.dart';
import '../providers/orders_provider.dart';
import '../state/order_state.dart';
import '../widgets/back_button.dart';
import '../widgets/status_chip.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tick();
    });
  }

  void _tick() async {
    if (!mounted) return;
    setState(() {
      _now = DateTime.now();
    });
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    _tick();
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('История покупок'),
        leading: CustomBackButton(),
      ),
      body: orders.isEmpty
          ? EmptyPlaceholder(
              icon: Icons.receipt_long,
              message: 'Заказов пока нет',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              separatorBuilder: (_, __) => SizedBox(height: 8),
              itemCount: orders.length,
              itemBuilder: (_, i) {
                final order = orders[i];
                final dateStr = order.date.toLocal().toString().split(' ')[0];
                final status = getOrderStatusAt(order, _now);

                return Card(
                  elevation: 1,
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Заказ от $dateStr',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        StatusChip(status: status),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('Адрес: ${order.address}')],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${order.total.toStringAsFixed(2)} ₽',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${order.items.length} поз.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: order.items.length,
                        separatorBuilder: (_, __) => Divider(height: 1),
                        itemBuilder: (_, j) {
                          final item = order.items[j];
                          final lineTotal = item.medicine.price * item.quantity;
                          return ListTile(
                            dense: true,
                            title: Text(item.medicine.name),
                            subtitle: Text(
                              '${item.medicine.price.toStringAsFixed(2)} ₽ x ${item.quantity}',
                            ),
                            trailing: Text('${lineTotal.toStringAsFixed(2)} ₽'),
                          );
                        },
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
