import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'city_dao.dart';
import 'package:weather/features/feature_bookmark/domain/entities/city_entity.dart';

part 'database.g.dart';


@Database(version: 1, entities: [CityEntity ])
abstract class AppDatabase extends FloorDatabase {
  CityDao get cityDao;
}