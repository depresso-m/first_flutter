import 'package:flutter/material.dart';

import '../models/medicine.dart';

class MedicinesScreen extends StatefulWidget {
  final List<Medicine> medicines;
  final Function(Medicine) onAdd;
  const MedicinesScreen({required this.medicines, required this.onAdd});

  @override
  _MedicinesScreenState createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {
  bool sortByPrice = false;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final meds = [...widget.medicines];
    if (sortByPrice) meds.sort((a, b) => a.price.compareTo(b.price));
    final filtered = searchQuery.isEmpty
        ? meds
        : meds.where((m) => m.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Text('Каталог', style: Theme.of(context).textTheme.titleMedium),
              Spacer(),
              FilledButton.tonal(
                onPressed: () => setState(() => sortByPrice = !sortByPrice),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(sortByPrice ? Icons.sort_by_alpha : Icons.attach_money),
                    SizedBox(width: 6),
                    Text(sortByPrice ? 'По названию' : 'По цене'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            onChanged: (value) => setState(() => searchQuery = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Поиск по названию',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            separatorBuilder: (_, __) => SizedBox(height: 8),
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final med = filtered[i];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  title: Text(med.name, style: Theme.of(context).textTheme.titleMedium),
                  subtitle: Text('${med.price.toStringAsFixed(2)} ₽'),
                  trailing: FilledButton.icon(
                    onPressed: () => widget.onAdd(med),
                    icon: Icon(Icons.add_shopping_cart),
                    label: Text('В корзину'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
