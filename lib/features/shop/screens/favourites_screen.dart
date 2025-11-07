import 'package:flutter/material.dart';

import '../../../../app/app_state_widget.dart';
import '../../../shared/widgets/empty_placeholder.dart';
import '../widgets/medicine_tile.dart';
import '../widgets/back_button.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateWidget.of(context);

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final favourites = appState.favourites;

        return Scaffold(
          appBar: AppBar(
            title: Text('Избранное'),
            leading: CustomBackButton(),
          ),
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
                    return MedicineTile(
                      medicine: med,
                    );
                  },
                ),
        );
      },
    );
  }
}


