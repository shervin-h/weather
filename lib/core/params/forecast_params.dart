import 'package:latlong2/latlong.dart';

class ForecastParams {
  num lat;
  num long;
  ForecastParams({required this.lat, required this.long});
}

class NeshanRouteParams {
  LatLng origin;
  LatLng destination;

  NeshanRouteParams({required this.origin, required this.destination});
}