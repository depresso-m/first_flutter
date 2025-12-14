import '../../../core/models/address_suggestion.dart';

/// Repository interface for address suggestions
abstract class AddressRepository {
  /// Suggest cities by query
  Future<List<AddressSuggestion>> suggestCities(String query);

  /// Suggest streets by query
  Future<List<AddressSuggestion>> suggestStreets(String query);

  /// Suggest full address (no restrictions)
  Future<List<AddressSuggestion>> suggestFullAddress(String query);

  /// Suggest addresses within a specific city
  Future<List<AddressSuggestion>> suggestByCity(String query, String cityFiasId);

  /// Refine house number
  Future<List<AddressSuggestion>> refineAddress(String streetQuery);
}
