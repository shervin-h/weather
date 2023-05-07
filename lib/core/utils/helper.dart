import 'dart:math';
import 'package:intl/intl.dart';
import 'package:location/location.dart';


String getRelatedWallpaperPath() {
  int hour = int.parse(DateFormat('HH').format(DateTime.now()));
  int random = Random().nextInt(5);
  if (hour >= 5 && hour < 12) {
    return 'assets/images/morning_$random.jpg';
  } else if (hour >= 12 && hour < 17) {
    return 'assets/images/afternoon_$random.jpg';
  } else if (hour >= 17 && hour < 20) {
    return 'assets/images/evening_$random.jpg';
  } else {
    return 'assets/images/night_$random.jpg';
  }
}

Future<dynamic> getLocationData() async {
  Location location = Location();

  // check location service is enable or not
  if (!(await location.serviceEnabled())) {
    if (!(await location.requestService())) {
      return 'Location service is off';
    }
  }

  // check has permission to access location or not
  PermissionStatus status = await location.hasPermission();
  if (status == PermissionStatus.denied || status == PermissionStatus.deniedForever) {
    status = await location.requestPermission();
    if (status != PermissionStatus.granted || status != PermissionStatus.grantedLimited) {
      return 'Access to the location service was not granted! \nPermission denied ):';
    }
  }

  // now location service is enable and we has location permission
  return await location.getLocation();
}