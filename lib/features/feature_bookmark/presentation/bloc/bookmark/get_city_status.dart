import 'package:equatable/equatable.dart';
import 'package:weather/features/feature_bookmark/domain/entities/city_entity.dart';

abstract class GetCityStatus extends Equatable {}

class GetCityInitialStatus extends GetCityStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetCityLoadingStatus extends GetCityStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetCityCompletedStatus extends GetCityStatus {
  final CityEntity? cityEntity;
  GetCityCompletedStatus({this.cityEntity});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetCityErrorStatus extends GetCityStatus {
  final String errorMessage;
  GetCityErrorStatus(this.errorMessage);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}