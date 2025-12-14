import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import 'dto/dadata_suggestion_dto.dart';

part 'dadata_retrofit_api.g.dart';

@RestApi(baseUrl: ApiConstants.dadataBaseUrl)
abstract class DaDataRetrofitApi {
  factory DaDataRetrofitApi(
    Dio dio, {
    String? baseUrl,
  }) = _DaDataRetrofitApi;

  @POST(ApiConstants.dadataSuggestPath)
  Future<DaDataResponseDto> suggest(
    @Body() Map<String, dynamic> body,
  );
}
