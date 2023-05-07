import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:weather/features/feature_weather/domain/use_cases/is_online_usecase.dart';

import '../../../../../core/resources/data_state.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashLoadingState()) {
    on<SplashEvent>((event, emit) {

    });

    on<SplashStartedEvent>((event, emit) async {
      emit(SplashLoadingState());
      await IsOnlineUseCase()().then((DataState<bool> dataState) {
        if (dataState is DataSuccess) {
          emit(SplashCompletedState());
        }
        if (dataState is DataFailed) {
          emit(SplashErrorState(dataState.error!));
        }
      });
    });
  }
}
