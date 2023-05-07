import 'package:equatable/equatable.dart';

import '../../../domain/entities/city_entity.dart';

abstract class GetAllCitiesStatus extends Equatable {}

class GetAllCitiesLoadingStatus extends GetAllCitiesStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetAllCitiesCompletedStatus extends GetAllCitiesStatus {
  final List<CityEntity> cities;
  GetAllCitiesCompletedStatus(this.cities);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetAllCitiesErrorStatus extends GetAllCitiesStatus {
  final String errorMessage;
  GetAllCitiesErrorStatus(this.errorMessage);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}