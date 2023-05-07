import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather/features/feature_weather/domain/entities/current_weather_city_entity.dart';

@immutable
abstract class CurrentWeatherStatus {}

class CurrentWeatherLoadingStatus extends CurrentWeatherStatus {}

class CurrentWeatherCompletedStatus extends CurrentWeatherStatus {
  final CurrentWeatherCityEntity currentWeatherCityEntity;
  CurrentWeatherCompletedStatus(this.currentWeatherCityEntity);

}

class CurrentWeatherErrorStatus extends CurrentWeatherStatus {
  final String errorMessage;
  CurrentWeatherErrorStatus(this.errorMessage);

}

