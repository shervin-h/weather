import 'package:flutter/cupertino.dart';
import 'package:weather/core/resources/data_state.dart';
import 'package:weather/features/feature_bookmark/data/data_source/local/city_dao.dart';
import 'package:weather/features/feature_bookmark/domain/entities/city_entity.dart';
import 'package:weather/features/feature_bookmark/domain/repository/city_repository.dart';
import 'package:weather/locator.dart';

class CityRepositoryImpl extends CityRepository {

  // final CityDao cityDao;
  // CityRepositoryImpl(this.cityDao);

  final CityDao cityDao = getIt.get<CityDao>();

  @override
  Future<DataState<String>> deleteCityByName(String name) async {
    try {
      bool? result = await cityDao.deleteCityByName(name);
      if (result != null && result) {
        return DataSuccess('$name successfully deleted.');
      } else {
        return const DataFailed('Not delete :(');
      }
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<CityEntity?>> findCityByName(String name) async {
    try {
      CityEntity? cityEntity = await cityDao.findCityByName(name);
      if (cityEntity != null) {
        return DataSuccess(cityEntity);
      } else {
        return const DataFailed('Not Found !');
      }
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<List<CityEntity>>> getAllCitiesFromDB() async {
    try {
      List<CityEntity> cities = await cityDao.getAllCities();
      return DataSuccess(cities);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<CityEntity>> saveCityToDB(String cityName) async {
    try {

      // check city exist or not
      CityEntity? city = await cityDao.findCityByName(cityName);
      if (city != null) {
        return DataFailed('$cityName is already exist.');
      }

      CityEntity cityEntity = CityEntity(name: cityName);
      int result = await cityDao.insertCity(cityEntity);
      if (result > 0) {
        return DataSuccess(cityEntity);
      }
      return const DataFailed('Not inserted !');
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.toString());
    }
  }


}