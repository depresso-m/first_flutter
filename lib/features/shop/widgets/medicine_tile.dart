import 'package:flutter/material.dart';

import '../models/medicine.dart';

class MedicineTile extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onAdd;

  const MedicineTile({super.key, required this.medicine, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        title: Text(
          medicine.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text('${medicine.price.toStringAsFixed(2)} ₽'),
        trailing: FilledButton.icon(
          onPressed: onAdd,
          icon: Icon(Icons.add_shopping_cart),
          label: Text('В корзину'),
        ),
      ),
    );
  }
}
