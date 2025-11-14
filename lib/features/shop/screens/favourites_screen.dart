import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/empty_placeholder.dart';
import '../providers/favourites_provider.dart';
import '../widgets/back_button.dart';
import '../widgets/medicine_tile.dart';

class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favourites = ref.watch(favouritesNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Избранное'), leading: CustomBackButton()),
      body: favourites.isEmpty
          ? EmptyPlaceholder(
              icon: Icons.favorite_border,
              message: 'Избранных товаров нет',
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              separatorBuilder: (_, __) => SizedBox(height: 8),
              itemCount: favourites.length,
              itemBuilder: (_, i) {
                final med = favourites.elementAt(i);
                return MedicineTile(medicine: med);
              },
            ),
    );
  }
}
