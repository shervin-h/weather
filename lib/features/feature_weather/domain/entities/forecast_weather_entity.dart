import 'package:equatable/equatable.dart';

import '../../data/models/forecast_weather_model.dart';

class ForecastWeatherEntity extends Equatable {

  final String? cod;
  final num? message;
  final num? cnt;
  final List<ForecastData>? forecastData;
  final City? city;


  const ForecastWeatherEntity({this.cod, this.message, this.cnt, this.forecastData, this.city});

  @override
  List<Object?> get props => [];

}