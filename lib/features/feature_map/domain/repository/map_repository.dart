import 'package:weather/core/params/forecast_params.dart';
import 'package:weather/core/resources/data_state.dart';
import 'package:weather/features/feature_map/domain/entities/neshan_response_entity.dart';

abstract class MapRepository {
  Future<DataState<NeshanResponseEntity>> fetchNeshanRoutes({required NeshanRouteParams neshanRouteParams});
}