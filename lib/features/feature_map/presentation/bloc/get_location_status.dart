import 'package:location/location.dart';

abstract class GetLocationStatus {}

class GetLocationInitialStatus extends GetLocationStatus {}

class GetLocationLoadingStatus extends GetLocationStatus {}

class GetLocationCompletedStatus extends GetLocationStatus {
  final LocationData locationData;
  GetLocationCompletedStatus({required this.locationData});
}

class GetLocationErrorStatus extends GetLocationStatus {
  final String errorMessage;
  GetLocationErrorStatus({required this.errorMessage});
}
