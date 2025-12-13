import '../../../core/models/medicine.dart';

abstract class FavouritesRepository {
  Future<Set<Medicine>> getFavourites();

  Future<void> addToFavourites(Medicine medicine);

  Future<void> removeFromFavourites(Medicine medicine);

  Future<void> toggleFavourite(Medicine medicine);

  Future<bool> isFavourite(Medicine medicine);
}
