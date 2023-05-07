import 'package:floor/floor.dart';
import 'package:weather/features/feature_bookmark/domain/entities/city_entity.dart';

@dao
abstract class CityDao {
  @Query('SELECT * FROM CityEntity')
  Future<List<CityEntity>> getAllCities();

  @Query('SELECT * FROM CityEntity WHERE name = :name')
  Future<CityEntity?> findCityByName(String name);

  @insert
  Future<int> insertCity(CityEntity cityEntity);

  @Query('DELETE FROM CityEntity WHERE name = :name')
  Future<bool?> deleteCityByName(String name);
}