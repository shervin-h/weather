part of 'bookmark_bloc.dart';

@immutable
abstract class BookmarkEvent {}

class GetAllCitiesEvent extends BookmarkEvent {}

class GetCityByNameEvent extends BookmarkEvent {
  final String cityName;
  GetCityByNameEvent(this.cityName);
}

class SaveCityEvent extends BookmarkEvent {
  final String cityName;
  SaveCityEvent(this.cityName);
}

class SaveCityInitialEvent extends BookmarkEvent {}

class DeleteCityByNameEvent extends BookmarkEvent {
  final String cityName;
  DeleteCityByNameEvent(this.cityName);
}