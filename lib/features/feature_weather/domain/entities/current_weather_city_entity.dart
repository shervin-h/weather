import 'package:equatable/equatable.dart';

import '../../data/models/current_weather_city_model.dart';

class CurrentWeatherCityEntity extends Equatable {
  final Coord? coord;
  final List<Weather>? weather;
  final String? base;
  final Main? main;
  final num? visibility;
  final Wind? wind;
  final Clouds? clouds;
  final num? dt;
  final Sys? sys;
  final num? timezone;
  final num? id;
  final String? name;
  final num? cod;

  const CurrentWeatherCityEntity({
    this.coord,
    this.weather,
    this.base,
    this.main,
    this.visibility,
    this.wind,
    this.clouds,
    this.dt,
    this.sys,
    this.timezone,
    this.id,
    this.name,
    this.cod,
  });

  @override
  // List<Object?> get props => [coord, weather, base, main, visibility, wind, clouds, dt, sys, timezone, id, name, cod];
  List<Object?> get props => [name];

}