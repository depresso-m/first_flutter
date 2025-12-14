import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/medicines_provider.dart';
import '../widgets/medicine_tile.dart';

class MedicinesScreen extends ConsumerStatefulWidget {
  const MedicinesScreen({super.key});

  @override
  ConsumerState<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends ConsumerState<MedicinesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicinesAsync = ref.watch(filteredMedicinesProvider);
    final useApi = ref.watch(useApiDataProvider);
    final sortByPrice = ref.watch(sortByPriceProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Text('Каталог', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(width: 8),
              // API/Local toggle
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: useApi
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GestureDetector(
                  onTap: () {
                    ref.read(useApiDataProvider.notifier).state = !useApi;
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        useApi ? Icons.cloud : Icons.storage,
                        size: 14,
                        color: useApi
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        useApi ? 'OpenFDA' : 'Локально',
                        style: TextStyle(
                          fontSize: 11,
                          color: useApi
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (!useApi)
                FilledButton.tonal(
                  onPressed: () {
                    ref.read(sortByPriceProvider.notifier).state = !sortByPrice;
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        sortByPrice ? Icons.sort_by_alpha : Icons.attach_money,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(sortByPrice ? 'По имени' : 'По цене'),
                    ],
                  ),
                ),
              if (useApi)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Обновить',
                  onPressed: () {
                    ref.invalidate(randomMedicinesProvider);
                    ref.invalidate(apiSearchMedicinesProvider);
                  },
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              if (useApi) {
                ref.read(apiSearchQueryProvider.notifier).state = value;
              } else {
                ref.read(searchQueryProvider.notifier).state = value;
              }
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: useApi 
                  ? 'Поиск в OpenFDA (англ.)' 
                  : 'Поиск по названию',
              border: const OutlineInputBorder(),
              isDense: true,
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        if (useApi) {
                          ref.read(apiSearchQueryProvider.notifier).state = '';
                        } else {
                          ref.read(searchQueryProvider.notifier).state = '';
                        }
                      },
                    )
                  : null,
            ),
          ),
        ),
        if (useApi)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              'Данные из OpenFDA API (FDA США)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
        Expanded(
          child: medicinesAsync.when(
            data: (medicines) {
              if (medicines.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Лекарства не найдены',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                      if (useApi)
                        Text(
                          'Попробуйте другой запрос на английском',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  if (useApi) {
                    ref.invalidate(randomMedicinesProvider);
                    ref.invalidate(apiSearchMedicinesProvider);
                  } else {
                    ref.invalidate(medicinesProvider);
                  }
                },
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemCount: medicines.length,
                  itemBuilder: (_, i) => MedicineTile(medicine: medicines[i]),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ошибка загрузки',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    // Show actual error for debugging
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        ref.invalidate(randomMedicinesProvider);
                        ref.invalidate(apiSearchMedicinesProvider);
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
