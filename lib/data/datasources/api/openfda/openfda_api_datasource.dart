import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import 'dto/openfda_drug_dto.dart';
import 'dto/openfda_event_dto.dart';
import 'dto/openfda_label_dto.dart';

/// Data source for OpenFDA API
abstract class OpenFdaApiDataSource {
  /// GET /drug/drugsfda.json?skip={skip}&limit={limit}
  Future<List<OpenFdaDrugDto>> getRandomDrugs({int skip = 0, int limit = 10});

  /// GET /drug/drugsfda.json?search=openfda.brand_name:{query}
  Future<List<OpenFdaDrugDto>> searchByName(String query);

  /// GET /drug/label.json?search=openfda.product_ndc:{ndc}&limit=1
  Future<OpenFdaLabelDto?> getDrugLabel(String ndc);

  /// GET /drug/drugsfda.json?search=openfda.substance_name:{substance}
  Future<List<OpenFdaDrugDto>> getAnalogsBySubstance(String substance);

  /// GET /drug/event.json?search=patient.drug.openfda.brand_name:{name}&limit=50
  Future<List<String>> getAdverseEvents(String brandName);

  /// GET /drug/drugsfda.json?search=openfda.manufacturer_name:{name}&limit=5
  Future<List<OpenFdaDrugDto>> getDrugsByManufacturer(String manufacturerName);
}

class OpenFdaApiDataSourceImpl implements OpenFdaApiDataSource {
  final Dio _dio;

  OpenFdaApiDataSourceImpl({Dio? dio})
      : _dio = dio ?? DioClient.openFda().dio;

  @override
  Future<List<OpenFdaDrugDto>> getRandomDrugs({
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.openFdaDrugsPath,
        queryParameters: _buildQueryParams({
          'skip': skip,
          'limit': limit,
        }),
      );

      final dto = OpenFdaResponseDto.fromJson(response.data);
      return dto.results;
    } on DioException catch (e) {
      throw e.asApiException;
    }
  }

  @override
  Future<List<OpenFdaDrugDto>> searchByName(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final response = await _dio.get(
        ApiConstants.openFdaDrugsPath,
        queryParameters: _buildQueryParams({
          'search': 'openfda.brand_name:"${_escapeQuery(query)}"',
          'limit': 20,
        }),
      );

      final dto = OpenFdaResponseDto.fromJson(response.data);
      return dto.results;
    } on DioException catch (e) {
      if (e.asApiException.statusCode == 404) return [];
      throw e.asApiException;
    }
  }

  @override
  Future<OpenFdaLabelDto?> getDrugLabel(String ndc) async {
    if (ndc.trim().isEmpty) return null;

    try {
      final response = await _dio.get(
        ApiConstants.openFdaLabelPath,
        queryParameters: _buildQueryParams({
          'search': 'openfda.product_ndc:"${_escapeQuery(ndc)}"',
          'limit': 1,
        }),
      );

      final dto = OpenFdaLabelResponseDto.fromJson(response.data);
      return dto.results.isNotEmpty ? dto.results.first : null;
    } on DioException catch (e) {
      if (e.asApiException.statusCode == 404) return null;
      throw e.asApiException;
    }
  }

  @override
  Future<List<OpenFdaDrugDto>> getAnalogsBySubstance(String substance) async {
    if (substance.trim().isEmpty) return [];

    try {
      final response = await _dio.get(
        ApiConstants.openFdaDrugsPath,
        queryParameters: _buildQueryParams({
          'search': 'openfda.substance_name:"${_escapeQuery(substance)}"',
          'limit': 10,
        }),
      );

      final dto = OpenFdaResponseDto.fromJson(response.data);
      return dto.results;
    } on DioException catch (e) {
      if (e.asApiException.statusCode == 404) return [];
      throw e.asApiException;
    }
  }

  @override
  Future<List<String>> getAdverseEvents(String brandName) async {
    if (brandName.trim().isEmpty) return [];

    try {
      final response = await _dio.get(
        ApiConstants.openFdaEventPath,
        queryParameters: _buildQueryParams({
          'search': 'patient.drug.openfda.brand_name:"${_escapeQuery(brandName)}"',
          'limit': 50,
        }),
      );

      final dto = OpenFdaEventResponseDto.fromJson(response.data);

      final reactions = <String>{};
      for (final event in dto.results) {
        if (event.patient?.reactions != null) {
          for (final reaction in event.patient!.reactions!) {
            if (reaction.reactionMedDrapt?.isNotEmpty == true) {
              reactions.add(reaction.reactionMedDrapt!);
            }
          }
        }
      }
      return reactions.take(20).toList();
    } on DioException catch (e) {
      if (e.asApiException.statusCode == 404) return [];
      throw e.asApiException;
    }
  }

  @override
  Future<List<OpenFdaDrugDto>> getDrugsByManufacturer(String manufacturerName) async {
    if (manufacturerName.trim().isEmpty) return [];

    try {
      final response = await _dio.get(
        ApiConstants.openFdaDrugsPath,
        queryParameters: _buildQueryParams({
          'search': 'openfda.manufacturer_name:"${_escapeQuery(manufacturerName)}"',
          'limit': 10,
        }),
      );

      final dto = OpenFdaResponseDto.fromJson(response.data);
      return dto.results;
    } on DioException catch (e) {
      if (e.asApiException.statusCode == 404) return [];
      throw e.asApiException;
    }
  }

  String _escapeQuery(String query) {
    return query
        .replaceAll('+', ' ')
        .replaceAll('/', ' ')
        .replaceAll(':', ' ')
        .trim();
  }

  Map<String, dynamic> _buildQueryParams(Map<String, dynamic> params) {
    if (ApiConstants.openFdaApiKey.isNotEmpty) {
      return {...params, 'api_key': ApiConstants.openFdaApiKey};
    }
    return params;
  }
}
