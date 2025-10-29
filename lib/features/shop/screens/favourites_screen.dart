import 'package:flutter/material.dart';

import '../../../shared/widgets/empty_placeholder.dart';
import '../models/medicine.dart';
import '../widgets/back_button.dart';
import '../widgets/medicine_tile.dart';

class FavouritesScreen extends StatelessWidget {
  final Set<Medicine> favourites;
  final Function(Medicine) onToggleFavourite;
  final Function(Medicine) onAdd;

  const FavouritesScreen({
    super.key,
    required this.favourites,
    required this.onToggleFavourite,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomBackButton(),
        Expanded(
          child: favourites.isEmpty
              ? EmptyPlaceholder(
                  icon: Icons.favorite_border,
                  message: 'Избранных товаров нет',
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  separatorBuilder: (_, __) => SizedBox(height: 8),
                  itemCount: favourites.length,
                  itemBuilder: (_, i) {
                    final med = favourites.toList()[i];
                    return MedicineTile(
                      medicine: med,
                      onAdd: () => onAdd(med),
                      isFavourite: true,
                      onToggleFavourite: () => onToggleFavourite(med),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
