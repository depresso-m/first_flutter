import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/medicine.dart';
import '../providers/cart_provider.dart';
import '../providers/favourites_provider.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Карточка товара'),
        leading: CustomBackButton(),
        actions: [
          IconButton(
            onPressed: () => favouritesNotifier.toggleFavourite(widget.medicine),
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
                    widget.medicine.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${widget.medicine.price.toStringAsFixed(2)} ₽',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        'Количество:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(width: 16),
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
                  SizedBox(height: 24),
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
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: Icon(Icons.add_shopping_cart),
                    label: Text('Добавить в корзину'),
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildImage() {
    if (widget.medicine.imageUrl == null ||
        widget.medicine.imageUrl!.isEmpty) {
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
          child: Center(child: CircularProgressIndicator()),
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
    } else if ([2, 3, 4].contains(qty % 10) && ![12, 13, 14].contains(qty % 100)) {
      return 'товара';
    } else {
      return 'товаров';
    }
  }
}

