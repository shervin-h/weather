import 'package:weather/features/feature_map/domain/entities/neshan_response_entity.dart';

class NeshanResponseModel extends NeshanResponseEntity {

  const NeshanResponseModel({List<NeshanRoute>? neshanRoutes}) : super(routes: neshanRoutes);

  factory NeshanResponseModel.fromJson(Map<String, dynamic> json) {
    List<NeshanRoute> routes = <NeshanRoute>[];
    if (json['routes'] != null) {
      json['routes'].forEach((v) {
        routes.add(NeshanRoute.fromJson(v));
      });
    }

    return NeshanResponseModel(neshanRoutes: routes);
  }
}

class NeshanRoute {
  OverviewPolyline? overviewPolyline;
  List<Legs>? legs;

  NeshanRoute({this.overviewPolyline, this.legs});

  NeshanRoute.fromJson(Map<String, dynamic> json) {
    overviewPolyline = json['overview_polyline'] != null ? OverviewPolyline.fromJson(json['overview_polyline']) : null;
    if (json['legs'] != null) {
      legs = <Legs>[];
      json['legs'].forEach((v) {
        legs!.add(Legs.fromJson(v));
      });
    }
  }

}

class OverviewPolyline {
  String? points;

  OverviewPolyline({this.points});

  OverviewPolyline.fromJson(Map<String, dynamic> json) {
    points = json['points'];
  }
}

class Legs {
  String? summary;
  Distance? distance;
  Distance? duration;
  List<Steps>? steps;

  Legs({this.summary, this.distance, this.duration, this.steps});

  Legs.fromJson(Map<String, dynamic> json) {
    summary = json['summary'];
    distance = json['distance'] != null ? Distance.fromJson(json['distance']) : null;
    duration = json['duration'] != null ? Distance.fromJson(json['duration']) : null;
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(Steps.fromJson(v));
      });
    }
  }
}

class Distance {
  num? value;
  String? text;

  Distance({this.value, this.text});

  Distance.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
  }
}

class Steps {
  String? name;
  String? instruction;
  num? bearingAfter;
  String? type;
  Distance? distance;
  Distance? duration;
  String? polyline;
  List<double>? startLocation;
  String? modifier;
  num? exit;
  String? rotaryName;

  Steps({
    this.name,
    this.instruction,
    this.bearingAfter,
    this.type,
    this.distance,
    this.duration,
    this.polyline,
    this.startLocation,
    this.modifier,
    this.exit,
    this.rotaryName,
  });

  Steps.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    instruction = json['instruction'];
    bearingAfter = json['bearing_after'];
    type = json['type'];
    distance = json['distance'] != null ? Distance.fromJson(json['distance']) : null;
    duration = json['duration'] != null ? Distance.fromJson(json['duration']) : null;
    polyline = json['polyline'];
    startLocation = json['start_location'].cast<double>();
    modifier = json['modifier'];
    exit = json['exit'];
    rotaryName = json['rotaryName'];
  }
}
