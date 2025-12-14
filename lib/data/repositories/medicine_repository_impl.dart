import '../../core/models/medicine.dart';
import '../../domain/interfaces/repositories/medicine_repository.dart';
import '../datasources/api/medicine_api_datasource.dart';
import '../datasources/api/openfda/openfda_api_datasource.dart';
import '../datasources/local/medicine_local_datasource.dart';
import '../mappers/medicine_mapper.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineApiDataSource _apiDataSource;
  final MedicineLocalDataSource _localDataSource;
  final OpenFdaApiDataSource _openFdaDataSource;

  // Simple in-memory cache for API results
  final Map<String, _CacheEntry<List<Medicine>>> _searchCache = {};
  final Map<String, _CacheEntry<MedicineDetails>> _detailsCache = {};

  MedicineRepositoryImpl({
    required MedicineApiDataSource apiDataSource,
    required MedicineLocalDataSource localDataSource,
    required OpenFdaApiDataSource openFdaDataSource,
  })  : _apiDataSource = apiDataSource,
        _localDataSource = localDataSource,
        _openFdaDataSource = openFdaDataSource;

  @override
  Future<List<Medicine>> getAllMedicines() async {
    try {
      final medicines = await _apiDataSource.getAllMedicines();
      await _localDataSource.saveMedicines(medicines);
      return medicines;
    } catch (_) {
      return await _localDataSource.getAllMedicines();
    }
  }

  @override
  Future<Medicine?> getMedicineById(String id) async {
    try {
      final medicine = await _apiDataSource.getMedicineById(id);
      if (medicine != null) {
        await _localDataSource.saveMedicine(medicine);
      }
      return medicine;
    } catch (_) {
      return await _localDataSource.getMedicineById(id);
    }
  }

  @override
  Future<List<Medicine>> searchMedicines(String query) async {
    final allMedicines = await getAllMedicines();
    if (query.trim().isEmpty) return allMedicines;

    return allMedicines.where((m) => m.matchesQuery(query)).toList();
  }

  @override
  Future<List<Medicine>> getMedicinesByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    final allMedicines = await getAllMedicines();
    return allMedicines
        .where((m) => m.price >= minPrice && m.price <= maxPrice)
        .toList();
  }

  @override
  Future<List<Medicine>> getMedicinesSortedByPrice({bool ascending = true}) async {
    final medicines = await getAllMedicines();
    medicines.sort((a, b) =>
        ascending ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
    return medicines;
  }

  // OpenFDA API methods

  @override
  Future<List<Medicine>> getRandomMedicinesFromApi({
    int skip = 0,
    int limit = 10,
  }) async {
    final cacheKey = 'random_${skip}_$limit';
    final cached = _searchCache[cacheKey];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final dtos = await _openFdaDataSource.getRandomDrugs(
      skip: skip,
      limit: limit,
    );
    final medicines = dtos.toModelList();

    _searchCache[cacheKey] = _CacheEntry(medicines);
    return medicines;
  }

  @override
  Future<List<Medicine>> searchMedicinesFromApi(String query) async {
    if (query.trim().isEmpty) return [];

    final cacheKey = 'search_${query.toLowerCase().trim()}';
    final cached = _searchCache[cacheKey];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final dtos = await _openFdaDataSource.searchByName(query);
    final medicines = dtos.toModelList();

    _searchCache[cacheKey] = _CacheEntry(medicines);
    return medicines;
  }

  @override
  Future<MedicineDetails?> getMedicineDetails(String ndc) async {
    if (ndc.trim().isEmpty) return null;

    final cached = _detailsCache[ndc];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final labelDto = await _openFdaDataSource.getDrugLabel(ndc);
    if (labelDto == null) return null;

    final details = labelDto.toModel();
    _detailsCache[ndc] = _CacheEntry(details);
    return details;
  }

  @override
  Future<List<Medicine>> getAnalogs(String activeIngredient) async {
    if (activeIngredient.trim().isEmpty) return [];

    final cacheKey = 'analogs_${activeIngredient.toLowerCase().trim()}';
    final cached = _searchCache[cacheKey];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final dtos = await _openFdaDataSource.getAnalogsBySubstance(activeIngredient);
    final medicines = dtos.toModelList();

    _searchCache[cacheKey] = _CacheEntry(medicines);
    return medicines;
  }

  @override
  Future<List<String>> getSideEffects(String brandName) async {
    if (brandName.trim().isEmpty) return [];

    return await _openFdaDataSource.getAdverseEvents(brandName);
  }

  @override
  Future<List<Medicine>> getDrugsByManufacturer(String manufacturerName) async {
    if (manufacturerName.trim().isEmpty) return [];

    final cacheKey = 'manufacturer_${manufacturerName.toLowerCase().trim()}';
    final cached = _searchCache[cacheKey];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final dtos = await _openFdaDataSource.getDrugsByManufacturer(manufacturerName);
    final medicines = dtos.toModelList();

    _searchCache[cacheKey] = _CacheEntry(medicines);
    return medicines;
  }
}

/// Simple cache entry with expiration
class _CacheEntry<T> {
  final T data;
  final DateTime createdAt;
  final Duration ttl;

  _CacheEntry(this.data, {this.ttl = const Duration(minutes: 5)})
      : createdAt = DateTime.now();

  bool get isExpired => DateTime.now().difference(createdAt) > ttl;
}
