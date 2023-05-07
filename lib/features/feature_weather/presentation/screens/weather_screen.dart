import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:weather/core/params/forecast_params.dart';
import 'package:weather/core/utils/date_time_helper.dart';
import 'package:weather/core/utils/helper.dart';
import 'package:weather/core/widgets/inner_shadow_widget.dart';
import 'package:weather/core/widgets/loading_widget.dart';
import 'package:weather/core/widgets/speech_to_text.dart';
import 'package:weather/features/feature_bookmark/domain/entities/city_entity.dart';
import 'package:weather/features/feature_bookmark/presentation/bloc/bookmark/bookmark_bloc.dart';
import 'package:weather/features/feature_bookmark/presentation/bloc/bookmark/get_city_status.dart';
import 'package:weather/features/feature_bookmark/presentation/bloc/bookmark/save_city_status.dart';
import 'package:weather/features/feature_weather/data/models/forecast_weather_model.dart';
import 'package:weather/features/feature_weather/domain/entities/current_weather_city_entity.dart';
import 'package:weather/features/feature_weather/domain/use_cases/get_suggestion_cities_usecase.dart';

import '../../../../core/resources/data_state.dart';
import '../../domain/entities/geo_city_entity.dart';
import '../bloc/weather/current_weather_status.dart';
import '../bloc/weather/forecast_weather_status.dart';
import '../bloc/weather/weather_bloc.dart';
import '../widgets/app_bar_weather_widget.dart';
import '../widgets/forecast_item_widget.dart';
import '../widgets/weather_element.dart';
import 'forecast_screen.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({this.defaultCityName = 'Tehran', Key? key}) : super(key: key);

  static const String routeName = '/weather-screen';

  final String defaultCityName;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> with AutomaticKeepAliveClientMixin {
  late final TextEditingController _suggestionController;
  late final FocusNode _suggestionFocusNode;
  late final GetSuggestionCitiesUseCase getSuggestionCitiesUseCase;

  @override
  void initState() {
    super.initState();
    _suggestionController = TextEditingController();
    _suggestionFocusNode = FocusNode();
    getSuggestionCitiesUseCase = GetSuggestionCitiesUseCase();

    BlocProvider.of<WeatherBloc>(context, listen: false).add(LoadCurrentWeatherEvent(widget.defaultCityName));
  }

  @override
  void dispose() {
    _suggestionController.dispose();
    _suggestionFocusNode.dispose();
    super.dispose();
  }

  Color _selectSuitableColor(num temp) {
    if (temp <= 0) {
      return Colors.blue;
    } else if (temp <= 10) {
      return Colors.lightBlue;
    } else if (temp <= 15) {
      return Colors.green;
    } else if (temp <= 20) {
      return Colors.greenAccent;
    } else if (temp <= 30) {
      return Colors.deepOrange;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            BlocBuilder<WeatherBloc, WeatherState>(
              buildWhen: (previous, current) {
                if (previous.currentWeatherStatus == current.currentWeatherStatus) {
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                if (state.currentWeatherStatus is CurrentWeatherLoadingStatus) {
                  return const LoadingWidget();
                } else if (state.currentWeatherStatus is CurrentWeatherCompletedStatus) {
                  final currentWeatherCityEntity =
                      (state.currentWeatherStatus as CurrentWeatherCompletedStatus).currentWeatherCityEntity;
                  ForecastParams forecastParams = ForecastParams(
                    lat: currentWeatherCityEntity.coord!.lat!,
                    long: currentWeatherCityEntity.coord!.lon!,
                  );
                  BlocProvider.of<WeatherBloc>(context, listen: false).add(LoadForecastWeatherEvent(forecastParams));
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // SliverAppBar(
                      //   expandedHeight: context.height * 0.4,
                      //   backgroundColor: Colors.transparent,
                      //   flexibleSpace: AppBarFlexibleWidget(
                      //     height: context.height * 0.4,
                      //     currentWeatherCityEntity: currentWeatherCityEntity,
                      //   ),
                      // ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(height: context.height * 0.1),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  FittedBox(
                                    child: Container(
                                      margin: const EdgeInsets.all(8),
                                      width: context.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: context.theme.colorScheme.background,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${currentWeatherCityEntity.sys!.country}, ',
                                                style: context.textTheme.headline6,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${currentWeatherCityEntity.name}',
                                                  style: context.textTheme.headline4,
                                                  // textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    DateFormat.yMMMEd().format(convertSecondsToDateTime(int.parse(currentWeatherCityEntity.dt!.toString()))),
                                                    style: context.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                                                  ),
                                                  Text(
                                                      currentDateAsJalali(),
                                                      style: context.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade500)
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Shimmer.fromColors(
                                                baseColor: _selectSuitableColor(currentWeatherCityEntity.main!.temp ?? 25.0),
                                                highlightColor: _selectSuitableColor(currentWeatherCityEntity.main!.temp ?? 25.0).withOpacity(0.4),
                                                child: Image.network(
                                                  'http://openweathermap.org/img/wn/${currentWeatherCityEntity.weather![0].icon}@4x.png',
                                                  errorBuilder: (context, obj, error) {
                                                    return const Icon(
                                                      CupertinoIcons.exclamationmark_circle,
                                                      size: 24,
                                                    );
                                                  },
                                                  width: context.width * 0.3,
                                                  height: context.width * 0.3,
                                                  fit: BoxFit.cover,
                                                  // color: Colors.blue,
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    '${currentWeatherCityEntity.weather![0].main}',
                                                    style: context.textTheme.headline5,
                                                  ),
                                                  Text(
                                                    '${currentWeatherCityEntity.weather![0].description}',
                                                    style: context.textTheme.headline6!.copyWith(color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                InnerShadow(
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.grey.shade900.withOpacity(0.8),
                                                      blurRadius: 8
                                                    )
                                                  ],
                                                  child: Container(
                                                    height: context.height * 0.1,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(16),
                                                      gradient: LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors: [
                                                          Colors.deepOrangeAccent.withOpacity(0.5),
                                                          Colors.red.withOpacity(0.5),
                                                          Colors.purple.withOpacity(0.5)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.all(8),
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text('Min', style: context.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold),),
                                                          Text('${currentWeatherCityEntity.main?.tempMin} \u00B0c', style: context.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold))
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '${currentWeatherCityEntity.main?.tempMin} \u00B0',
                                                          style: context.textTheme.headline1!.copyWith(fontWeight: FontWeight.bold),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text('Max', style: context.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold),),
                                                          Text('${currentWeatherCityEntity.main?.tempMax} \u00B0c', style: context.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    padding: const EdgeInsets.all(4),
                                    width: double.infinity,
                                    height: context.height * 0.3,
                                    decoration: BoxDecoration(
                                      color: context.theme.colorScheme.background,
                                      borderRadius: BorderRadius.circular(16),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: context.theme.colorScheme.shadow,
                                      //     blurRadius: 4,
                                      //   ),
                                      // ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                convertTimestampToHmFormattedString(
                                                  (currentWeatherCityEntity.sys!.sunrise! + currentWeatherCityEntity.timezone!).toInt(),
                                                ),
                                                style: context.textTheme.bodyText2!.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text('Sunrise', style: context.textTheme.caption!.copyWith(fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: _sunriseSunsetRadialGauge(
                                            context: context,
                                            currentWeatherCityEntity: currentWeatherCityEntity,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                convertTimestampToHmFormattedString(
                                                  (currentWeatherCityEntity.sys!.sunset! + currentWeatherCityEntity.timezone!).toInt(),
                                                ),
                                                style: context.textTheme.bodyText2!.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Sunset',
                                                style: context.textTheme.caption!.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: context.width,
                                    height: context.width * 0.6,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.all(8),
                                            padding: const EdgeInsets.all(4),
                                            child: _getWindSpeedRadialGauge(context: context, pointerValue: currentWeatherCityEntity.wind!.speed!.toDouble()),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.all(8),
                                            padding: const EdgeInsets.all(4),
                                            child: _getWindDegreeRadialGauge(context: context, pointerValue: currentWeatherCityEntity.wind!.deg!.toDouble()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: context.width,
                                    height: context.width * 0.6,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.all(8),
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: context.theme.colorScheme.background,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: _getPressureRadialGauge(
                                              context: context,
                                              pointerValue: currentWeatherCityEntity.main!.pressure!.toDouble(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: context.width,
                                    height: context.width * 0.6,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.all(8),
                                            padding: const EdgeInsets.all(4),
                                            child: _getHumidityRadialGauge(context: context, pointerValue: currentWeatherCityEntity.main!.humidity!.toDouble()),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.all(8),
                                            padding: const EdgeInsets.all(4),
                                            child: _getCloudinessRadialGauge(context: context, pointerValue: currentWeatherCityEntity.clouds!.all!.toDouble()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BlocBuilder<WeatherBloc, WeatherState>(
                              buildWhen: (previous, current) {
                                if (previous.forecastWeatherStatus == current.forecastWeatherStatus) {
                                  return false;
                                }
                                return true;
                              },
                              builder: (context, state) {
                                if (state.forecastWeatherStatus is ForecastWeatherLoadingStatus) {
                                  return const LoadingWidget();
                                } else if (state.forecastWeatherStatus is ForecastWeatherCompletedStatus) {
                                  final forecastWeatherEntity = (state.forecastWeatherStatus as ForecastWeatherCompletedStatus).forecastWeatherEntity;
                                  final forecastData = forecastWeatherEntity.forecastData!;
                                  return Column(
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        'Forecast 5 Days',
                                        style: context.textTheme.bodyText1!.copyWith(
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: context.width,
                                        height: context.height * 0.3,
                                        child: BlocConsumer<WeatherBloc, WeatherState>(
                                          buildWhen: (previous, current) {
                                            if (previous.selectedItemIndex == current.selectedItemIndex) {
                                              return false;
                                            }
                                            return true;
                                          },
                                          builder: (context, state) {
                                            return ListView.builder(
                                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                                              physics: const BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: forecastData.length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    BlocProvider.of<WeatherBloc>(context).add(ChangeForecastItemEvent(index));
                                                    final forecasts = <ForecastData>[forecastData[index]];
                                                    if (index + 1 <= forecastData.length - 1) {
                                                      forecasts.add(forecastData[index + 1]);
                                                    }

                                                    final arguments = <String, dynamic>{
                                                      'forecasts': forecasts,
                                                      'city': forecastWeatherEntity.city,
                                                    };

                                                    Future.delayed(
                                                      const Duration(milliseconds: 500),
                                                      () => Navigator.of(context).pushNamed(
                                                        ForecastScreen.routeName,
                                                        arguments: arguments,
                                                      ),
                                                    );
                                                  },
                                                  child: ForecastItemWidget(
                                                    forecastData: forecastData[index],
                                                    nextForecastData: (index + 1 <= forecastData.length - 1)
                                                        ? forecastData[index + 1]
                                                        : null,
                                                    isSelected: index == state.selectedItemIndex,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          listener: (context, state) {},
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (state.forecastWeatherStatus is ForecastWeatherErrorStatus) {
                                  String errorMessage =
                                      (state.forecastWeatherStatus as ForecastWeatherErrorStatus).errorMessage;
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Lottie.asset(
                                          'assets/lottie/error.json',
                                          width: context.width * 0.3,
                                          height: context.width *0.3,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          errorMessage,
                                          style: context.textTheme.headline6!.copyWith(
                                            color: context.theme.errorColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (state.currentWeatherStatus is CurrentWeatherErrorStatus) {
                  String errorMessage = (state.currentWeatherStatus as CurrentWeatherErrorStatus).errorMessage;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/lottie/error.json',
                          width: context.width * 0.3,
                          height: context.width * 0.3,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errorMessage,
                          style: context.textTheme.headline6!.copyWith(
                            color: context.theme.errorColor,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),

            // search box
            Container(
              width: context.width,
              height: context.height * 0.1,
              // alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 6,
                    sigmaY: 6,
                  ),
                  child: TypeAheadField<GeoCityEntity>(
                    textFieldConfiguration: TextFieldConfiguration(
                      // autofocus: true,
                      controller: _suggestionController,
                      focusNode: _suggestionFocusNode,
                      style: DefaultTextStyle.of(context).style.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: 'Enter City ...',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: context.theme.colorScheme.primary),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        prefixIcon: CustomSpeechToText(controller: _suggestionController, focusNode: _suggestionFocusNode,),
                        suffixIcon: Container(
                          width: 50,
                          padding: const EdgeInsets.all(4),
                          child: BlocBuilder<WeatherBloc, WeatherState>(
                            buildWhen: (previous, current) {
                              if (previous.currentWeatherStatus == current.currentWeatherStatus) {
                                return false;
                              }
                              return true;
                            },
                            builder: (context, state) {
                              if (state.currentWeatherStatus is CurrentWeatherLoadingStatus) {
                                return CupertinoActivityIndicator(
                                  color: context.theme.colorScheme.onBackground,
                                  radius: 12,
                                );
                              } else if (state.currentWeatherStatus is CurrentWeatherCompletedStatus) {
                                final currentWeatherCompletedState = state.currentWeatherStatus as CurrentWeatherCompletedStatus;
                                BlocProvider.of<BookmarkBloc>(context).add(GetCityByNameEvent(currentWeatherCompletedState.currentWeatherCityEntity.name!));
                                return IconBookmark(cityName: currentWeatherCompletedState.currentWeatherCityEntity.name!);
                              } else if (state.currentWeatherStatus is CurrentWeatherErrorStatus) {
                                return Center(
                                  child: Icon(
                                    CupertinoIcons.exclamationmark_circle,
                                    color: context.theme.errorColor,
                                    size: 24,
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ),
                      onSubmitted: (prefix) {
                        _suggestionController.text = prefix;
                        if(prefix.trim().isNotEmpty) {
                          BlocProvider.of<WeatherBloc>(context, listen: false).add(LoadCurrentWeatherEvent(prefix));
                        }
                      },
                    ),
                    suggestionsCallback: (String cityName) async {
                      // Future<DataState<List<GeoCityEntity>>>
                      DataState<List<GeoCityEntity>> dataState = await getSuggestionCitiesUseCase(cityName);
                      if (dataState.data != null && dataState.data!.isNotEmpty) {
                        return dataState.data!;
                      }
                      return [];
                    },
                    itemBuilder: (BuildContext context, GeoCityEntity suggestion) {
                      return ListTile(
                        leading: const Icon(
                          CupertinoIcons.location_solid,
                          size: 24,
                        ),
                        title: Text('${suggestion.name}'),
                        subtitle: Text('${suggestion.region}, ${suggestion.country}'),
                      );
                    },
                    onSuggestionSelected: (GeoCityEntity suggestion) {
                      _suggestionController.text = suggestion.name!;
                      BlocProvider.of<WeatherBloc>(context, listen: false)
                          .add(LoadCurrentWeatherEvent(suggestion.name!));
                    },
                    loadingBuilder: (context) {
                      return Center(
                        child: CupertinoActivityIndicator(
                          color: context.theme.colorScheme.primary,
                          radius: 16,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _getHumidityRadialGauge({required BuildContext context, required double pointerValue}) {
  return SfRadialGauge(
    animationDuration: 2000,
    enableLoadingAnimation: true,
    title: GaugeTitle(
      text: '${pointerValue.toInt()} %',
      textStyle: context.textTheme.headline6!,
    ),
    axes: <RadialAxis>[
      RadialAxis(
        minimum: 0,
        maximum: 100,
        startAngle: 180,
        endAngle: 0,
        interval: 20,
        showLabels: false,
        // showAxisLine: false,
        // ticksPosition: ElementsPosition.outside,
        // minorTickStyle: MinorTickStyle(length: context.width * 0.05, color: Colors.white),
        // majorTickStyle: MajorTickStyle(length: context.width * 0.05, thickness: 2, color: Colors.purple),
        ranges: <GaugeRange>[
          GaugeRange(
            startValue: 0,
            endValue: 100,
            gradient: const SweepGradient(
              colors: [
                Colors.purple,
                Colors.blueAccent
              ],
            ),
            startWidth: context.width * 0.07,
            endWidth: context.width * 0.07,
          ),
          // GaugeRange(startValue: 50, endValue: 100, color: Colors.orange, startWidth: 10, endWidth: 10),
          // GaugeRange(startValue: 100, endValue: 150, color: Colors.red, startWidth: 10, endWidth: 10)
        ],
        pointers: <GaugePointer>[
          MarkerPointer(
            value: pointerValue,
            enableAnimation: true,
            color: context.theme.colorScheme.secondary,
            markerHeight: context.width * 0.07 * 0.4,
            markerWidth: context.width * 0.07 * 0.4,
            markerOffset: - (context.width * 0.07 * 0.4),

          ),
          // NeedlePointer(
          //   value: pointerValue,
          //   needleStartWidth: 0,
          //   needleEndWidth: 10,
          //   enableAnimation: true,
          //   needleColor: context.theme.colorScheme.onBackground,
          // ),
        ],
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
            widget: Text(
              'Humidity',
              style: context.textTheme.headline6,
            ),
            angle: 90,
            positionFactor: 0.6,
          ),
          GaugeAnnotation(
            widget: Text(
              'min',
              style: context.textTheme.bodyText1,
            ),
            angle: 180,
            verticalAlignment: GaugeAlignment.near,
            positionFactor: 0.8,
          ),
          GaugeAnnotation(
            widget: Text(
              'max',
              style: context.textTheme.bodyText1,
            ),
            angle: 0,
            verticalAlignment: GaugeAlignment.near,
            positionFactor: 0.8,
          ),
        ],
      ),
    ],
  );
}

Widget _getCloudinessRadialGauge({required BuildContext context, required double pointerValue}) {
  return SfRadialGauge(
    animationDuration: 2000,
    enableLoadingAnimation: true,
    title: GaugeTitle(
      text: '${pointerValue.toInt()} %',
      textStyle: context.textTheme.headline6!,
    ),
    axes: <RadialAxis>[
      RadialAxis(
        minimum: 0,
        maximum: 100,
        startAngle: 180,
        endAngle: 0,
        interval: 20,
        showLabels: false,
        ranges: <GaugeRange>[
          GaugeRange(
            startValue: 0,
            endValue: 100,
            gradient: SweepGradient(
              colors: [
                Colors.lightBlueAccent,
                Colors.lightBlueAccent,
                Colors.lightBlueAccent,
                Colors.white,
                Colors.white,
                Colors.grey.shade400,
              ],
            ),
            startWidth: context.width * 0.07,
            endWidth: context.width * 0.07,
          ),
        ],
        pointers: <GaugePointer>[
          MarkerPointer(
            value: pointerValue,
            enableAnimation: true,
            color: context.theme.colorScheme.secondary,
            markerHeight: context.width * 0.07 * 0.4,
            markerWidth: context.width * 0.07 * 0.4,
            markerOffset: - (context.width * 0.07 * 0.4),

          ),
          // NeedlePointer(
          //   value: pointerValue,
          //   needleStartWidth: 0,
          //   needleEndWidth: 10,
          //   enableAnimation: true,
          //   needleColor: context.theme.colorScheme.onBackground,
          // ),
        ],
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
            widget: Text(
              'Cloudiness',
              style: context.textTheme.headline6,
            ),
            angle: 90,
            positionFactor: 0.6,
          ),
          GaugeAnnotation(
            widget: Text(
              'min',
              style: context.textTheme.bodyText1,
            ),
            angle: 180,
            verticalAlignment: GaugeAlignment.near,
            positionFactor: 0.8,
          ),
          GaugeAnnotation(
            widget: Text(
              'max',
              style: context.textTheme.bodyText1,
            ),
            angle: 0,
            verticalAlignment: GaugeAlignment.near,
            positionFactor: 0.8,
          ),
        ],
      ),
    ],
  );
}

Widget _getPressureRadialGauge({required BuildContext context, required double pointerValue}) {
  // Hectopascal- A unit of pressure equal to a millibar (1 hPa = 1 mb).
  // Definition and conversion
  // The bar is defined using the SI derived unit, pascal: 1 bar ≡ 100,000 Pa ≡ 100,000 N/m2.
  //
  // Thus, 1 bar is equal to:
  //
  // 1,000,000 Ba (barye) (in cgs units);
  // and 1 bar is approximately equal to:
  //
  // 0.986923 atm
  // 14.50377 psi
  // 29.5300 inHg
  // 750.062 mmHg
  // 750.062 Torr
  // 1019.716 centimetres of water (cmH2O) (1 bar approximately corresponds to the gauge pressure of water (not absolute) at a depth of 10 meters).
  // Notes:
  //
  // 1 millibar (mbar) = 1 one-thousandth bar, or 1×10−3 bar
  // 1 millibar = 1 hectopascal (1 hPa = 100 Pa).
  //
  // Atmospheric pressure, also known as barometric pressure (after the barometer), is the pressure within the atmosphere of Earth.
  // The standard atmosphere (symbol: atm) is a unit of pressure defined as 101,325 Pa (1,013.25 hPa), which is equivalent to 1013.25 millibars,[1] 760 mm Hg, 29.9212 inches Hg, or 14.696 psi.[2] The atm unit is roughly equivalent to the mean sea-level atmospheric pressure on Earth; that is, the Earth's atmospheric pressure at sea level is approximately 1 atm.
  //
  // In most circumstances, atmospheric pressure is closely approximated by the hydrostatic pressure caused by the weight of air above the measurement point.
  // As elevation increases, there is less overlying atmospheric mass, so atmospheric pressure decreases with increasing elevation. Because the atmosphere is thin relative to the Earth's radius—especially the dense atmospheric layer at low altitudes—the Earth's gravitational acceleration as a function of altitude can be approximated as constant and contributes little to this fall-off. Pressure measures force per unit area, with SI units of pascals (1 pascal = 1 newton per square metre, 1 N/m2). On average, a column of air with a cross-sectional area of 1 square centimetre (cm2), measured from the mean (average) sea level to the top of Earth's atmosphere, has a mass of about 1.03 kilogram and exerts a force or "weight" of about 10.1 newtons, resulting in a pressure of 10.1 N/cm2 or 101 kN/m2 (101 kilopascals, kPa). A column of air with a cross-sectional area of 1 in2 would have a weight of about 14.7 lbf, resulting in a pressure of 14.7 lbf/in2.

  return SfRadialGauge(
    animationDuration: 2000,
    enableLoadingAnimation: true,
    title: GaugeTitle(
      text: '${(pointerValue * 100).toStringAsFixed(0)} Pa', // convert to pascal => (1 hPa = 100 Pa)
      textStyle: context.textTheme.headline6!,
    ),
    axes: <RadialAxis>[
      RadialAxis(
        minimum: 0,
        maximum: 200000,
        // startAngle: 180,
        // endAngle: 0,
        // interval: 40000,
        // showLabels: true,
        // showAxisLine: true,
        // ticksPosition: ElementsPosition.outside,
        // minorTickStyle: MinorTickStyle(length: context.width * 0.05, color: Colors.white),
        // majorTickStyle: MajorTickStyle(length: context.width * 0.05, thickness: 2, color: Colors.purple),
        axisLineStyle: const AxisLineStyle(
          thicknessUnit: GaugeSizeUnit.factor,
          thickness: 0.2
        ),
        ranges: <GaugeRange>[
          GaugeRange(
            startValue: 0,
            endValue: 200000,
            sizeUnit: GaugeSizeUnit.factor,
            startWidth: 0.16,
            endWidth: 0.16,
            gradient: const SweepGradient(
              colors: [
                Colors.lightBlueAccent,
                Colors.blueAccent
              ],
            ),
            // startWidth: context.width * 0.02,
            // endWidth: context.width * 0.02,
          ),
          // GaugeRange(startValue: 50, endValue: 100, color: Colors.orange, startWidth: 10, endWidth: 10),
          // GaugeRange(startValue: 100, endValue: 150, color: Colors.red, startWidth: 10, endWidth: 10)
        ],
        pointers: <GaugePointer>[
          NeedlePointer(
            value: pointerValue * 100,
            enableAnimation: true,
            needleColor: context.theme.colorScheme.onBackground,
            needleStartWidth: 1,
            needleEndWidth: 6,
            knobStyle: KnobStyle(
              borderWidth: 0.02,
              borderColor: context.theme.colorScheme.background,
            ),
          ),
        ],
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
            widget: Text(
              'Pressure',
              style: context.textTheme.headline6,
            ),
            angle: 90,
            positionFactor: 1,
          ),
        ],
      ),
    ],
  );
}

Widget _getWindSpeedRadialGauge({required BuildContext context, required double pointerValue}) {
  return SfRadialGauge(
    animationDuration: 2000,
    enableLoadingAnimation: true,
    title: GaugeTitle(
      text: '$pointerValue ㎧',
      textStyle: context.textTheme.headline6!,
    ),
    axes: <RadialAxis>[
      RadialAxis(
        minimum: 0,
        maximum: 150,
        // startAngle: 180,
        // endAngle: 0,
        interval: 20,
        // showLabels: true,
        // showAxisLine: true,
        // ticksPosition: ElementsPosition.outside,
        // minorTickStyle: MinorTickStyle(length: context.width * 0.05, color: Colors.white),
        // majorTickStyle: MajorTickStyle(length: context.width * 0.05, thickness: 2, color: Colors.purple),
        axisLineStyle: const AxisLineStyle(
          thicknessUnit: GaugeSizeUnit.factor,
          thickness: 0.14,
        ),
        ranges: <GaugeRange>[
          GaugeRange(
            startValue: 0,
            endValue: 150,
            sizeUnit: GaugeSizeUnit.factor,
            startWidth: 0.14,
            endWidth: 0.14,
            gradient: const SweepGradient(
              colors: [
                Colors.greenAccent,
                Colors.green,
              ],
            ),
          ),
        ],
        pointers: <GaugePointer>[
          NeedlePointer(
            value: pointerValue,
            enableAnimation: true,
            needleColor: context.theme.colorScheme.onBackground,
            needleStartWidth: 1,
            needleEndWidth: 6,
            needleLength: 0.7,
            knobStyle: KnobStyle(
              borderWidth: 0.02,
              borderColor: context.theme.colorScheme.background,
            ),
          ),
        ],
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
            widget: Text(
              'Wind Speed',
              style: context.textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            angle: 90,
            positionFactor: 1.0,
          ),
        ],
      ),
    ],
  );
}

Widget _getWindDegreeRadialGauge({required BuildContext context, required double pointerValue}) {
  return SfRadialGauge(
    animationDuration: 2000,
    enableLoadingAnimation: true,
    title: GaugeTitle(
      text: '$pointerValue \u00B0',
      textStyle: context.textTheme.headline6!,
    ),
    axes: <RadialAxis>[
      RadialAxis(
        minimum: 0,
        maximum: 360,
        startAngle: 0,
        endAngle: 360,
        showLabels: true,
        showFirstLabel: true,
        showLastLabel: false,
        interval: 45,

        // canRotateLabels: true,
        // isInversed: true,
        // showAxisLine: true,
        // ticksPosition: ElementsPosition.outside,
        axisLineStyle: const AxisLineStyle(
          thicknessUnit: GaugeSizeUnit.factor,
          thickness: 0.16,
        ),
        ranges: <GaugeRange>[
          GaugeRange(
            startValue: 0,
            endValue: 360,
            sizeUnit: GaugeSizeUnit.factor,
            startWidth: 0.16,
            endWidth: 0.16,
            gradient: const SweepGradient(
              colors: [
                Colors.orangeAccent,
                Colors.deepOrangeAccent,
                Colors.deepOrangeAccent,
                Colors.orangeAccent,
              ],
            ),
          ),
        ],
        pointers: <GaugePointer>[
          NeedlePointer(
            value: pointerValue,
            enableAnimation: true,
            needleColor: context.theme.colorScheme.onBackground,
            needleStartWidth: 1,
            needleEndWidth: 6,
            needleLength: 0.7,
            knobStyle: KnobStyle(
              borderWidth: 0.02,
              borderColor: context.theme.colorScheme.background,
            ),
          ),
          const MarkerPointer(
            enableAnimation: true,
            value: 0,
            markerType: MarkerType.text,
            text: 'N',
            textStyle: GaugeTextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const MarkerPointer(
            enableAnimation: true,
            value: 90,
            markerType: MarkerType.text,
            text: 'E',
            textStyle: GaugeTextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const MarkerPointer(
            enableAnimation: true,
            value: 180,
            markerType: MarkerType.text,
            text: 'S',
            textStyle: GaugeTextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const MarkerPointer(
            enableAnimation: true,
            value: 270,
            markerType: MarkerType.text,
            text: 'W',
            textStyle: GaugeTextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
            widget: Text(
              'Wind Degree',
              style: context.textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            angle: 90,
            positionFactor: 1.28,
          ),
        ],
      ),
    ],
  );
}

Widget _sunriseSunsetRadialGauge({required BuildContext context, required CurrentWeatherCityEntity currentWeatherCityEntity}) {

  double sunrise = currentWeatherCityEntity.sys!.sunrise!.toDouble();
  double sunset = currentWeatherCityEntity.sys!.sunset!.toDouble();
  // double pointerValue = DateTime.now().millisecondsSinceEpoch.toDouble();
  double pointerValue = currentWeatherCityEntity.dt!.toDouble();

  return SfRadialGauge(
    animationDuration: 3000,
    enableLoadingAnimation: true,
    // title: GaugeTitle(
    //   text: 'Sunrise / Sunset',
    //   textStyle: context.textTheme.headline6!,
    // ),
    axes: <RadialAxis>[
      RadialAxis(
        minimum: sunrise,
        maximum: sunset,
        startAngle: 180,
        endAngle: 0,
        showLabels: false,
        showAxisLine: false,
        showTicks: false,
        // interval: 20,
        ranges: <GaugeRange>[
          GaugeRange(
            startValue: sunrise,
            endValue: sunrise + ((sunset - sunrise) / 3),
            gradient: const SweepGradient(
              colors: [
                Colors.white,
                Colors.white,
                Colors.orange,
              ],
            ),
            startWidth: context.width * 0.01,
            endWidth: context.width * 0.01,
          ),
          GaugeRange(
            startValue: sunrise + ((sunset - sunrise) / 3),
            endValue: sunrise + (2 * ((sunset - sunrise) / 3)),
            gradient: const SweepGradient(
              colors: [
                Colors.orange,
                Colors.orange,
                Colors.red
              ],
            ),
            startWidth: context.width * 0.01,
            endWidth: context.width * 0.01,
          ),
          GaugeRange(
            startValue: sunrise + (2 * ((sunset - sunrise) / 3)),
            endValue: sunset,
            gradient: const SweepGradient(
              colors: [
                Colors.red,
                Colors.red,
                Colors.black,
              ],
            ),
            startWidth: context.width * 0.01,
            endWidth: context.width * 0.01,
          )
        ],
        pointers: <GaugePointer>[
          WidgetPointer(
            value: pointerValue.toDouble(),
            enableAnimation: true,
            animationDuration: 2000,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: context.width * 0.08,
                  height: context.width * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.8),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                // Icon(
                //   Icons.sunny,
                //   color: Colors.yellow,
                //   size: context.width * 0.2,
                // )
              ],
            ),
          )
        ],
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
            widget: FittedBox(
              child: Container(
                margin: const EdgeInsets.only(top: 32),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    // WeatherElement(
                    //   value: '${currentWeatherCityEntity.clouds?.all}',
                    //   parameter: '%',
                    //   iconData: CupertinoIcons.cloud,
                    //   boldColor: Colors.white,
                    //   midColor: Colors.lightBlue,
                    //   paleColor: Colors.lightBlueAccent,
                    // ),
                    WeatherElement(
                      value: '${currentWeatherCityEntity.visibility}',
                      parameter: 'm',
                      iconData: CupertinoIcons.eye,
                      boldColor: Colors.white,
                      midColor: Colors.pink,
                      paleColor: Colors.purple,
                    ),
                    WeatherElement(
                      value: '${currentWeatherCityEntity.main?.feelsLike}',
                      parameter: '℃',
                      iconData: CupertinoIcons.thermometer,
                      boldColor: Colors.white,
                      midColor: Colors.redAccent,
                      paleColor: Colors.lightBlueAccent,
                    ),
                    // WeatherElement(
                    //   value: '${currentWeatherCityEntity.wind?.deg}',
                    //   parameter: '\u00B0',
                    //   iconData: CupertinoIcons.arrow_branch,
                    //   boldColor: Colors.white,
                    //   midColor: Colors.lightBlueAccent,
                    //   paleColor: Colors.grey,
                    // ),
                  ],
                ),
              ),
            ),
            angle: 90,
            positionFactor: 0.6,
          ),
          const GaugeAnnotation(
            widget: Icon(CupertinoIcons.sunrise),  // 🌅
            angle: 180,
            verticalAlignment: GaugeAlignment.near,
            positionFactor: 0.65,
          ),
          const GaugeAnnotation(
            widget: Icon(CupertinoIcons.sunset),  // 🌄
            angle: 0,
            verticalAlignment: GaugeAlignment.near,
            positionFactor: 0.65,
          ),
        ],
      ),
    ],
  );
}


class IconBookmark extends StatelessWidget {
  const IconBookmark({required this.cityName, Key? key}) : super(key: key);

  final String cityName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      buildWhen: (previous, current) {
        if (previous.getCityStatus == current.getCityStatus) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        BlocProvider.of<BookmarkBloc>(context, listen: false).add(SaveCityInitialEvent());
        if (state.getCityStatus is GetCityLoadingStatus) {
          return CupertinoActivityIndicator(
            color: context.theme.colorScheme.onBackground,
            radius: 12,
          );
        } else if (state.getCityStatus is GetCityCompletedStatus) {

          final getCityCompletedStatus = state.getCityStatus as GetCityCompletedStatus;
          CityEntity? city = getCityCompletedStatus.cityEntity;
          return BlocConsumer<BookmarkBloc, BookmarkState>(
            buildWhen: (previous, current) {
              if (previous.saveCityStatus == current.saveCityStatus) {
                return false;
              }
              return true;
            },
            listenWhen: (previous, current) {
              if (previous.saveCityStatus == current.saveCityStatus) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              if (state.saveCityStatus is SaveCityInitialStatus) {
                return IconButton(
                  onPressed: () {
                    BlocProvider.of<BookmarkBloc>(context, listen: false).add(SaveCityEvent(cityName));
                    BlocProvider.of<BookmarkBloc>(context, listen: false).add(GetAllCitiesEvent());
                  },
                  icon: Icon(
                    city != null ? CupertinoIcons.star_fill : CupertinoIcons.star,
                    color: context.theme.colorScheme.onBackground,
                    size: 24,
                  ),
                );
              } else if (state.saveCityStatus is SaveCityLoadingStatus) {
                return Center(
                  child: CupertinoActivityIndicator(
                    color: context.theme.colorScheme.onBackground,
                    radius: 12,
                  ),
                );
              } else if (state.saveCityStatus is SaveCityCompletedStatus ||
                         state.saveCityStatus is SaveCityErrorStatus) {
                return IconButton(
                  onPressed: () {
                    BlocProvider.of<BookmarkBloc>(context).add(SaveCityEvent(cityName));
                    BlocProvider.of<BookmarkBloc>(context).add(GetAllCitiesEvent());
                  },
                  icon: Icon(
                    CupertinoIcons.star_fill,
                    color: context.theme.colorScheme.onBackground,
                    size: 24,
                  ),
                );
              } else {
                return Container();
              }
            },
            listener: (context, state) {
              if (state.saveCityStatus is SaveCityCompletedStatus) {
                final saveCityCompletedStatus = state.saveCityStatus as SaveCityCompletedStatus;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${saveCityCompletedStatus.cityEntity.name} added to Bookmark',
                      style: context.textTheme.bodyText2!.copyWith(
                        color: context.theme.colorScheme.onPrimary,
                      ),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: context.theme.colorScheme.primary,
                    elevation: 8,
                  ),
                );
              }

              if (state.saveCityStatus is SaveCityErrorStatus) {
                final saveCityErrorStatus = state.saveCityStatus as SaveCityErrorStatus;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      saveCityErrorStatus.errorMessage,
                      style: context.textTheme.bodyText2!.copyWith(
                        color: context.theme.colorScheme.onPrimary,
                      ),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: context.theme.colorScheme.primary,
                    elevation: 8,
                  ),
                );
              }
            },
          );

        } else if (state.getCityStatus is GetCityErrorStatus) {
          return Icon(
            CupertinoIcons.exclamationmark_circle,
            color: context.theme.errorColor,
            size: 24,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
