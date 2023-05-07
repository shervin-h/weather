import 'package:weather/core/params/forecast_params.dart';
import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/usecase/use_case.dart';
import 'package:weather/features/feature_map/domain/entities/neshan_response_entity.dart';
import 'package:weather/features/feature_map/domain/repository/map_repository.dart';
import 'package:weather/locator.dart';

class GetRoutesUseCase extends UseCase<DataState<NeshanResponseEntity>, NeshanRouteParams> {

  final MapRepository mapRepository = getIt.get<MapRepository>();

  @override
  Future<DataState<NeshanResponseEntity>> call(NeshanRouteParams param) {
    return mapRepository.fetchNeshanRoutes(neshanRouteParams: param);
  }

}