import 'package:weather/features/feature_weather/domain/entities/geo_city_entity.dart';

class GeoCityModel extends GeoCityEntity {
  const GeoCityModel({
    int? id,
    String? wikiDataId,
    String? type,
    String? city,
    String? name,
    String? country,
    String? countryCode,
    String? region,
    String? regionCode,
    double? latitude,
    double? longitude,
    int? population,
  }) : super(
    id: id,
    wikiDataId: wikiDataId,
    type: type,
    city: city,
    name: name,
    country: country,
    countryCode: countryCode,
    region: region,
    regionCode: regionCode,
    latitude: latitude,
    longitude: longitude,
    population: population,
  );

  factory GeoCityModel.fromJson(Map<String, dynamic> json) {
    return GeoCityModel(
      id: json['id'],
      wikiDataId: json['wikiDataId'],
      type: json['type'],
      city: json['city'],
      name: json['name'],
      country: json['country'],
      countryCode: json['countryCode'],
      region: json['region'],
      regionCode: json['regionCode'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      population: json['population'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['wikiDataId'] = wikiDataId;
  //   data['type'] = type;
  //   data['city'] = city;
  //   data['name'] = name;
  //   data['country'] = country;
  //   data['countryCode'] = countryCode;
  //   data['region'] = region;
  //   data['regionCode'] = regionCode;
  //   data['latitude'] = latitude;
  //   data['longitude'] = longitude;
  //   data['population'] = population;
  //   return data;
  // }
}
