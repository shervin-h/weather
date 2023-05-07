import 'package:equatable/equatable.dart';
import 'package:weather/features/feature_bookmark/domain/entities/city_entity.dart';

abstract class SaveCityStatus extends Equatable {}

class SaveCityInitialStatus extends SaveCityStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SaveCityLoadingStatus extends SaveCityStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SaveCityCompletedStatus extends SaveCityStatus {
  final CityEntity cityEntity;
  SaveCityCompletedStatus(this.cityEntity);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SaveCityErrorStatus extends SaveCityStatus {
  final String errorMessage;
  SaveCityErrorStatus(this.errorMessage);
  
  @override
  // TODO: implement props
  List<Object?> get props => [];
}