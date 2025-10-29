import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/medicine.dart';

class MedicineTile extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onAdd;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;

  const MedicineTile({super.key, required this.medicine, required this.onAdd, required this.isFavourite, required this.onToggleFavourite});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: _buildImage(),
        title: Text(
          medicine.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text('${medicine.price.toStringAsFixed(2)} ₽'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onToggleFavourite,
              icon: Icon(isFavourite ? Icons.favorite : Icons.favorite_border),
              color: isFavourite ? Colors.red : null,
              tooltip: isFavourite ? 'Убрать из избранного' : 'В избранное',
            ),
            FilledButton.icon(
              onPressed: onAdd,
              icon: Icon(Icons.add_shopping_cart),
              label: Text('В корзину'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (medicine.imageUrl == null || medicine.imageUrl!.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.medication,
          color: Colors.grey[600],
          size: 30,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: medicine.imageUrl!,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 60,
          height: 60,
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.error_outline,
            color: Colors.grey[600],
            size: 30,
          ),
        ),
      ),
    );
  }
}
