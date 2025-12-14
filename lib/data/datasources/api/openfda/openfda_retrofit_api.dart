import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import 'dto/openfda_drug_dto.dart';
import 'dto/openfda_event_dto.dart';
import 'dto/openfda_label_dto.dart';

part 'openfda_retrofit_api.g.dart';

@RestApi(baseUrl: ApiConstants.openFdaBaseUrl)
abstract class OpenFdaRetrofitApi {
  factory OpenFdaRetrofitApi(
    Dio dio, {
    String? baseUrl,
  }) = _OpenFdaRetrofitApi;

  @GET(ApiConstants.openFdaDrugsPath)
  Future<OpenFdaResponseDto> getRandomDrugs(
    @Query('skip') int skip,
    @Query('limit') int limit,
    @Query('api_key') String? apiKey,
  );

  @GET(ApiConstants.openFdaDrugsPath)
  Future<OpenFdaResponseDto> searchByName(
    @Query('search') String search,
    @Query('limit') int limit,
    @Query('api_key') String? apiKey,
  );

  @GET(ApiConstants.openFdaLabelPath)
  Future<OpenFdaLabelResponseDto> getDrugLabel(
    @Query('search') String search,
    @Query('limit') int limit,
    @Query('api_key') String? apiKey,
  );

  @GET(ApiConstants.openFdaDrugsPath)
  Future<OpenFdaResponseDto> getAnalogsBySubstance(
    @Query('search') String search,
    @Query('limit') int limit,
    @Query('api_key') String? apiKey,
  );

  @GET(ApiConstants.openFdaEventPath)
  Future<OpenFdaEventResponseDto> getAdverseEvents(
    @Query('search') String search,
    @Query('limit') int limit,
    @Query('api_key') String? apiKey,
  );

  @GET(ApiConstants.openFdaDrugsPath)
  Future<OpenFdaResponseDto> getDrugsByManufacturer(
    @Query('search') String search,
    @Query('limit') int limit,
    @Query('api_key') String? apiKey,
  );
}
