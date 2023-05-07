import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/usecase/use_case.dart';
import 'package:weather/features/feature_bookmark/domain/entities/city_entity.dart';
import 'package:weather/features/feature_bookmark/domain/repository/city_repository.dart';
import 'package:weather/locator.dart';

class FindCityUseCase extends UseCase<DataState<CityEntity?>, String> {

  final CityRepository cityRepository = getIt<CityRepository>();

  @override
  Future<DataState<CityEntity?>> call(String param) {
    return cityRepository.findCityByName(param);
  }

}