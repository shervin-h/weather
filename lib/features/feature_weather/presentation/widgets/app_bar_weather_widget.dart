import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/date_time_helper.dart';
import '../../domain/entities/current_weather_city_entity.dart';

class AppBarFlexibleWidget extends StatelessWidget {
  const AppBarFlexibleWidget({required this.currentWeatherCityEntity, required this.height, Key? key})
      : super(key: key);

  final CurrentWeatherCityEntity currentWeatherCityEntity;
  final double height;

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
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Text(
              '${currentWeatherCityEntity.sys!.country}, ${currentWeatherCityEntity.name}',
              style: context.textTheme.headline6,
            ),
            Text(DateFormat.yMMMEd().format(convertSecondsToDateTime(int.parse(currentWeatherCityEntity.dt!.toString())))),
            Text(currentDateAsJalali()),
            const SizedBox(height: 8),
            Text(
              '${currentWeatherCityEntity.main!.temp} \u00B0c',
              style: context.textTheme.headline5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    width: context.width * 0.2,
                    height: context.width * 0.2,
                    // color: Colors.blue,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${currentWeatherCityEntity.weather![0].main}',
                      style: context.textTheme.bodyText1,
                    ),
                    Text(
                      '${currentWeatherCityEntity.weather![0].description}',
                      style: context.textTheme.bodyText1,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}