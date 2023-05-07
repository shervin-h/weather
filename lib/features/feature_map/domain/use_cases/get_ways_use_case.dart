import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather/core/resources/data_state.dart';
import 'package:weather/features/feature_map/domain/entities/neshan_response_entity.dart';

import '../../../../core/utils/polyline_extension.dart';
import '../../data/model/neshan_response_model.dart';

class GetWaysUseCase {

  DataState<List<List<LatLng>>> call(NeshanResponseEntity neshanResponseEntity) {
    try {
      List<List<LatLng>> ways = [];
      for (NeshanRoute route in neshanResponseEntity.routes!) {
        ways.add(decodePolyline(route.overviewPolyline!.points!).unpackPolyline());
      }
      return DataSuccess(ways);
    } catch (e) {
      debugPrint(e.toString());
      return const DataFailed('Error in decoding and unpacking poly lines! ):');
    }
  }
}