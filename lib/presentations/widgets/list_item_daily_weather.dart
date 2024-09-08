import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_app/presentations/themes/textstyles.dart';
import '../../core/utilities/extensions.dart';
import '../../core/utilities/helper.dart';
import '../../data/models/response_forecast_weather.dart';
import '../themes/colors.dart';

class ListItemDailyWeather extends StatelessWidget {
  final WeatherInterval weather;
  final bool isCurrent;
  const ListItemDailyWeather({
    super.key,
    required this.weather,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final weatherAsset =
        Helper.getWeatherAssetFromCode("${weather.values.weatherCode}");
    return Container(
      width: 65,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: isCurrent
          ? BoxDecoration(
              color: white.withOpacity(0.36),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1,
                color: white,
              ),
              boxShadow: [
                BoxShadow(
                  color: black.withOpacity(0.16),
                  offset: const Offset(1, 6),
                  blurRadius: 12,
                ),
              ],
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${weather.values.temperature.toInt()}°C',
            style: textbodyStyle.copyWith(
                color: white, fontWeight: FontWeight.w600, height: 1.8),
          ),
          SvgPicture.asset(
            weatherAsset,
            width: 28,
          ),
          Text(
            '${weather.startTime.toTimeFormat()}',
            style: textbodyStyle.copyWith(color: white, height: 1.8),
          ),
        ],
      ),
    );
  }
}
