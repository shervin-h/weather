
import 'package:flutter/cupertino.dart';
import 'package:weather/features/feature_weather/domain/entities/forecast_weather_entity.dart';

@immutable
abstract class ForecastWeatherStatus{}

class ForecastWeatherLoadingStatus extends ForecastWeatherStatus {}

class ForecastWeatherCompletedStatus extends ForecastWeatherStatus {
  final ForecastWeatherEntity forecastWeatherEntity;
  ForecastWeatherCompletedStatus(this.forecastWeatherEntity);
}

class ForecastWeatherErrorStatus extends ForecastWeatherStatus {
  final String errorMessage;
  ForecastWeatherErrorStatus(this.errorMessage);
}