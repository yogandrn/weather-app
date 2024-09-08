import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/utilities/helper.dart';

import '../../data/models/response_forecast_weather.dart';
import '../themes/colors.dart';
import '../themes/textstyles.dart';

class ListItemForecastWeather extends StatelessWidget {
  final WeatherInterval weather;
  const ListItemForecastWeather({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final weatherAsset =
        Helper.getWeatherAssetFromCode("${weather.values.weatherCode}");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMM, d').format(weather.startTime),
            style: subtitleStyle.copyWith(
              color: white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SvgPicture.asset(
            weatherAsset,
            width: 36,
          ),
          Text(
            '${weather.values.temperature.toInt()}°C',
            style: subtitleStyle.copyWith(
              color: white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
