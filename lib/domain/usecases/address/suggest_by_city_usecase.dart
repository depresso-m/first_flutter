import '../../../core/models/address_suggestion.dart';
import '../../interfaces/repositories/address_repository.dart';

/// Use case for suggesting addresses within a specific city
class SuggestByCityUseCase {
  final AddressRepository _repository;

  SuggestByCityUseCase(this._repository);

  /// Execute the use case
  /// [query] - Search query for address
  /// [cityFiasId] - FIAS ID of the city to restrict search to
  Future<List<AddressSuggestion>> execute(String query, String cityFiasId) async {
    if (query.trim().length < 2) return [];
    return await _repository.suggestByCity(query, cityFiasId);
  }
}
