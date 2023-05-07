import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather/features/feature_map/data/source/remote/api_service.dart';

class NeshanApiProvider {

  Future<Response> getNeshanRoutes({required LatLng origin, required LatLng destination}) async {
    Response response = await ApiService.getInstance().get(
      'direction',
      queryParameters: {
        'type': 'car',
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
      }
    );
    return response;
  }
}