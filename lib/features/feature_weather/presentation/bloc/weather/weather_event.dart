
part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {}

class LoadCurrentWeatherEvent extends WeatherEvent {
  final String cityName;
  LoadCurrentWeatherEvent(this.cityName);
}

class LoadForecastWeatherEvent extends WeatherEvent{
  final ForecastParams forecastParams;
  LoadForecastWeatherEvent(this.forecastParams);
}

class ChangeForecastItemEvent extends WeatherEvent {
  final int selectedIndex;
  ChangeForecastItemEvent(this.selectedIndex);
}
