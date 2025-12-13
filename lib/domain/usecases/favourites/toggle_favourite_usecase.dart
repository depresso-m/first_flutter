import '../../../core/models/medicine.dart';
import '../../interfaces/repositories/favourites_repository.dart';

class ToggleFavouriteUseCase {
  final FavouritesRepository _repository;

  ToggleFavouriteUseCase(this._repository);

  Future<void> execute(Medicine medicine) async {
    await _repository.toggleFavourite(medicine);
  }
}
