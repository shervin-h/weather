import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/usecase/use_case.dart';
import 'package:weather/locator.dart';

import '../../../../core/utils/helper.dart';

class GetUserLocationUseCase extends NoParamUseCase<DataState<LocationData>> {

  @override
  Future<DataState<LocationData>> call() async {
    try {
      final result = await getLocationData();
      if (result is LocationData) {
        return DataSuccess(result);
      } else {
        return DataFailed(result.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      return const DataFailed('Error while getting user location ):');
    }
  }
}