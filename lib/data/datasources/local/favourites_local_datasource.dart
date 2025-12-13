import '../../../core/models/medicine.dart';

abstract class FavouritesLocalDataSource {
  Future<Set<Medicine>> getFavourites();
  Future<void> addToFavourites(Medicine medicine);
  Future<void> removeFromFavourites(Medicine medicine);
  Future<bool> isFavourite(Medicine medicine);
}

class FavouritesLocalDataSourceImpl implements FavouritesLocalDataSource {
  final Set<Medicine> _favourites = {};

  @override
  Future<Set<Medicine>> getFavourites() async {
    return Set.from(_favourites);
  }

  @override
  Future<void> addToFavourites(Medicine medicine) async {
    _favourites.add(medicine);
  }

  @override
  Future<void> removeFromFavourites(Medicine medicine) async {
    _favourites.remove(medicine);
  }

  @override
  Future<bool> isFavourite(Medicine medicine) async {
    return _favourites.contains(medicine);
  }
}
