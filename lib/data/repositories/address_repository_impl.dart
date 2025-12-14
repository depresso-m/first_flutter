import '../../core/models/address_suggestion.dart';
import '../../domain/interfaces/repositories/address_repository.dart';
import '../datasources/api/dadata/dadata_api_datasource.dart';
import '../mappers/address_mapper.dart';

/// Implementation of AddressRepository using DaData API
class AddressRepositoryImpl implements AddressRepository {
  final DaDataApiDataSource _dataSource;

  // Simple cache for suggestions
  final Map<String, _CacheEntry<List<AddressSuggestion>>> _cache = {};

  AddressRepositoryImpl({required DaDataApiDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<AddressSuggestion>> suggestCities(String query) async {
    if (query.trim().length < 2) return [];

    final cacheKey = 'cities_${query.toLowerCase().trim()}';
    final cached = _cache[cacheKey];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final dtos = await _dataSource.suggestCities(query);
    final suggestions = AddressMapper.fromDtoList(dtos);

    _cache[cacheKey] = _CacheEntry(suggestions);
    return suggestions;
  }

  @override
  Future<List<AddressSuggestion>> suggestStreets(String query) async {
    if (query.trim().length < 2) return [];

    final cacheKey = 'streets_${query.toLowerCase().trim()}';
    final cached = _cache[cacheKey];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final dtos = await _dataSource.suggestStreets(query);
    final suggestions = AddressMapper.fromDtoList(dtos);

    _cache[cacheKey] = _CacheEntry(suggestions);
    return suggestions;
  }

  @override
  Future<List<AddressSuggestion>> suggestFullAddress(String query) async {
    if (query.trim().length < 2) return [];

    final cacheKey = 'full_${query.toLowerCase().trim()}';
    final cached = _cache[cacheKey];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final dtos = await _dataSource.suggestFullAddress(query);
    final suggestions = AddressMapper.fromDtoList(dtos);

    _cache[cacheKey] = _CacheEntry(suggestions);
    return suggestions;
  }

  @override
  Future<List<AddressSuggestion>> suggestByCity(
    String query,
    String cityFiasId,
  ) async {
    if (query.trim().length < 2) return [];

    final cacheKey = 'city_${cityFiasId}_${query.toLowerCase().trim()}';
    final cached = _cache[cacheKey];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final dtos = await _dataSource.suggestByCity(query, cityFiasId);
    final suggestions = AddressMapper.fromDtoList(dtos);

    _cache[cacheKey] = _CacheEntry(suggestions);
    return suggestions;
  }

  @override
  Future<List<AddressSuggestion>> refineAddress(String streetQuery) async {
    if (streetQuery.trim().length < 3) return [];

    final cacheKey = 'refine_${streetQuery.toLowerCase().trim()}';
    final cached = _cache[cacheKey];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final dtos = await _dataSource.refineHouse(streetQuery);
    final suggestions = AddressMapper.fromDtoList(dtos);

    _cache[cacheKey] = _CacheEntry(suggestions);
    return suggestions;
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
