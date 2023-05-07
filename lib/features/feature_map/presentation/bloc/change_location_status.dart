
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

abstract class SelectedLocationStatus {}

class SelectedLocationInitialStatus extends SelectedLocationStatus {}

class SelectedLocationLoadingStatus extends SelectedLocationStatus {}

class SelectedLocationCompletedStatus extends SelectedLocationStatus {
  final LatLng latLng;
  SelectedLocationCompletedStatus({required this.latLng});
}

class SelectedLocationErrorStatus extends SelectedLocationStatus {
  final String errorMessage;
  SelectedLocationErrorStatus({required this.errorMessage});
}