import '../../core/models/medicine.dart';
import '../../domain/interfaces/repositories/favourites_repository.dart';
import '../datasources/local/favourites_local_datasource.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  final FavouritesLocalDataSource _localDataSource;

  FavouritesRepositoryImpl({required FavouritesLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<Set<Medicine>> getFavourites() async {
    return await _localDataSource.getFavourites();
  }

  @override
  Future<void> addToFavourites(Medicine medicine) async {
    await _localDataSource.addToFavourites(medicine);
  }

  @override
  Future<void> removeFromFavourites(Medicine medicine) async {
    await _localDataSource.removeFromFavourites(medicine);
  }

  @override
  Future<void> toggleFavourite(Medicine medicine) async {
    final isFav = await isFavourite(medicine);
    if (isFav) {
      await removeFromFavourites(medicine);
    } else {
      await addToFavourites(medicine);
    }
  }

  @override
  Future<bool> isFavourite(Medicine medicine) async {
    return await _localDataSource.isFavourite(medicine);
  }
}
