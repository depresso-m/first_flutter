import '../../../core/models/address_suggestion.dart';
import '../../interfaces/repositories/address_repository.dart';

/// Use case for suggesting streets
class SuggestStreetsUseCase {
  final AddressRepository _repository;

  SuggestStreetsUseCase(this._repository);

  /// Execute the use case
  /// [query] - Search query for street name
  Future<List<AddressSuggestion>> execute(String query) async {
    if (query.trim().length < 2) return [];
    return await _repository.suggestStreets(query);
  }
}
