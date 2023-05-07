import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weather/core/resources/data_state.dart';
import 'package:weather/features/feature_bookmark/domain/use_cases/delete_city_usecase.dart';
import 'package:weather/features/feature_bookmark/domain/use_cases/find_city_usecase.dart';
import 'package:weather/features/feature_bookmark/domain/use_cases/get_all_cities_usecase.dart';
import 'package:weather/features/feature_bookmark/domain/use_cases/save_city_usecase.dart';
import 'package:weather/features/feature_bookmark/presentation/bloc/bookmark/get_all_cities_status.dart';
import 'package:weather/features/feature_bookmark/presentation/bloc/bookmark/get_city_status.dart';
import 'package:weather/features/feature_bookmark/presentation/bloc/bookmark/save_city_status.dart';

import '../../../domain/entities/city_entity.dart';
import 'delete_city_stats.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc() : super(
      BookmarkState(
        saveCityStatus: SaveCityInitialStatus(),
        getCityStatus: GetCityLoadingStatus(),
        getAllCitiesStatus: GetAllCitiesLoadingStatus(),
        deleteCityStatus: DeleteCityInitialStatus(),
      )
  ) {
    on<BookmarkEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetCityByNameEvent>((event, emit) async {
      emit(state.copyWith(newGetCityStatus: GetCityLoadingStatus()));
      await FindCityUseCase()(event.cityName).then((DataState<CityEntity?> dataState) {
        if (dataState is DataSuccess) {
          emit(state.copyWith(newGetCityStatus: GetCityCompletedStatus(cityEntity: dataState.data)));
        }
        if (dataState is DataFailed) {
          if (dataState.error != null && dataState.error!.contains('Not Found')) {
            emit(state.copyWith(newGetCityStatus: GetCityCompletedStatus()));
          } else {
            emit(state.copyWith(newGetCityStatus: GetCityErrorStatus(dataState.error!)));
          }
        }
      });
    });

    on<SaveCityEvent>((event, emit) async {
      emit(state.copyWith(newSaveCityStatus: SaveCityLoadingStatus()));
      await SaveCityUseCase()(event.cityName).then((DataState<CityEntity> dataState) {
        if (dataState is DataSuccess) {
          emit(state.copyWith(newSaveCityStatus: SaveCityCompletedStatus(dataState.data!)));
        }
        if (dataState is DataFailed) {
          emit(state.copyWith(newSaveCityStatus: SaveCityErrorStatus(dataState.error!)));
        }
      });
    });

    // set to init again SaveCity ( برای بار دوم ، سوم و .. باید وضعیت دوباره به حالت اول برگردد. و گرنه بوک مارک پر خواهد ماند )
    on<SaveCityInitialEvent>((event, emit) {
      emit(state.copyWith(newSaveCityStatus: SaveCityInitialStatus()));
    });

    on<GetAllCitiesEvent>((event, emit) async {
      emit(state.copyWith(newGetAllCitiesStatus: GetAllCitiesLoadingStatus()));
      await GetAllCitiesUseCase()().then((DataState<List<CityEntity>> dataState) {
        if (dataState is DataSuccess) {
          emit(state.copyWith(newGetAllCitiesStatus: GetAllCitiesCompletedStatus(dataState.data!)));
        }
        if (dataState is DataFailed) {
          emit(state.copyWith(newGetAllCitiesStatus: GetAllCitiesErrorStatus(dataState.error!)));
        }
      });
    });

    on<DeleteCityByNameEvent>((event, emit) async {
      emit(state.copyWith(newDeleteCityStatus: DeleteCityLoadingStatus()));
      await DeleteCityUseCase()(event.cityName).then((DataState<String> dataState) {
        if (dataState is DataSuccess) {
          emit(state.copyWith(newDeleteCityStatus: DeleteCityCompletedStatus(dataState.data!)));
        }
        if (dataState is DataFailed) {
          emit(state.copyWith(newDeleteCityStatus: DeleteCityErrorStatus(dataState.error!)));
        }
      });

    });


  }
}
