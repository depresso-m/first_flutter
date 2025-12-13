import '../../core/models/pharmacy.dart';
import '../../domain/interfaces/repositories/pharmacy_repository.dart';
import '../datasources/api/pharmacy_api_datasource.dart';
import '../datasources/local/pharmacy_local_datasource.dart';

class PharmacyRepositoryImpl implements PharmacyRepository {
  final PharmacyApiDataSource _apiDataSource;
  final PharmacyLocalDataSource _localDataSource;

  PharmacyRepositoryImpl({
    required PharmacyApiDataSource apiDataSource,
    required PharmacyLocalDataSource localDataSource,
  })  : _apiDataSource = apiDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<Pharmacy>> getAllPharmacies() async {
    try {
      final pharmacies = await _apiDataSource.getAllPharmacies();
      await _localDataSource.savePharmacies(pharmacies);
      return pharmacies;
    } catch (_) {
      return await _localDataSource.getAllPharmacies();
    }
  }

  @override
  Future<Pharmacy?> getPharmacyById(String id) async {
    try {
      return await _apiDataSource.getPharmacyById(id);
    } catch (_) {
      return await _localDataSource.getPharmacyById(id);
    }
  }

  @override
  Future<List<Pharmacy>> searchPharmacies(String query) async {
    final allPharmacies = await getAllPharmacies();
    if (query.trim().isEmpty) return allPharmacies;

    return allPharmacies.where((p) => p.matchesQuery(query)).toList();
  }

  @override
  Future<List<Pharmacy>> getPharmaciesOpen24Hours() async {
    final allPharmacies = await getAllPharmacies();
    return allPharmacies.where((p) => p.isOpen24Hours).toList();
  }
}
