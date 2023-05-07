import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/inner_shadow_widget.dart';

class WeatherElement extends StatelessWidget {
  const WeatherElement({
    required this.value,
    required this.parameter,
    required this.iconData,
    required this.boldColor,
    required this.midColor,
    required this.paleColor,
    Key? key,
  }) : super(key: key);

  final String value;
  final String parameter;
  final IconData iconData;
  final Color boldColor;
  final Color midColor;
  final Color paleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          ClipRRect(
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
                        colors: [
                          midColor,
                          paleColor,
                        ],
                      ),
                    ),
                  ),
                ),
                Icon(iconData, color: boldColor, size: context.width * 0.06,)
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$value $parameter',
            style: context.textTheme.caption!.copyWith(
              color: context.theme.colorScheme.onBackground,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}