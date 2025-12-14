import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import 'dto/nominatim_place_dto.dart';

part 'nominatim_retrofit_api.g.dart';

@RestApi(baseUrl: ApiConstants.nominatimBaseUrl)
abstract class NominatimRetrofitApi {
  factory NominatimRetrofitApi(
    Dio dio, {
    String? baseUrl,
  }) = _NominatimRetrofitApi;

  @GET('/search')
  Future<List<NominatimPlaceDto>> geocodeCity(
    @Query('q') String cityName,
    @Query('format') String format,
    @Query('limit') int limit,
    @Query('addressdetails') int addressdetails,
    @Query('countrycodes') String countrycodes,
  );

  @GET('/search')
  Future<List<NominatimPlaceDto>> searchPlaces(
    @Query('q') String query,
    @Query('format') String format,
    @Query('limit') int limit,
    @Query('addressdetails') int addressdetails,
  );

  @GET('/reverse')
  Future<NominatimPlaceDto> reverseGeocode(
    @Query('lat') double lat,
    @Query('lon') double lon,
    @Query('format') String format,
    @Query('addressdetails') int addressdetails,
  );
}
