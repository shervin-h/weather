import 'package:equatable/equatable.dart';

import '../../data/model/neshan_response_model.dart';

class NeshanResponseEntity extends Equatable {
  final List<NeshanRoute>? routes;

  const NeshanResponseEntity({required this.routes});

  @override
  List<Object?> get props => [routes];
}