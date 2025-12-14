import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/api_exception.dart';
import 'dto/openfda_drug_dto.dart';
import 'dto/openfda_event_dto.dart';
import 'dto/openfda_label_dto.dart';

/// Data source for OpenFDA API
abstract class OpenFdaApiDataSource {
  /// GET /drug/drugsfda.json?skip={skip}&limit={limit}
  /// Fetches random drugs from OpenFDA
  Future<List<OpenFdaDrugDto>> getRandomDrugs({int skip = 0, int limit = 10});

  /// GET /drug/drugsfda.json?search=openfda.brand_name:{query}
  /// Searches drugs by brand name
  Future<List<OpenFdaDrugDto>> searchByName(String query);

  /// GET /drug/label.json?search=openfda.product_ndc:{ndc}&limit=1
  /// Gets drug label information by NDC
  Future<OpenFdaLabelDto?> getDrugLabel(String ndc);

  /// GET /drug/drugsfda.json?search=openfda.substance_name:{substance}
  /// Gets drugs with the same active ingredient (analogs)
  Future<List<OpenFdaDrugDto>> getAnalogsBySubstance(String substance);

  /// GET /drug/event.json?search=patient.drug.openfda.brand_name:{name}&limit=10
  /// Gets adverse events (side effects) for a drug
  Future<List<String>> getAdverseEvents(String brandName);

  /// GET /drug/drugsfda.json?search=openfda.manufacturer_name:{name}&limit=5
  /// Gets drugs from a specific manufacturer
  Future<List<OpenFdaDrugDto>> getDrugsByManufacturer(String manufacturerName);
}

class OpenFdaApiDataSourceImpl implements OpenFdaApiDataSource {
  final http.Client _client;

  OpenFdaApiDataSourceImpl({http.Client? client})
      : _client = client ?? http.Client();

  @override
  Future<List<OpenFdaDrugDto>> getRandomDrugs({
    int skip = 0,
    int limit = 10,
  }) async {
    final uri = Uri.https(
      'api.fda.gov',
      '/drug/drugsfda.json',
      _buildQueryParams({
        'skip': skip.toString(),
        'limit': limit.toString(),
      }),
    );

    try {
      final response = await _makeRequest(uri);
      final dto = OpenFdaResponseDto.fromJson(response);
      // ignore: avoid_print
      print('OpenFDA parsed ${dto.results.length} drugs');
      return dto.results;
    } catch (e, stack) {
      // ignore: avoid_print
      print('OpenFDA getRandomDrugs error: $e');
      // ignore: avoid_print
      print('Stack: $stack');
      rethrow;
    }
  }

  @override
  Future<List<OpenFdaDrugDto>> searchByName(String query) async {
    if (query.trim().isEmpty) return [];

    final escapedQuery = _escapeSearchQuery(query);
    final uri = Uri.https(
      'api.fda.gov',
      '/drug/drugsfda.json',
      _buildQueryParams({
        'search': 'openfda.brand_name:"$escapedQuery"',
        'limit': '20',
      }),
    );

    try {
      final response = await _makeRequest(uri);
      final dto = OpenFdaResponseDto.fromJson(response);
      return dto.results;
    } on ApiException catch (e) {
      // OpenFDA returns 404 when no results found
      if (e.statusCode == 404) return [];
      rethrow;
    }
  }

  @override
  Future<OpenFdaLabelDto?> getDrugLabel(String ndc) async {
    if (ndc.trim().isEmpty) return null;

    final escapedNdc = _escapeSearchQuery(ndc);
    final uri = Uri.https(
      'api.fda.gov',
      '/drug/label.json',
      _buildQueryParams({
        'search': 'openfda.product_ndc:"$escapedNdc"',
        'limit': '1',
      }),
    );

    try {
      final response = await _makeRequest(uri);
      final dto = OpenFdaLabelResponseDto.fromJson(response);
      return dto.results.isNotEmpty ? dto.results.first : null;
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<List<OpenFdaDrugDto>> getAnalogsBySubstance(String substance) async {
    if (substance.trim().isEmpty) return [];

    final escapedSubstance = _escapeSearchQuery(substance);
    final uri = Uri.https(
      'api.fda.gov',
      '/drug/drugsfda.json',
      _buildQueryParams({
        'search': 'openfda.substance_name:"$escapedSubstance"',
        'limit': '10',
      }),
    );

    try {
      final response = await _makeRequest(uri);
      final dto = OpenFdaResponseDto.fromJson(response);
      return dto.results;
    } on ApiException catch (e) {
      if (e.statusCode == 404) return [];
      rethrow;
    }
  }

  @override
  Future<List<String>> getAdverseEvents(String brandName) async {
    if (brandName.trim().isEmpty) return [];

    final escapedName = _escapeSearchQuery(brandName);
    final uri = Uri.https(
      'api.fda.gov',
      '/drug/event.json',
      _buildQueryParams({
        'search': 'patient.drug.openfda.brand_name:"$escapedName"',
        'limit': '50',
      }),
    );

    try {
      final response = await _makeRequest(uri);
      final dto = OpenFdaEventResponseDto.fromJson(response);

      // Extract unique reactions from events
      final reactions = <String>{};
      for (final event in dto.results) {
        if (event.patient?.reactions != null) {
          for (final reaction in event.patient!.reactions!) {
            if (reaction.reactionMedDrapt != null &&
                reaction.reactionMedDrapt!.isNotEmpty) {
              reactions.add(reaction.reactionMedDrapt!);
            }
          }
        }
      }
      return reactions.take(20).toList();
    } on ApiException catch (e) {
      if (e.statusCode == 404) return [];
      rethrow;
    }
  }

  @override
  Future<List<OpenFdaDrugDto>> getDrugsByManufacturer(
    String manufacturerName,
  ) async {
    if (manufacturerName.trim().isEmpty) return [];

    final escapedName = _escapeSearchQuery(manufacturerName);
    final uri = Uri.https(
      'api.fda.gov',
      '/drug/drugsfda.json',
      _buildQueryParams({
        'search': 'openfda.manufacturer_name:"$escapedName"',
        'limit': '10',
      }),
    );

    try {
      final response = await _makeRequest(uri);
      final dto = OpenFdaResponseDto.fromJson(response);
      return dto.results;
    } on ApiException catch (e) {
      if (e.statusCode == 404) return [];
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _makeRequest(Uri uri) async {
    // ignore: avoid_print
    print('OpenFDA Request: $uri');
    
    try {
      final response = await _client
          .get(
            uri,
            headers: {
              'User-Agent': ApiConstants.userAgent,
              'Accept': 'application/json',
            },
          )
          .timeout(ApiConstants.requestTimeout);

      // ignore: avoid_print
      print('OpenFDA Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        throw ApiException.notFound(endpoint: uri.toString());
      } else if (response.statusCode == 429) {
        throw ApiException.rateLimited(endpoint: uri.toString());
      } else {
        // ignore: avoid_print
        print('OpenFDA Error body: ${response.body}');
        throw ApiException.serverError(
          statusCode: response.statusCode,
          endpoint: uri.toString(),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      // ignore: avoid_print
      print('OpenFDA Exception: $e');
      if (e.toString().contains('TimeoutException')) {
        throw ApiException.timeout(endpoint: uri.toString());
      }
      throw ApiException(
        message: 'Ошибка сети: $e',
        endpoint: uri.toString(),
        originalError: e,
      );
    }
  }

  String _escapeSearchQuery(String query) {
    // Escape special characters for OpenFDA search
    return query
        .replaceAll('+', ' ')
        .replaceAll('/', ' ')
        .replaceAll(':', ' ')
        .trim();
  }

  Map<String, String> _buildQueryParams(Map<String, String> params) {
    // Add API key if configured
    if (ApiConstants.openFdaApiKey.isNotEmpty) {
      return {...params, 'api_key': ApiConstants.openFdaApiKey};
    }
    return params;
  }
}
