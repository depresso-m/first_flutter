import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/medicine.dart';

part 'favourites_provider.g.dart';

@Riverpod(keepAlive: true)
class FavouritesNotifier extends _$FavouritesNotifier {
  @override
  Set<Medicine> build() => {};

  void toggleFavourite(Medicine med) {
    final favourites = Set<Medicine>.from(state);
    if (favourites.contains(med)) {
      favourites.remove(med);
    } else {
      favourites.add(med);
    }
    state = favourites;
  }

  bool isFavourite(Medicine med) {
    return state.contains(med);
  }
}



