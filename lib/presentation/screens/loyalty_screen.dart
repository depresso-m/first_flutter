import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/loyalty_transaction.dart';
import '../providers/loyalty_provider.dart';
import '../widgets/back_button.dart';

class LoyaltyScreen extends ConsumerWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loyalty = ref.watch(loyaltyNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Программа лояльности'),
        leading: const CustomBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PointsCard(points: loyalty.totalPoints),
            const SizedBox(height: 24),
            const _InfoSection(),
            const SizedBox(height: 24),
            Text(
              'История операций',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (!loyalty.hasTransactions)
              const _EmptyHistory()
            else
              ...loyalty.transactions.map(
                (t) => _TransactionTile(transaction: t),
              ),
          ],
        ),
      ),
    );
  }
}

class _PointsCard extends StatelessWidget {
  final int points;

  const _PointsCard({required this.points});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.stars_rounded,
            size: 48,
            color: Colors.white.withValues(alpha: 0.9),
          ),
          const SizedBox(height: 12),
          Text(
            '$points',
            style: theme.textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _getPointsText(points),
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  String _getPointsText(int points) {
    final lastTwo = points % 100;
    final lastOne = points % 10;

    if (lastTwo >= 11 && lastTwo <= 19) {
      return 'баллов';
    }
    if (lastOne == 1) {
      return 'балл';
    }
    if (lastOne >= 2 && lastOne <= 4) {
      return 'балла';
    }
    return 'баллов';
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Как это работает',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _InfoRow(
              icon: Icons.shopping_bag_outlined,
              text: 'Совершайте покупки в нашей аптеке',
            ),
            const SizedBox(height: 12),
            const _InfoRow(
              icon: Icons.percent,
              text: '5% от суммы заказа начисляется баллами',
            ),
            const SizedBox(height: 12),
            const _InfoRow(
              icon: Icons.redeem,
              text: '1 балл = 1 рубль при оплате',
            ),
            const SizedBox(height: 12),
            const _InfoRow(
              icon: Icons.card_giftcard,
              text: 'Оплачивайте до 50% заказа баллами',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(
              'История пуста',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Совершите первый заказ,\nчтобы получить баллы',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final LoyaltyTransaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.isEarned
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.orange.withValues(alpha: 0.1),
          child: Icon(
            transaction.isEarned ? Icons.add : Icons.remove,
            color: transaction.isEarned ? Colors.green : Colors.orange,
          ),
        ),
        title: Text(transaction.description),
        subtitle: Text(
          _formatDate(transaction.date),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        trailing: Text(
          transaction.pointsFormatted,
          style: theme.textTheme.titleMedium?.copyWith(
            color: transaction.isEarned ? Colors.green : Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
