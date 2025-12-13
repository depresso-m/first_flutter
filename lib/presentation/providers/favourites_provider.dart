import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/medicine.dart';
import '../../di/injection_container.dart';
import '../../domain/usecases/favourites/get_favourites_usecase.dart';
import '../../domain/usecases/favourites/is_favourite_usecase.dart';
import '../../domain/usecases/favourites/toggle_favourite_usecase.dart';

final getFavouritesUseCaseProvider = Provider<GetFavouritesUseCase>(
  (ref) => getIt<GetFavouritesUseCase>(),
);

final toggleFavouriteUseCaseProvider = Provider<ToggleFavouriteUseCase>(
  (ref) => getIt<ToggleFavouriteUseCase>(),
);

final isFavouriteUseCaseProvider = Provider<IsFavouriteUseCase>(
  (ref) => getIt<IsFavouriteUseCase>(),
);

class FavouritesNotifier extends StateNotifier<Set<Medicine>> {
  final GetFavouritesUseCase _getFavouritesUseCase;
  final ToggleFavouriteUseCase _toggleFavouriteUseCase;

  FavouritesNotifier({
    required GetFavouritesUseCase getFavouritesUseCase,
    required ToggleFavouriteUseCase toggleFavouriteUseCase,
  })  : _getFavouritesUseCase = getFavouritesUseCase,
        _toggleFavouriteUseCase = toggleFavouriteUseCase,
        super({}) {
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    state = await _getFavouritesUseCase.execute();
  }

  Future<void> toggleFavourite(Medicine medicine) async {
    await _toggleFavouriteUseCase.execute(medicine);
    await _loadFavourites();
  }

  bool isFavourite(Medicine medicine) {
    return state.contains(medicine);
  }
}

final favouritesNotifierProvider =
    StateNotifierProvider<FavouritesNotifier, Set<Medicine>>((ref) {
  return FavouritesNotifier(
    getFavouritesUseCase: ref.watch(getFavouritesUseCaseProvider),
    toggleFavouriteUseCase: ref.watch(toggleFavouriteUseCaseProvider),
  );
});
