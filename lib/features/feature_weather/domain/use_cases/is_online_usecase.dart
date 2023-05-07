import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/usecase/use_case.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:weather/features/feature_weather/data/data_source/remote/api_provider.dart';

import '../../../../locator.dart';

class IsOnlineUseCase extends NoParamUseCase<DataState<bool>> {

  final ApiProvider apiProvider = getIt.get<ApiProvider>();

  @override
  Future<DataState<bool>> call() async {
    try {
      // final connectivityResult = await (Connectivity().checkConnectivity());
      // if (connectivityResult == ConnectivityResult.mobile ||
      //     connectivityResult == ConnectivityResult.wifi) {
        Response response = await apiProvider.isOnline();
        if (response.statusCode == 200) {
          return const DataSuccess(true);
        } else {
          return const DataFailed('Please check your connection ...');
        }
      // } else {
      //   return const DataFailed('Please turn on device wifi or data ...');
      // }
    } catch (e) {
      debugPrint(e.toString());
      return const DataFailed('Please check your internet connection!');
    }

  }


}