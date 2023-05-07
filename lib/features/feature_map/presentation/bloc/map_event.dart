part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class GetLocationEvent extends MapEvent {}

class SelectedLocationEvent extends MapEvent {
  final LatLng latLng;
  SelectedLocationEvent({required this.latLng});
}

class GetWaysEvent extends MapEvent {
  final NeshanResponseEntity neshanResponseEntity;
  GetWaysEvent({required this.neshanResponseEntity});
}
