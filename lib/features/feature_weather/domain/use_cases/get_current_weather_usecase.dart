import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/usecase/use_case.dart';
import 'package:weather/features/feature_weather/domain/entities/current_weather_city_entity.dart';
import 'package:weather/features/feature_weather/domain/repository/weather_repository.dart';

import '../../../../locator.dart';

class GetCurrentWeatherUseCase extends UseCase<DataState<CurrentWeatherCityEntity>, String> {
  // WeatherRepository weatherRepository;
  // GetCurrentWeatherUseCase(this.weatherRepository);

  final WeatherRepository weatherRepository = getIt<WeatherRepository>();

  @override
  Future<DataState<CurrentWeatherCityEntity>> call(String param) {
    return weatherRepository.fetchCurrentWeatherData(param);
  }
}