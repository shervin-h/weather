
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather/core/params/forecast_params.dart';
import 'package:weather/core/resources/data_state.dart';
import 'package:weather/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:weather/features/feature_weather/domain/use_cases/get_forecast_weather_usecase.dart';

import '../../../domain/entities/current_weather_city_entity.dart';
import '../../../domain/entities/forecast_weather_entity.dart';
import 'current_weather_status.dart';
import 'forecast_weather_status.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherState(CurrentWeatherLoadingStatus(), ForecastWeatherLoadingStatus(), 0)) {

    on<LoadCurrentWeatherEvent>((event, emit) async {
      emit(state.copyWith(newCurrentWeatherStatus: CurrentWeatherLoadingStatus()));
      await GetCurrentWeatherUseCase()(event.cityName).then((DataState<CurrentWeatherCityEntity> dataState) {
        if (dataState is DataSuccess) {
          emit(state.copyWith(newCurrentWeatherStatus: CurrentWeatherCompletedStatus(dataState.data!)));
        }
        if (dataState is DataFailed) {
          emit(state.copyWith(newCurrentWeatherStatus: CurrentWeatherErrorStatus(dataState.error!)));
        }
      });
    });

    on<LoadForecastWeatherEvent>((event, emit) async {
      emit(state.copyWith(newForecastWeatherStatus: ForecastWeatherLoadingStatus()));
      await GetForecastWeatherUseCase()(event.forecastParams).then((DataState<ForecastWeatherEntity> dataState) {
        if (dataState is DataSuccess) {
          emit(state.copyWith(newForecastWeatherStatus: ForecastWeatherCompletedStatus(dataState.data!)));
        }
        if (dataState is DataFailed) {
          emit(state.copyWith(newForecastWeatherStatus: ForecastWeatherErrorStatus(dataState.error!)));
        }
      });
    });

    on<ChangeForecastItemEvent>((event, emit){
      emit(state.copyWith(newSelectedIndex: event.selectedIndex));
    });

  }
}

