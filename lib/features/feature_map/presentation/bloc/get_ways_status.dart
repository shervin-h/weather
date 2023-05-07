import 'package:latlong2/latlong.dart';

abstract class GetWaysStatus {}

class GetWaysInitialStatus extends GetWaysStatus {}

class GetWaysLoadingStatus extends GetWaysStatus {}

class GetWaysCompletedStatus extends GetWaysStatus {
  final List<List<LatLng>> ways;
  GetWaysCompletedStatus({required this.ways});
}

class GetWaysErrorStatus extends GetWaysStatus {
  final String errorMessage;
  GetWaysErrorStatus({required this.errorMessage});
}