import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather/core/params/forecast_params.dart';
import 'package:weather/core/utils/constants.dart';

class ApiProvider {
  final Dio _dio = Dio();


  /// Check Is Online
  Future<Response> isOnline() async {
    Response response = await _dio.head('https://www.varzesh3.com/');
    return response;
  }


  /// Call Current Weather by City Name
  Future<Response> getCurrentWeatherData({required String cityName, required String apiKey, String lang = 'en'}) async {
    Response response = await _dio.get(
      '${Constants.baseUrl}/data/2.5/weather',
      queryParameters: {
        'q': cityName,
        // 'appid': Constants.apiKey,
        'appid': apiKey,
        'units': 'metric',
        'lang': lang,
      }
    );//.timeout(const Duration(seconds: 5));
    // debugPrint('Current weather data: ${response.data}');
    return response;
  }


  /// Call 5 day / 3 hour forecast data
  Future<Response> get5Day3HourForecastWeatherData({required ForecastParams forecastParams, required String apiKey, String lang = 'en'}) async {
     Response response = await _dio.get(
       '${Constants.baseUrl}/data/2.5/forecast',
       queryParameters: {
         'lat': forecastParams.lat,
         'lon': forecastParams.long,
         // 'appid': Constants.apiKey,
         'appid': apiKey,
         'units': 'metric',
         'lang': lang,
       }
     );//.timeout(const Duration(seconds: 5));
     // debugPrint('Call 5 day / 3 hour forecast Weather data: ${response.data}');
     return response;
  }

  Future<Response> sendRequestCitySuggestion({required String prefix}) async {
    Response response = await _dio.get(
      'http://geodb-free-service.wirefreethought.com/v1/geo/cities',
      queryParameters: {
        'limit': 7,
        'offset': 0,
        'namePrefix': prefix,
      }
    );
    return response;
  }
}