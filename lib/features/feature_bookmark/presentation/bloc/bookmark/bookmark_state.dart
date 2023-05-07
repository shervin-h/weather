part of 'bookmark_bloc.dart';

@immutable
class BookmarkState extends Equatable {

  SaveCityStatus saveCityStatus;
  GetCityStatus getCityStatus;
  GetAllCitiesStatus getAllCitiesStatus;
  DeleteCityStatus deleteCityStatus;

  BookmarkState({
    required this.saveCityStatus,
    required this.getCityStatus,
    required this.getAllCitiesStatus,
    required this.deleteCityStatus,
  });

  BookmarkState copyWith({
    SaveCityStatus? newSaveCityStatus,
    GetCityStatus? newGetCityStatus,
    GetAllCitiesStatus? newGetAllCitiesStatus,
    DeleteCityStatus? newDeleteCityStatus,
  }) {
    return BookmarkState(
      saveCityStatus: newSaveCityStatus ?? saveCityStatus,
      getCityStatus: newGetCityStatus ?? getCityStatus,
      getAllCitiesStatus: newGetAllCitiesStatus ?? getAllCitiesStatus,
      deleteCityStatus: newDeleteCityStatus ?? deleteCityStatus,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [saveCityStatus, getCityStatus, getAllCitiesStatus, deleteCityStatus];

}
