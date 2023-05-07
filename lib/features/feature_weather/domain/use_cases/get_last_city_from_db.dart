import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/usecase/use_case.dart';
import 'package:weather/features/feature_bookmark/domain/entities/city_entity.dart';
import 'package:weather/features/feature_bookmark/domain/repository/city_repository.dart';

import '../../../../locator.dart';

class GetLastCityFromDbUseCase extends NoParamUseCase<String> {

  final CityRepository cityRepository = getIt.get<CityRepository>();

  @override
  Future<String> call() async {
    DataState<List<CityEntity>> dataState =  await cityRepository.getAllCitiesFromDB();
    if (dataState is DataSuccess &&
        dataState.data != null &&
        dataState.data!.isNotEmpty) {
      CityEntity lastCity = dataState.data!.last;
      return lastCity.name;
    } else {
      return '';
    }
  }
}