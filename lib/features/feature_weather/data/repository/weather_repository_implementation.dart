import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather/core/params/forecast_params.dart';
import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/utils/constants.dart';
import 'package:weather/features/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:weather/features/feature_weather/data/models/current_weather_city_model.dart';
import 'package:weather/features/feature_weather/data/models/forecast_weather_model.dart';
import 'package:weather/features/feature_weather/data/models/geo_city_model.dart';
import 'package:weather/features/feature_weather/domain/entities/current_weather_city_entity.dart';
import 'package:weather/features/feature_weather/domain/entities/forecast_weather_entity.dart';
import 'package:weather/features/feature_weather/domain/entities/geo_city_entity.dart';
import 'package:weather/features/feature_weather/domain/repository/weather_repository.dart';

import '../../../../locator.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  // ApiProvider apiProvider;
  // WeatherRepositoryImplementation(this.apiProvider);

  final ApiProvider apiProvider = getIt<ApiProvider>();

  @override
  Future<DataState<CurrentWeatherCityEntity>> fetchCurrentWeatherData(String cityName) async {
    Response response;
    try {
      response = await apiProvider.getCurrentWeatherData(cityName: cityName, apiKey: Constants.apiKey1);
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data is Map<String, dynamic> &&
          (response.data as Map<String, dynamic>).containsKey('weather') &&
          response.data['weather'] != null &&
          response.data['weather'] is List &&
          (response.data['weather'] as List).isNotEmpty) {
        CurrentWeatherCityEntity currentWeatherCityEntity = CurrentWeatherCityModel.fromJson(response.data);
        return DataSuccess(currentWeatherCityEntity);

      } else {
        response = await apiProvider.getCurrentWeatherData(cityName: cityName, apiKey: Constants.apiKey2);
        if (response.statusCode == 200 &&
            response.data != null &&
            response.data is Map<String, dynamic> &&
            (response.data as Map<String, dynamic>).containsKey('weather') &&
            response.data['weather'] != null &&
            response.data['weather'] is List &&
            (response.data['weather'] as List).isNotEmpty) {
          CurrentWeatherCityEntity currentWeatherCityEntity = CurrentWeatherCityModel.fromJson(response.data);
          return DataSuccess(currentWeatherCityEntity);

        } else {
          response = await apiProvider.getCurrentWeatherData(cityName: cityName, apiKey: Constants.apiKey3);
          if (response.statusCode == 200 &&
              response.data != null &&
              response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('weather') &&
              response.data['weather'] != null &&
              response.data['weather'] is List &&
              (response.data['weather'] as List).isNotEmpty) {
            CurrentWeatherCityEntity currentWeatherCityEntity = CurrentWeatherCityModel.fromJson(response.data);
            return DataSuccess(currentWeatherCityEntity);

          } else {
            return const DataFailed('Something went wrong. try again...');
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      return const DataFailed('):');
    }
  }

  @override
  Future<DataState<ForecastWeatherEntity>> fetchForecastWeatherData(ForecastParams forecastParams) async {
    Response response;
    try {
      response = await apiProvider.get5Day3HourForecastWeatherData(forecastParams: forecastParams, apiKey: Constants.apiKey1);
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data is Map<String, dynamic> &&
          (response.data as Map<String, dynamic>).containsKey('list') &&
          response.data['list'] != null &&
          response.data['list'] is List &&
          (response.data['list'] as List).isNotEmpty) {
        ForecastWeatherEntity forecastWeatherEntity = ForecastWeatherModel.fromJson(response.data);
        return DataSuccess(forecastWeatherEntity);
      } else {
        response = await apiProvider.get5Day3HourForecastWeatherData(forecastParams: forecastParams, apiKey: Constants.apiKey2);
        if (response.statusCode == 200 &&
            response.data != null &&
            response.data is Map<String, dynamic> &&
            (response.data as Map<String, dynamic>).containsKey('list') &&
            response.data['list'] != null &&
            response.data['list'] is List &&
            (response.data['list'] as List).isNotEmpty) {
          ForecastWeatherEntity forecastWeatherEntity = ForecastWeatherModel.fromJson(response.data);
          return DataSuccess(forecastWeatherEntity);
        } else {
          response = await apiProvider.get5Day3HourForecastWeatherData(forecastParams: forecastParams, apiKey: Constants.apiKey3);
          if (response.statusCode == 200 &&
              response.data != null &&
              response.data is Map<String, dynamic> &&
              (response.data as Map<String, dynamic>).containsKey('list') &&
              response.data['list'] != null &&
              response.data['list'] is List &&
              (response.data['list'] as List).isNotEmpty) {
            ForecastWeatherEntity forecastWeatherEntity = ForecastWeatherModel.fromJson(response.data);
            return DataSuccess(forecastWeatherEntity);
          } else {
            return const DataFailed('Something went wrong. Please try later...');
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      return const DataFailed('):');
    }
  }

  @override
  Future<DataState<List<GeoCityEntity>>> fetchSuggestionData(String prefix) async {
    List<GeoCityEntity> cities = [];
    try {
      Response response = await apiProvider.sendRequestCitySuggestion(prefix: prefix);
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data is Map<String, dynamic> &&
          response.data['data'] != null &&
          (response.data['data'] as List).isNotEmpty) {
        for (var item in response.data['data']) {
          cities.add(GeoCityModel.fromJson(item));
        }
        return DataSuccess(cities);
      } else {
        return const DataFailed('Something went wrong. Please try again ...');
      }
    } catch (e) {
      debugPrint(e.toString());
      return const DataFailed('):');
    }
  }

}