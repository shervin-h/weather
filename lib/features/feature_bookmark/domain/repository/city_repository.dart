import 'package:weather/core/resources/data_state.dart';
import 'package:weather/features/feature_bookmark/domain/entities/city_entity.dart';

abstract class CityRepository {

  Future<DataState<CityEntity>> saveCityToDB(String cityName);
  Future<DataState<List<CityEntity>>> getAllCitiesFromDB();
  Future<DataState<CityEntity?>> findCityByName(String name);
  Future<DataState<String>> deleteCityByName(String name);
}