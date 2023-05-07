import 'package:dio/dio.dart';
import 'package:weather/core/utils/constants.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      method: 'GET',
      baseUrl: 'https://api.neshan.org/v4/',
      headers: {
        'Api-Key': Constants.neshanApiKey,
      },
    ),
  );


  static Dio getInstance() {
    return _dio;
  }
}
