import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cart_provider.dart';
import '../providers/loyalty_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/back_button.dart';
import 'order_failure_screen.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _usePoints = false;
  int _pointsToUse = 0;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      ref.read(ordersNotifierProvider.notifier).makeOrder(
            _fullNameController.text.trim(),
            _emailController.text.trim(),
            _phoneController.text.trim(),
            _addressController.text.trim(),
            pointsToUse: _usePoints ? _pointsToUse : 0,
          );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderFailureScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartNotifierProvider);
    final loyalty = ref.watch(loyaltyNotifierProvider);
    final total = cart.fold(
      0.0,
      (sum, item) => sum + item.medicine.price * item.quantity,
    );

    // Максимум 50% от суммы заказа можно оплатить баллами
    final maxPointsToUse = (total * 0.5).floor().clamp(0, loyalty.totalPoints);
    
    // Обновляем pointsToUse если он превышает максимум
    if (_pointsToUse > maxPointsToUse) {
      _pointsToUse = maxPointsToUse;
    }

    final discount = _usePoints ? _pointsToUse.toDouble() : 0.0;
    final finalTotal = total - discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Оформление заказа'),
        leading: const CustomBackButton(),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Данные покупателя',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'ФИО',
                hintText: 'Иванов Иван Иванович',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите ФИО';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'example@mail.ru',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите email';
                }
                if (!value.contains('@')) {
                  return 'Введите корректный email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Телефон',
                hintText: '+7 (999) 123-45-67',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите телефон';
                }
                if (value.trim().length < 10) {
                  return 'Телефон должен содержать минимум 10 цифр';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Адрес (до квартиры)',
                hintText: 'г. Москва, ул. Ленина, д. 10',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите адрес';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            // Секция оплаты баллами
            if (loyalty.totalPoints > 0) ...[
              _LoyaltyPaymentSection(
                availablePoints: loyalty.totalPoints,
                maxPointsToUse: maxPointsToUse,
                usePoints: _usePoints,
                pointsToUse: _pointsToUse,
                onToggle: (value) => setState(() {
                  _usePoints = value;
                  if (value && _pointsToUse == 0) {
                    _pointsToUse = maxPointsToUse;
                  }
                }),
                onPointsChanged: (value) => setState(() => _pointsToUse = value),
              ),
              const SizedBox(height: 16),
            ],
            // Итого
            _OrderSummaryCard(
              total: total,
              discount: discount,
              finalTotal: finalTotal,
              pointsToEarn: (finalTotal * 0.05).round(),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submitOrder,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Заказать',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoyaltyPaymentSection extends StatelessWidget {
  final int availablePoints;
  final int maxPointsToUse;
  final bool usePoints;
  final int pointsToUse;
  final ValueChanged<bool> onToggle;
  final ValueChanged<int> onPointsChanged;

  const _LoyaltyPaymentSection({
    required this.availablePoints,
    required this.maxPointsToUse,
    required this.usePoints,
    required this.pointsToUse,
    required this.onToggle,
    required this.onPointsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.05),
              theme.colorScheme.tertiary.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.stars_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Оплата баллами',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Switch(
                    value: usePoints,
                    onChanged: maxPointsToUse > 0 ? onToggle : null,
                  ),
                ],
              ),
              Text(
                'Доступно: $availablePoints баллов',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              if (usePoints && maxPointsToUse > 0) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Использовать:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$pointsToUse баллов',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: pointsToUse.toDouble(),
                  min: 0,
                  max: maxPointsToUse.toDouble(),
                  divisions: maxPointsToUse > 0 ? maxPointsToUse : 1,
                  onChanged: (value) => onPointsChanged(value.round()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    Text(
                      'макс. $maxPointsToUse (50%)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
              if (maxPointsToUse == 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Недостаточно баллов для оплаты',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final double total;
  final double discount;
  final double finalTotal;
  final int pointsToEarn;

  const _OrderSummaryCard({
    required this.total,
    required this.discount,
    required this.finalTotal,
    required this.pointsToEarn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Итого',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              label: 'Сумма заказа',
              value: '${total.toStringAsFixed(2)} ₽',
            ),
            if (discount > 0) ...[
              const SizedBox(height: 8),
              _SummaryRow(
                label: 'Скидка баллами',
                value: '-${discount.toStringAsFixed(2)} ₽',
                valueColor: Colors.green,
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'К оплате',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${finalTotal.toStringAsFixed(2)} ₽',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.stars_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Вы получите +$pointsToEarn баллов',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: valueColor,
            fontWeight: valueColor != null ? FontWeight.w600 : null,
          ),
        ),
      ],
    );
  }
}
