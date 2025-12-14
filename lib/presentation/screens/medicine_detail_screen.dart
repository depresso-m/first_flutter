import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/medicine.dart';
import '../providers/cart_provider.dart';
import '../providers/favourites_provider.dart';
import '../providers/medicines_provider.dart';
import '../widgets/back_button.dart';
import '../widgets/quantity_controls.dart';

class MedicineDetailScreen extends ConsumerStatefulWidget {
  final Medicine medicine;

  const MedicineDetailScreen({super.key, required this.medicine});

  @override
  ConsumerState<MedicineDetailScreen> createState() =>
      _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends ConsumerState<MedicineDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final favourites = ref.watch(favouritesNotifierProvider);
    final isFavourite = favourites.contains(widget.medicine);
    final favouritesNotifier = ref.read(favouritesNotifierProvider.notifier);
    final cartNotifier = ref.read(cartNotifierProvider.notifier);

    // Watch API data if NDC is available
    final detailsAsync = widget.medicine.ndc != null
        ? ref.watch(medicineDetailsProvider(widget.medicine.ndc!))
        : null;
    final sideEffectsAsync = widget.medicine.brandName != null
        ? ref.watch(sideEffectsProvider(widget.medicine.brandName!))
        : null;
    final analogsAsync = widget.medicine.activeIngredient != null
        ? ref.watch(medicineAnalogsProvider(widget.medicine.activeIngredient!))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Карточка товара'),
        leading: const CustomBackButton(),
        actions: [
          IconButton(
            onPressed: () =>
                favouritesNotifier.toggleFavourite(widget.medicine),
            icon: Icon(isFavourite ? Icons.favorite : Icons.favorite_border),
            color: isFavourite ? Colors.red : null,
            tooltip: isFavourite ? 'Убрать из избранного' : 'В избранное',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImage(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.medicine.displayName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (widget.medicine.genericName != null &&
                      widget.medicine.genericName != widget.medicine.brandName)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        widget.medicine.genericName!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    widget.medicine.priceFormatted,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  // Additional info chips
                  if (widget.medicine.dosageForm != null ||
                      widget.medicine.route != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (widget.medicine.dosageForm != null)
                            Chip(
                              avatar: const Icon(Icons.medication, size: 16),
                              label: Text(widget.medicine.dosageForm!),
                              visualDensity: VisualDensity.compact,
                            ),
                          if (widget.medicine.route != null)
                            Chip(
                              avatar: const Icon(Icons.directions, size: 16),
                              label: Text(widget.medicine.route!),
                              visualDensity: VisualDensity.compact,
                            ),
                        ],
                      ),
                    ),

                  // Manufacturer
                  if (widget.medicine.manufacturer != null) ...[
                    const SizedBox(height: 16),
                    _InfoRow(
                      icon: Icons.business,
                      label: 'Производитель',
                      value: widget.medicine.manufacturer!,
                    ),
                  ],

                  // Active ingredient
                  if (widget.medicine.activeIngredient != null) ...[
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.science,
                      label: 'Действующее вещество',
                      value: widget.medicine.activeIngredient!,
                    ),
                  ],

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        'Количество:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 16),
                      QuantityControls(
                        onDecrement: () {
                          if (quantity > 1) {
                            setState(() => quantity--);
                          }
                        },
                        onIncrement: () {
                          setState(() => quantity++);
                        },
                        quantityText: quantity.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      for (int i = 0; i < quantity; i++) {
                        cartNotifier.addToCart(widget.medicine);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Добавлено $quantity ${_getQuantityText(quantity)} в корзину',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Добавить в корзину'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),

                  // Details from API
                  if (detailsAsync != null)
                    detailsAsync.when(
                      data: (details) {
                        if (details == null || !details.hasAnyData) {
                          return const SizedBox.shrink();
                        }
                        return _DetailsSection(details: details);
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                    ),

                  // Side effects from API
                  if (sideEffectsAsync != null)
                    sideEffectsAsync.when(
                      data: (effects) {
                        if (effects.isEmpty) return const SizedBox.shrink();
                        return _SideEffectsSection(effects: effects);
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),

                  // Analogs from API
                  if (analogsAsync != null)
                    analogsAsync.when(
                      data: (analogs) {
                        if (analogs.isEmpty) return const SizedBox.shrink();
                        // Filter out current medicine
                        final filtered = analogs
                            .where((m) => m.id != widget.medicine.id)
                            .take(5)
                            .toList();
                        if (filtered.isEmpty) return const SizedBox.shrink();
                        return _AnalogsSection(analogs: filtered);
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (!widget.medicine.hasImage) {
      return Container(
        height: 300,
        color: Colors.grey[300],
        child: Center(
          child: Icon(
            Icons.medication,
            color: Colors.grey[600],
            size: 100,
          ),
        ),
      );
    }

    return Container(
      height: 300,
      color: Colors.grey[200],
      child: CachedNetworkImage(
        imageUrl: widget.medicine.imageUrl!,
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: Center(
            child: Icon(
              Icons.error_outline,
              color: Colors.grey[600],
              size: 80,
            ),
          ),
        ),
      ),
    );
  }

  String _getQuantityText(int qty) {
    if (qty % 10 == 1 && qty % 100 != 11) {
      return 'товар';
    } else if ([2, 3, 4].contains(qty % 10) &&
        ![12, 13, 14].contains(qty % 100)) {
      return 'товара';
    } else {
      return 'товаров';
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailsSection extends StatelessWidget {
  final dynamic details;

  const _DetailsSection({required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Информация из OpenFDA',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        if (details.description != null)
          _ExpandableText(title: 'Описание', text: details.description!),
        if (details.indications != null)
          _ExpandableText(title: 'Показания', text: details.indications!),
        if (details.dosageAndAdministration != null)
          _ExpandableText(
            title: 'Дозировка и применение',
            text: details.dosageAndAdministration!,
          ),
        if (details.warnings != null)
          _ExpandableText(
            title: 'Предупреждения',
            text: details.warnings!,
            isWarning: true,
          ),
        if (details.contraindications != null)
          _ExpandableText(
            title: 'Противопоказания',
            text: details.contraindications!,
            isWarning: true,
          ),
      ],
    );
  }
}

class _ExpandableText extends StatefulWidget {
  final String title;
  final String text;
  final bool isWarning;

  const _ExpandableText({
    required this.title,
    required this.text,
    this.isWarning = false,
  });

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: widget.isWarning
          ? theme.colorScheme.errorContainer.withOpacity(0.3)
          : null,
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (widget.isWarning)
                    Icon(
                      Icons.warning_amber,
                      size: 18,
                      color: theme.colorScheme.error,
                    ),
                  if (widget.isWarning) const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color:
                            widget.isWarning ? theme.colorScheme.error : null,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.outline,
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 8),
                Text(
                  widget.text,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SideEffectsSection extends StatelessWidget {
  final List<String> effects;

  const _SideEffectsSection({required this.effects});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            Icon(
              Icons.warning_amber,
              color: Theme.of(context).colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Возможные побочные эффекты',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'По данным FDA (на англ.):',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: effects.take(10).map((effect) {
            return Chip(
              label: Text(
                effect,
                style: const TextStyle(fontSize: 12),
              ),
              visualDensity: VisualDensity.compact,
              backgroundColor:
                  Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _AnalogsSection extends StatelessWidget {
  final List<Medicine> analogs;

  const _AnalogsSection({required this.analogs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Аналоги (по действующему веществу)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...analogs.map((medicine) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              dense: true,
              leading: const Icon(Icons.medication),
              title: Text(
                medicine.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                medicine.manufacturer ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                medicine.priceFormatted,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
