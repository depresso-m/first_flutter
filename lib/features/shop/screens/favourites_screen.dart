import 'package:flutter/material.dart';

import '../../../shared/widgets/empty_placeholder.dart';
import '../models/medicine.dart';
import '../widgets/medicine_tile.dart';

class FavouritesScreen extends StatelessWidget {
  final Set<Medicine> favourites;
  final Function(Medicine) onToggleFavourite;
  final Function(Medicine) onAdd;

  const FavouritesScreen({super.key, required this.favourites, required this.onToggleFavourite, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    if (favourites.isEmpty) {
      return EmptyPlaceholder(
        icon: Icons.favorite_border,
        message: 'Избранных товаров нет',
      );
    }

    final favList = favourites.toList();
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      separatorBuilder: (_, __) => SizedBox(height: 8),
      itemCount: favList.length,
      itemBuilder: (_, i) {
        final med = favList[i];
        return MedicineTile(
          medicine: med,
          onAdd: () => onAdd(med),
          isFavourite: true,
          onToggleFavourite: () => onToggleFavourite(med),
        );
      },
    );
  }
}


