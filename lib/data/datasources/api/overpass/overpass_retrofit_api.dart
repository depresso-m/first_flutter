import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import 'dto/overpass_pharmacy_dto.dart';

part 'overpass_retrofit_api.g.dart';

@RestApi(baseUrl: ApiConstants.overpassBaseUrl)
abstract class OverpassRetrofitApi {
  factory OverpassRetrofitApi(
    Dio dio, {
    String? baseUrl,
  }) = _OverpassRetrofitApi;

  @POST('')
  @FormUrlEncoded()
  Future<OverpassResponseDto> executeQuery(
    @Field('data') String query,
  );
}
