import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/usecase/use_case.dart';
import 'package:weather/features/feature_bookmark/domain/entities/city_entity.dart';

import '../../../../locator.dart';
import '../repository/city_repository.dart';

class GetAllCitiesUseCase extends NoParamUseCase<DataState<List<CityEntity>>> {
  CityRepository cityRepository = getIt.get<CityRepository>();

  @override
  Future<DataState<List<CityEntity>>> call() {
    return cityRepository.getAllCitiesFromDB();
  }
}