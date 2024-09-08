import 'dart:developer';

import 'package:weather_app/data/weather_codes.dart';

abstract class Helper {
  static String getWeatherAssetFromCode(String code) {
    var weatherName = weatherCodes[code]!.toLowerCase().replaceAll(' ', '_');
    log("Result : $weatherName");

    // Cari asset yang paling mirip atau sama
    String matchedAsset = weatherAssets.firstWhere(
      (asset) => asset.contains(weatherName), // Pencarian berdasarkan kemiripan
      orElse: () => 'cloudy.svg', // Jika tidak ditemukan, pakai default
    );
    log('Result : $matchedAsset');

    return "assets/images/$matchedAsset";
  }
}
