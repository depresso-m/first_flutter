import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/models/pharmacy.dart';
import '../providers/pharmacies_provider.dart';
import '../widgets/back_button.dart';

class PharmaciesScreen extends ConsumerWidget {
  const PharmaciesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pharmaciesAsync = ref.watch(pharmaciesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Аптеки'),
        leading: const CustomBackButton(),
      ),
      body: pharmaciesAsync.when(
        data: (pharmacies) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: pharmacies.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final pharmacy = pharmacies[index];
            return _PharmacyCard(pharmacy: pharmacy);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}

class _PharmacyCard extends StatelessWidget {
  final Pharmacy pharmacy;

  const _PharmacyCard({required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.pharmacyDetail, extra: pharmacy),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_pharmacy,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy.address,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pharmacy.workingHours,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
