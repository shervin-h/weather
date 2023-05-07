import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/usecase/use_case.dart';
import 'package:weather/features/feature_bookmark/domain/repository/city_repository.dart';
import 'package:weather/locator.dart';

class DeleteCityUseCase extends UseCase<DataState<String>, String> {

  final CityRepository cityRepository = getIt.get<CityRepository>();

  @override
  Future<DataState<String>> call(String param) {
    return cityRepository.deleteCityByName(param);
  }

}