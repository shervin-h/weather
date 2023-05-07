import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:weather/core/resources/data_state.dart';
import 'package:weather/features/feature_map/domain/entities/neshan_response_entity.dart';
import 'package:weather/features/feature_map/domain/use_cases/get_user_location_use_case.dart';
import 'package:weather/features/feature_map/presentation/bloc/get_location_status.dart';

import '../../domain/use_cases/get_ways_use_case.dart';
import 'change_location_status.dart';
import 'get_ways_status.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(
      MapState(
        getLocationStatus: GetLocationInitialStatus(),
        selectedLocationStatus: SelectedLocationInitialStatus(),
        getWaysStatus: GetWaysInitialStatus(),
      ),
  ) {
    on<MapEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetLocationEvent>((event, emit) async {
      emit(state.copyWith(newGetLocationStatus: GetLocationLoadingStatus()));

      DataState<LocationData> dataState = await GetUserLocationUseCase()();
      if (dataState is DataSuccess && dataState.data != null) {
        emit(state.copyWith(newGetLocationStatus: GetLocationCompletedStatus(locationData: dataState.data!)));
      } else if (dataState is DataFailed && dataState.error != null) {
        emit(state.copyWith(newGetLocationStatus: GetLocationErrorStatus(errorMessage: dataState.error ?? '):')));
      } else {
        emit(state.copyWith(newGetLocationStatus: GetLocationErrorStatus(errorMessage: '):')));
      }
    });

    on<SelectedLocationEvent>((event, emit){
      // call related use_case
      emit(state.copyWith(newChangeLocationStatus: SelectedLocationLoadingStatus(), newGetWaysStatus: GetWaysInitialStatus(),));
      emit(state.copyWith(newChangeLocationStatus: SelectedLocationCompletedStatus(latLng: event.latLng)));
    });

    on<GetWaysEvent>((event, emit) {
      emit(state.copyWith(newGetWaysStatus: GetWaysLoadingStatus()));
      DataState<List<List<LatLng>>> dataState = GetWaysUseCase()(event.neshanResponseEntity);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newGetWaysStatus: GetWaysCompletedStatus(ways: dataState.data!)));
      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newGetWaysStatus: GetWaysErrorStatus(errorMessage: dataState.error!)));
      }
    });

  }
}
