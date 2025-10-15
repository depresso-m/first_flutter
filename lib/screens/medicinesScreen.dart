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

  @override
  Widget build(BuildContext context) {
    final meds = [...widget.medicines];
    if (sortByPrice) meds.sort((a, b) => a.price.compareTo(b.price));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => setState(() => sortByPrice = !sortByPrice),
              child: Text(sortByPrice ? 'По названию' : 'По цене'),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: meds.length,
            itemBuilder: (_, i) {
              final med = meds[i];
              return ListTile(
                title: Text(med.name),
                subtitle: Text('${med.price} ₽'),
                trailing: IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () => widget.onAdd(med),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
