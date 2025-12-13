import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/medicines_provider.dart';
import '../widgets/medicine_tile.dart';

class MedicinesScreen extends ConsumerWidget {
  const MedicinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicinesAsync = ref.watch(filteredMedicinesProvider);
    final sortByPrice = ref.watch(sortByPriceProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Text('Каталог', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              FilledButton.tonal(
                onPressed: () {
                  ref.read(sortByPriceProvider.notifier).state = !sortByPrice;
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      sortByPrice ? Icons.sort_by_alpha : Icons.attach_money,
                    ),
                    const SizedBox(width: 6),
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
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Поиск по названию',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        Expanded(
          child: medicinesAsync.when(
            data: (medicines) => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: medicines.length,
              itemBuilder: (_, i) => MedicineTile(medicine: medicines[i]),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Ошибка: $error')),
          ),
        ),
      ],
    );
  }
}
