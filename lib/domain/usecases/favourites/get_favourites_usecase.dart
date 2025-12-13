import '../../../core/models/medicine.dart';
import '../../interfaces/repositories/favourites_repository.dart';

class GetFavouritesUseCase {
  final FavouritesRepository _repository;

  GetFavouritesUseCase(this._repository);

  Future<Set<Medicine>> execute() async {
    return await _repository.getFavourites();
  }
}
