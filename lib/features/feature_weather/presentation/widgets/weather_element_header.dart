import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/features/feature_weather/data/models/current_weather_city_model.dart';

import '../../../../core/widgets/inner_shadow_widget.dart';

class WeatherElementHeader extends StatelessWidget {
  const WeatherElementHeader({
    required this.value,
    required this.parameter,
    required this.iconData,
    required this.boldColor,
    required this.midColor,
    required this.paleColor,
    this.label,
    this.sameSide = false,
    Key? key,
  }) : super(key: key);

  final String value;
  final String parameter;
  final IconData iconData;
  final Color boldColor;
  final Color midColor;
  final Color paleColor;
  final String? label;
  final bool sameSide;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InnerShadow(
              shadows: [
                Shadow(
                  color: context.theme.colorScheme.background.withOpacity(0.8),
                  blurRadius: 8,
                ),
              ],
              child: Container(
                width: sameSide ? context.width * 0.4 : context.width * 0.2,
                height: context.width * 0.4,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      midColor,
                      paleColor,
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: sameSide ? context.width * 0.4 : context.width * 0.2,
              height: context.width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(iconData, color: boldColor, size: context.width * 0.1,),
                  Text(
                    label == null ? value : '$value $parameter',
                    style: context.textTheme.bodyText1!.copyWith(
                      // color: context.theme.colorScheme.onBackground,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label ?? parameter,
                    style: context.textTheme.bodyText1!.copyWith(
                      // color: context.theme.colorScheme.onBackground,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}