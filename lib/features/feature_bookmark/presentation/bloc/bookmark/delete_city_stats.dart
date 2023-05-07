import 'package:equatable/equatable.dart';

abstract class DeleteCityStatus extends Equatable {}

class DeleteCityInitialStatus extends DeleteCityStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DeleteCityLoadingStatus extends DeleteCityStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DeleteCityCompletedStatus extends DeleteCityStatus {
  final String cityName;
  DeleteCityCompletedStatus(this.cityName);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DeleteCityErrorStatus extends DeleteCityStatus {
  final String errorMessage;
  DeleteCityErrorStatus(this.errorMessage);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}