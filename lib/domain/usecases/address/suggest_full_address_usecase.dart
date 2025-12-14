import '../../../core/models/address_suggestion.dart';
import '../../interfaces/repositories/address_repository.dart';

/// Use case for suggesting full addresses
class SuggestFullAddressUseCase {
  final AddressRepository _repository;

  SuggestFullAddressUseCase(this._repository);

  /// Execute the use case
  /// [query] - Search query for full address
  Future<List<AddressSuggestion>> execute(String query) async {
    if (query.trim().length < 2) return [];
    return await _repository.suggestFullAddress(query);
  }
}
