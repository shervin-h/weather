part of 'map_bloc.dart';

// @immutable
// abstract class MapState {}
//
// class MapInitial extends MapState {}
//
// class GetLocationLoadingState extends MapState {}
//
// class GetLocationCompetedState extends MapState {
//   final LocationData locationData;
//   GetLocationCompetedState({required this.locationData});
// }
//
// class GetLocationErrorState extends MapState {
//   final String errorMessage;
//   GetLocationErrorState(this.errorMessage);
// }


class MapState extends Equatable {
  GetLocationStatus getLocationStatus;
  SelectedLocationStatus selectedLocationStatus;
  GetWaysStatus getWaysStatus;

  MapState({
    required this.getLocationStatus,
    required this.selectedLocationStatus,
    required this.getWaysStatus,
  });

  MapState copyWith({
    GetLocationStatus? newGetLocationStatus,
    SelectedLocationStatus? newChangeLocationStatus,
    GetWaysStatus? newGetWaysStatus,
  }) {
    return MapState(
      getLocationStatus: newGetLocationStatus ?? getLocationStatus,
      selectedLocationStatus: newChangeLocationStatus ?? selectedLocationStatus,
      getWaysStatus: newGetWaysStatus ?? getWaysStatus,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [getLocationStatus, selectedLocationStatus, getWaysStatus];
}