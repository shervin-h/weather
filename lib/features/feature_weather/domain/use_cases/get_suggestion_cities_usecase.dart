import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/usecase/use_case.dart';
import 'package:weather/features/feature_weather/domain/entities/geo_city_entity.dart';
import 'package:weather/features/feature_weather/domain/repository/weather_repository.dart';
import 'package:weather/locator.dart';

class GetSuggestionCitiesUseCase extends UseCase<DataState<List<GeoCityEntity>>, String> {

  WeatherRepository weatherRepository = getIt.get<WeatherRepository>();

  @override
  Future<DataState<List<GeoCityEntity>>> call(String param) {
    return weatherRepository.fetchSuggestionData(param);
  }

}