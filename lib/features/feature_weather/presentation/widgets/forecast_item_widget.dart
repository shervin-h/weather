import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/date_time_helper.dart';
import '../../data/models/forecast_weather_model.dart';

class ForecastItemWidget extends StatefulWidget {
  const ForecastItemWidget({required this.forecastData, this.nextForecastData, required this.isSelected, Key? key}) : super(key: key);

  final ForecastData forecastData;
  final ForecastData? nextForecastData;
  final bool isSelected;

  @override
  State<ForecastItemWidget> createState() => _ForecastItemWidgetState();
}

class _ForecastItemWidgetState extends State<ForecastItemWidget> {
  String _hour() {
    // int thisHour = parseStringToDateTime(widget.forecastData.dtTxt!).hour;
    String format1 = DateFormat('H a').format(DateTime.parse(widget.forecastData.dtTxt!));
    if (widget.nextForecastData == null) {
      return format1;
    } else {
      // int nextHour = parseStringToDateTime(widget.nextForecastData!.dtTxt!).hour;
      String format2 = DateFormat('H a').format(DateTime.parse(widget.nextForecastData!.dtTxt!));
      return '$format1 - $format2';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(4),
      width: context.width * 0.24,
      height: context.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.background,
        borderRadius: BorderRadius.circular(16),
        border: widget.isSelected
            ? Border.all(color: context.theme.colorScheme.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: context.theme.colorScheme.shadow,
            blurRadius: widget.isSelected ? 8 : 4,
          ),
        ],
      ),
      child: FittedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text('${DateTime.parse(widget.forecastData.dtTxt!).day}'),
            Text(
              parseFormattedStringToJalali(widget.forecastData.dtTxt!, mode: 'md'),
              style: context.textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _hour(),
              style: context.textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.bold,
              )
            ),
            Image.network(
              'http://openweathermap.org/img/wn/${widget.forecastData.weather![0].icon}@2x.png',
              errorBuilder: (context, obj, error) {
                return Icon(
                  CupertinoIcons.exclamationmark_circle,
                  color: context.theme.errorColor,
                  size: 24,
                );
              },
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      'min',
                      style: context.textTheme.caption!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.forecastData.main!.tempMin!} \u00B0',
                      style: context.textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Text(
                      'max',
                      style: context.textTheme.caption!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.forecastData.main!.tempMax!} \u00B0',
                      style: context.textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Shimmer.fromColors(
              baseColor: context.theme.colorScheme.primary.withOpacity(0.2),
              highlightColor: context.theme.colorScheme.primary,
              period: const Duration(seconds: 3),
              child: const Text(
                'tap for details',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            )
          ],
        ),
      ),
    );
  }
}