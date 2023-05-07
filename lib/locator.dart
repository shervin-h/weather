import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:weather/features/feature_bookmark/data/data_source/local/city_dao.dart';
import 'package:weather/features/feature_bookmark/data/data_source/local/database.dart';
import 'package:weather/features/feature_bookmark/data/repository/city_repository_impl.dart';
import 'package:weather/features/feature_bookmark/domain/repository/city_repository.dart';
import 'package:weather/features/feature_bookmark/presentation/bloc/bookmark/bookmark_bloc.dart';
import 'package:weather/features/feature_map/data/repository/map_repository_impl.dart';
import 'package:weather/features/feature_map/data/source/remote/api_provider.dart';
import 'package:weather/features/feature_map/domain/repository/map_repository.dart';
import 'package:weather/features/feature_map/presentation/bloc/map_bloc.dart';
import 'package:weather/features/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:weather/features/feature_weather/data/repository/weather_repository_implementation.dart';
import 'package:weather/features/feature_weather/domain/repository/weather_repository.dart';
import 'package:weather/features/feature_weather/presentation/bloc/splash/splash_bloc.dart';

import 'features/feature_weather/presentation/bloc/weather/weather_bloc.dart';


final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton<PageController>(PageController(initialPage: 0));

  // remote or local data sources
  getIt.registerSingleton<ApiProvider>(ApiProvider());
  getIt.registerSingleton<NeshanApiProvider>(NeshanApiProvider());


  // database and dao objects
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final cityDao = database.cityDao;
  getIt.registerSingleton<AppDatabase>(database);
  getIt.registerSingleton<CityDao>(cityDao);


  // before repositories API Providers and DAO objects must be registered
  // repositories
  getIt.registerSingleton<WeatherRepository>(WeatherRepositoryImpl());
  getIt.registerSingleton<CityRepository>(CityRepositoryImpl());
  getIt.registerSingleton<MapRepository>(MapRepositoryImpl());


  // bloc
  getIt.registerSingleton<WeatherBloc>(WeatherBloc());
  getIt.registerSingleton<SplashBloc>(SplashBloc());
  getIt.registerSingleton<BookmarkBloc>(BookmarkBloc());
  getIt.registerSingleton<MapBloc>(MapBloc());


  // use cases
}