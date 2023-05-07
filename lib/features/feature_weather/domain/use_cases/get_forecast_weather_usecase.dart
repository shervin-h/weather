
import 'package:weather/core/params/forecast_params.dart';
import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/usecase/use_case.dart';
import 'package:weather/features/feature_weather/domain/entities/forecast_weather_entity.dart';

import '../../../../locator.dart';
import '../repository/weather_repository.dart';

class GetForecastWeatherUseCase extends UseCase<DataState<ForecastWeatherEntity>, ForecastParams> {

  final WeatherRepository weatherRepository = getIt<WeatherRepository>();

  @override
  Future<DataState<ForecastWeatherEntity>> call(ForecastParams param) {
    return weatherRepository.fetchForecastWeatherData(param);
  }

}