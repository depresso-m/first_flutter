import '../../../core/models/address_suggestion.dart';
import '../../interfaces/repositories/address_repository.dart';

/// Use case for suggesting cities
class SuggestCitiesUseCase {
  final AddressRepository _repository;

  SuggestCitiesUseCase(this._repository);

  /// Execute the use case
  /// [query] - Search query for city name
  Future<List<AddressSuggestion>> execute(String query) async {
    if (query.trim().length < 2) return [];
    return await _repository.suggestCities(query);
  }
}
