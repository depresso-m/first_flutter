import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/medicine.dart';
import '../models/order.dart';

class ProfileScreen extends StatelessWidget {
  final List<Order> orders;
  final Set<Medicine> favourites;
  final Function(Medicine) onToggleFavourite;
  final Function(Medicine) onAdd;

  const ProfileScreen({
    super.key,
    required this.orders,
    required this.favourites,
    required this.onToggleFavourite,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                child: Icon(Icons.person, size: 28),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Михаил Черепов', style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 4),
                    Text('Профиль', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('История покупок'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                context.push('/orders');
              },
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Избранное'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                context.push('/favourites');
              },
            ),
          ),
        ],
      ),
    );
  }
}


