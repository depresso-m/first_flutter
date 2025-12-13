import '../../../core/models/medicine.dart';
import '../../interfaces/repositories/favourites_repository.dart';

class IsFavouriteUseCase {
  final FavouritesRepository _repository;

  IsFavouriteUseCase(this._repository);

  Future<bool> execute(Medicine medicine) async {
    return await _repository.isFavourite(medicine);
  }
}
