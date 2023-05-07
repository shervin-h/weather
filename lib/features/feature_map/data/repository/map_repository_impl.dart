import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather/core/params/forecast_params.dart';
import 'package:weather/core/resources/data_state.dart';
import 'package:weather/features/feature_map/data/model/neshan_response_model.dart';
import 'package:weather/features/feature_map/data/source/remote/api_provider.dart';
import 'package:weather/features/feature_map/domain/entities/neshan_response_entity.dart';
import 'package:weather/features/feature_map/domain/repository/map_repository.dart';
import 'package:weather/locator.dart';

class MapRepositoryImpl extends MapRepository {

  final NeshanApiProvider neshanApiProvider = getIt.get<NeshanApiProvider>();

  @override
  Future<DataState<NeshanResponseEntity>> fetchNeshanRoutes({required NeshanRouteParams neshanRouteParams}) async {
    try {
      Response response = await neshanApiProvider.getNeshanRoutes(origin: neshanRouteParams.origin, destination: neshanRouteParams.destination);
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data is Map<String, dynamic> &&
          response.data['routes'] != null &&
          response.data['routes'] is List &&
          (response.data['routes'] as List).isNotEmpty
      ) {
        return DataSuccess(NeshanResponseModel.fromJson(response.data));
      } else {
        return const DataFailed('Something went wrong. try again...');
      }

    } catch (e) {
      debugPrint(e.toString());
      return const DataFailed('):');
    }
  }

}