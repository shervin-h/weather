import 'package:equatable/equatable.dart';

class GeoCityEntity extends Equatable {
  final int? id;
  final String? wikiDataId;
  final String? type;
  final String? city;
  final String? name;
  final String? country;
  final String? countryCode;
  final String? region;
  final String? regionCode;
  final double? latitude;
  final double? longitude;
  final int? population;

  const GeoCityEntity({
    this.id,
    this.wikiDataId,
    this.type,
    this.city,
    this.name,
    this.country,
    this.countryCode,
    this.region,
    this.regionCode,
    this.latitude,
    this.longitude,
    this.population,
  });

  @override
  List<Object?> get props => [];
}
