import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import 'dto/openfda_drug_dto.dart';
import 'dto/openfda_event_dto.dart';
import 'dto/openfda_label_dto.dart';
import 'openfda_retrofit_api.dart';

/// Data source for OpenFDA API
abstract class OpenFdaApiDataSource {
  Future<List<OpenFdaDrugDto>> getRandomDrugs({int skip = 0, int limit = 10});

  Future<List<OpenFdaDrugDto>> searchByName(String query);

  Future<OpenFdaLabelDto?> getDrugLabel(String ndc);

  Future<List<OpenFdaDrugDto>> getAnalogsBySubstance(String substance);

  Future<List<String>> getAdverseEvents(String brandName);

  Future<List<OpenFdaDrugDto>> getDrugsByManufacturer(String manufacturerName);
}

class OpenFdaApiDataSourceImpl implements OpenFdaApiDataSource {
  final OpenFdaRetrofitApi _api;

  OpenFdaApiDataSourceImpl({OpenFdaRetrofitApi? api})
      : _api = api ??
            OpenFdaRetrofitApi(
              DioClient.openFda().dio,
            );

  @override
  Future<List<OpenFdaDrugDto>> getRandomDrugs({
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      final response = await _api.getRandomDrugs(
        skip,
        limit,
        ApiConstants.openFdaApiKey.isNotEmpty
            ? ApiConstants.openFdaApiKey
            : null,
      );
      return response.results;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<OpenFdaDrugDto>> searchByName(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final response = await _api.searchByName(
        'openfda.brand_name:"${_escapeQuery(query)}"',
        20,
        ApiConstants.openFdaApiKey.isNotEmpty
            ? ApiConstants.openFdaApiKey
            : null,
      );
      return response.results;
    } catch (e) {
      if (_isNotFound(e)) return [];
      throw _handleError(e);
    }
  }

  @override
  Future<OpenFdaLabelDto?> getDrugLabel(String ndc) async {
    if (ndc.trim().isEmpty) return null;

    try {
      final response = await _api.getDrugLabel(
        'openfda.product_ndc:"${_escapeQuery(ndc)}"',
        1,
        ApiConstants.openFdaApiKey.isNotEmpty
            ? ApiConstants.openFdaApiKey
            : null,
      );
      return response.results.isNotEmpty ? response.results.first : null;
    } catch (e) {
      if (_isNotFound(e)) return null;
      throw _handleError(e);
    }
  }

  @override
  Future<List<OpenFdaDrugDto>> getAnalogsBySubstance(String substance) async {
    if (substance.trim().isEmpty) return [];

    try {
      final response = await _api.getAnalogsBySubstance(
        'openfda.substance_name:"${_escapeQuery(substance)}"',
        10,
        ApiConstants.openFdaApiKey.isNotEmpty
            ? ApiConstants.openFdaApiKey
            : null,
      );
      return response.results;
    } catch (e) {
      if (_isNotFound(e)) return [];
      throw _handleError(e);
    }
  }

  @override
  Future<List<String>> getAdverseEvents(String brandName) async {
    if (brandName.trim().isEmpty) return [];

    try {
      final response = await _api.getAdverseEvents(
        'patient.drug.openfda.brand_name:"${_escapeQuery(brandName)}"',
        50,
        ApiConstants.openFdaApiKey.isNotEmpty
            ? ApiConstants.openFdaApiKey
            : null,
      );

      final reactions = <String>{};
      for (final event in response.results) {
        if (event.patient?.reactions != null) {
          for (final reaction in event.patient!.reactions!) {
            if (reaction.reactionMedDrapt?.isNotEmpty == true) {
              reactions.add(reaction.reactionMedDrapt!);
            }
          }
        }
      }
      return reactions.take(20).toList();
    } catch (e) {
      if (_isNotFound(e)) return [];
      throw _handleError(e);
    }
  }

  @override
  Future<List<OpenFdaDrugDto>> getDrugsByManufacturer(
    String manufacturerName,
  ) async {
    if (manufacturerName.trim().isEmpty) return [];

    try {
      final response = await _api.getDrugsByManufacturer(
        'openfda.manufacturer_name:"${_escapeQuery(manufacturerName)}"',
        10,
        ApiConstants.openFdaApiKey.isNotEmpty
            ? ApiConstants.openFdaApiKey
            : null,
      );
      return response.results;
    } catch (e) {
      if (_isNotFound(e)) return [];
      throw _handleError(e);
    }
  }

  String _escapeQuery(String query) {
    return query
        .replaceAll('+', ' ')
        .replaceAll('/', ' ')
        .replaceAll(':', ' ')
        .trim();
  }

  bool _isNotFound(dynamic error) {
    if (error is ApiException) {
      return error.statusCode == 404;
    }
    return false;
  }

  ApiException _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    }
    return ApiException(
      message: 'Ошибка сети: $error',
      originalError: error,
    );
  }
}
