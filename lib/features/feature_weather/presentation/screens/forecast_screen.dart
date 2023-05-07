import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather/core/utils/custom_clipper.dart';
import 'package:weather/core/utils/helper.dart';
import 'package:weather/features/feature_weather/data/models/forecast_weather_model.dart';

import '../../../../core/utils/date_time_helper.dart';
import '../../../../core/widgets/inner_shadow_widget.dart';
import '../widgets/weather_element.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({Key? key}) : super(key: key);

  static const String routeName = '/forecast-screen';

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    //////// Transparent StatusBar ///////
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //   ),
    // );

    ////////// Hide StatusBar /////////////
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

  }

  @override
  void dispose() {

    //////// Show StatusBar /////////
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
    );

    super.dispose();
  }


  String _hour(ForecastData forecastData, ForecastData? nextForecastData) {
    int thisHour = parseStringToDateTime(forecastData.dtTxt!).hour;
    if (nextForecastData == null) {
      return thisHour.toString();
    } else {
      int nextHour = parseStringToDateTime(nextForecastData.dtTxt!).hour;
      return '$thisHour - $nextHour';
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    List<ForecastData> forecasts = routeData['forecasts'];
    City? city = routeData['city'];
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: context.width,
              height: context.height * 0.6,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(getRelatedWallpaperPath()),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaY: 2,
                    sigmaX: 2,
                  ),
                  child: Container(
                    height: context.height * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    city!.country!,
                                    style: context.textTheme.headline5,
                                  ),
                                  Text(
                                    city.name!,
                                    style: context.textTheme.headline6,
                                  ),
                                  const Divider(thickness: 2,),
                                  Text(
                                    DateFormat('E, d MMM').format(DateTime.parse(forecasts[0].dtTxt!)),
                                    style: context.textTheme.bodyText2!.copyWith(
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              const Expanded(flex: 2, child: SizedBox()),
                              FittedBox(
                                child: Text(
                                  _hour(forecasts.first, (forecasts.length == 1) ? null : forecasts[1]),
                                  style: context.theme.textTheme.headline1,
                                ),
                              ),
                              const Expanded(flex: 1, child: SizedBox()),
                            ],
                          ),
                        ),
                        Expanded(
                          child: FittedBox(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      'http://openweathermap.org/img/wn/${forecasts.first.weather![0].icon}@4x.png',
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          CupertinoIcons.cloud_download,
                                          color: context.theme.errorColor,
                                          size: 40,
                                        );
                                      },
                                      fit: BoxFit.cover,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${forecasts.first.main!.temp.toString()} ℃',
                                          style: context.textTheme.headline2,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '🔻 ${forecasts.first.main!.tempMin.toString()} \u00B0',
                                              style: context.textTheme.headline6,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '🔺 ${forecasts.first.main!.tempMax.toString()} \u00B0',
                                              style: context.textTheme.headline6,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${forecasts.first.weather![0].main}',
                                      style: context.textTheme.headline4,
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      '${forecasts.first.weather![0].description}',
                                      style: context.textTheme.headline6!.copyWith(color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        context.theme.colorScheme.primary.withOpacity(0.4),
                                        context.theme.colorScheme.primary.withOpacity(0.3),
                                        context.theme.colorScheme.primary.withOpacity(0.2),
                                        Colors.transparent,
                                      ]
                                    )
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        DateFormat('yyyy-MMM-dd').format(DateTime.now()),
                                        style: context.textTheme.bodyText1!.copyWith(
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        children: [
                                          Text(
                                            DateFormat('H:m a').format(DateTime.now()),
                                            style: context.textTheme.headline4!.copyWith(
                                              color: Colors.grey.shade200,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            'current time',
                                            style: context.textTheme.bodyText2!.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        // parseFormattedStringToJalali(forecasts.first.dtTxt!, mode: 'a'),
                                        currentDateAsJalali(),
                                        style: context.textTheme.bodyText1!.copyWith(
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: context.height * 0.6 * 0.22,)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: context.width,
              height: context.height * 0.6,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Transform.rotate(
                    angle: pi,
                    child: ClipPath(
                      clipper: CurveClipper4(),
                      child: Container(
                        width: context.width,
                        height: context.height * 0.6,
                        decoration: BoxDecoration(
                          // color: Colors.white.withOpacity(0.1),
                          // color: context.theme.colorScheme.background.withOpacity(0.1),
                          color: context.isDarkMode
                              ? context.theme.colorScheme.secondary.withOpacity(0.10)
                              : context.theme.colorScheme.background.withOpacity(0.10)
                        ),
                      ),
                    ),
                  ),

                  Transform.rotate(
                    angle: pi,
                    child: ClipPath(
                      clipper: CurveClipper(),
                      child: Container(
                        width: context.width,
                        height: context.height * 0.57,
                        decoration: BoxDecoration(
                          // color: Colors.white.withOpacity(0.2),
                          // color: context.theme.colorScheme.background.withOpacity(0.2),
                          color: context.isDarkMode
                              ? context.theme.colorScheme.secondary.withOpacity(0.14)
                              : context.theme.colorScheme.background.withOpacity(0.14)
                        ),
                      ),
                    ),
                  ),

                  Transform.rotate(
                    angle: pi,
                    child: ClipPath(
                      clipper: CurveClipper2(),
                      child: Container(
                        width: context.width,
                        height: context.height * 0.54,
                        decoration: BoxDecoration(
                          // color: Colors.white.withOpacity(0.3),
                          // color: context.theme.colorScheme.background.withOpacity(0.3),
                          color: context.isDarkMode
                              ? context.theme.colorScheme.secondary.withOpacity(0.18)
                              : context.theme.colorScheme.background.withOpacity(0.18),
                        ),
                      ),
                    ),
                  ),

                  // Shimmer effect on latest layer only in dark mode
                  Shimmer.fromColors(
                    baseColor: context.theme.colorScheme.primary.withOpacity(0.2),
                    highlightColor: context.theme.colorScheme.primary,
                    // baseColor: Colors.pinkAccent.withOpacity(0.2),
                    // highlightColor: Colors.pinkAccent,
                    child: Transform.rotate(
                      angle: pi,
                      child: ClipPath(
                        clipper: CurveClipper3(),
                        child: Container(
                          width: context.width,
                          height: context.height * 0.553,
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            color: context.theme.colorScheme.background,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: pi,
                    child: ClipPath(
                      clipper: CurveClipper3(),
                      child: Container(
                        width: context.width,
                        height: context.height * 0.55,
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          color: context.theme.colorScheme.background,
                        ),
                        child: Transform.rotate(
                          angle: pi,
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              SizedBox(height: context.height * 0.08),
                              ForecastWeatherElementItemWidget(
                                iconData: CupertinoIcons.cloud,
                                colors: const [
                                  Colors.blueAccent,
                                  Colors.blue,
                                  Colors.lightBlueAccent,
                                ],
                                title: 'Cloud',
                                subTitle: forecasts[0].clouds!.all!.toString(),
                                unit: '%',
                                trailing: 'Cloudiness, %',
                              ),
                              ForecastWeatherElementItemWidget(
                                iconData: CupertinoIcons.wind,
                                colors: const [
                                  Colors.green,
                                  Colors.greenAccent,
                                ],
                                title: 'Wind',
                                subTitle: forecasts[0].wind!.speed!.toString(),
                                unit: '㎧',
                                trailing: 'Wind speed. Unit meter/sec',
                              ),
                              ForecastWeatherElementItemWidget(
                                iconData: CupertinoIcons.arrow_branch,
                                colors: const [
                                  Colors.redAccent,
                                  Colors.deepOrange,
                                  Colors.orange,
                                ],
                                title: 'Wind Deg',
                                subTitle: forecasts[0].wind!.deg!.toString(),
                                unit: '°',
                                trailing: 'Wind direction, degrees',
                              ),
                              ForecastWeatherElementItemWidget(
                                iconData: Icons.water_drop_outlined,
                                colors: const [
                                  Colors.lightBlueAccent,
                                  Colors.blue,
                                  Colors.pink,
                                ],
                                title: 'Humidity',
                                subTitle: forecasts[0].main!.humidity!.toString(),
                                unit: '%',
                                trailing: 'Humidity, %',
                              ),
                              ForecastWeatherElementItemWidget(
                                iconData: CupertinoIcons.eye,
                                colors: const [
                                  Colors.purple,
                                  Colors.purpleAccent,
                                ],
                                title: 'Visibility',
                                subTitle: forecasts[0].visibility!.toString(),
                                unit: '',
                                trailing: 'The maximum value is 10km',
                              ),
                              ForecastWeatherElementItemWidget(
                                iconData: CupertinoIcons.rectangle_compress_vertical,
                                colors: const [
                                  Colors.orange,
                                  Colors.redAccent,
                                  Colors.red,
                                  Colors.pink,
                                  Colors.purpleAccent,
                                ],
                                title: 'Pressure',
                                subTitle: (forecasts[0].main!.pressure! * 100).toStringAsFixed(0) , // convert to pascal => (1 hPa = 100 Pa)
                                unit: 'Pa',
                                trailing: ' Atmospheric pressure, Pa',
                              ),
                              ForecastWeatherElementItemWidget(
                                iconData: Icons.water_outlined,
                                colors: const [
                                  Colors.lightBlueAccent,
                                  Colors.purple,
                                ],
                                title: 'Sea Level',
                                subTitle: (forecasts[0].main!.seaLevel! * 100).toStringAsFixed(0) , // convert to pascal => (1 hPa = 100 Pa)
                                unit: 'Pa',
                                trailing: ' Atmospheric pressure, Pa',
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


class ForecastWeatherElementItemWidget extends StatelessWidget {
  const ForecastWeatherElementItemWidget({
    required this.iconData,
    required this.colors,
    required this.title,
    required this.subTitle,
    required this.trailing,
    this.unit,
    Key? key,
  }) : super(key: key);

  final IconData iconData;
  final List<Color> colors;
  final String title;
  final String subTitle;
  final String? unit;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InnerShadow(
              shadows: [
                Shadow(
                  color: context.theme.colorScheme.background.withOpacity(0.7),
                  blurRadius: 5,
                ),
              ],
              child: Container(
                width: context.width * 0.1,
                height: context.width * 0.1,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                ),
              ),
            ),
            Icon(
              iconData,
              color: Colors.white,
              size: context.width * 0.06,
            ),
          ],
        ),
      ),
      title: Text(title),
      subtitle: Text('$subTitle ${unit ?? ''}'),
      trailing: Text(
        trailing,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
