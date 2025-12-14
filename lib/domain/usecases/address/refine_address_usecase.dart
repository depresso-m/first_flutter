import '../../../core/models/address_suggestion.dart';
import '../../interfaces/repositories/address_repository.dart';

/// Use case for refining address with house number
class RefineAddressUseCase {
  final AddressRepository _repository;

  RefineAddressUseCase(this._repository);

  /// Execute the use case
  /// [streetQuery] - Street address to refine with house number
  Future<List<AddressSuggestion>> execute(String streetQuery) async {
    if (streetQuery.trim().length < 3) return [];
    return await _repository.refineAddress(streetQuery);
  }
}
