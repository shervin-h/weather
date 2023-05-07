import 'package:weather/core/params/forecast_params.dart';
import 'package:weather/features/feature_weather/domain/entities/current_weather_city_entity.dart';
import 'package:weather/features/feature_weather/domain/entities/forecast_weather_entity.dart';
import 'package:weather/features/feature_weather/domain/entities/geo_city_entity.dart';

import '../../../../core/resources/data_state.dart';

abstract class WeatherRepository {
  Future<DataState<CurrentWeatherCityEntity>> fetchCurrentWeatherData(String cityName);
  Future<DataState<ForecastWeatherEntity>> fetchForecastWeatherData(ForecastParams forecastParams);
  Future<DataState<List<GeoCityEntity>>> fetchSuggestionData(String prefix);
}