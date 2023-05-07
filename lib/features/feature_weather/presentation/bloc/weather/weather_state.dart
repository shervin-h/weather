
part of 'weather_bloc.dart';

@immutable
class WeatherState extends Equatable {
  final CurrentWeatherStatus currentWeatherStatus;
  final ForecastWeatherStatus forecastWeatherStatus;
  final int selectedItemIndex;

  const WeatherState(this.currentWeatherStatus, this.forecastWeatherStatus, this.selectedItemIndex);

  WeatherState copyWith({
    CurrentWeatherStatus? newCurrentWeatherStatus,
    ForecastWeatherStatus? newForecastWeatherStatus,
    int? newSelectedIndex,
  }) {
    return WeatherState(
      newCurrentWeatherStatus ?? currentWeatherStatus,
      newForecastWeatherStatus ?? forecastWeatherStatus,
      newSelectedIndex ?? 0,
    );
  }

  @override
  List<Object?> get props => [currentWeatherStatus, forecastWeatherStatus, selectedItemIndex];

}


