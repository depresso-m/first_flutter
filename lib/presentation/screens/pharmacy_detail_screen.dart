import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/models/pharmacy.dart';
import '../widgets/back_button.dart';

class PharmacyDetailScreen extends StatelessWidget {
  final Pharmacy pharmacy;

  const PharmacyDetailScreen({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация об аптеке'),
        leading: const CustomBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.local_pharmacy,
                size: 64,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              pharmacy.address,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _InfoTile(
              icon: Icons.access_time,
              label: 'Время работы',
              value: pharmacy.workingHours,
            ),
            const SizedBox(height: 16),
            _InfoTile(
              icon: Icons.phone,
              label: 'Телефон',
              value: pharmacy.phone,
              onTap: () => _copyToClipboard(context, pharmacy.phone),
            ),
            const SizedBox(height: 16),
            _InfoTile(
              icon: Icons.email,
              label: 'Электронная почта',
              value: pharmacy.email,
              onTap: () => _copyToClipboard(context, pharmacy.email),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Скопировано: $text'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.copy,
                  size: 20,
                  color: theme.colorScheme.outline,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
