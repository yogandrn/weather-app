import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/configs/api_const.dart';
import 'package:weather_app/core/services/api_service.dart';
import 'package:weather_app/data/models/response_forecast_weather.dart';
import 'package:weather_app/data/models/response_geocoding.dart';
import 'package:weather_app/data/models/response_realtime_weather.dart';

class WeatherRepository {
  const WeatherRepository();
  final apiService = const ApiService();

  Future<ResponseRealtimeWeather?> fetchRealtimeWeather(
      Position position) async {
    try {
      final response = await apiService.request(
        APIConst.realtimeWeather,
        method: DioMethod.get,
        contentType: ContentType.json,
        params: {
          'apikey': APIConst.apiKey,
          'location': '${position.latitude}, ${position.longitude}',
        },
      );
      log('Response fetchRealtimeWeather : ${response.data}');

      return ResponseRealtimeWeather.fromJson(response.data);
    } catch (e) {
      log("Error on fetchRealtimeWeather() : $e");
      return null;
    }
  }

  Future<ResponseForecastWeather?> fecthDailyWeather(Position position) async {
    final now = DateTime.now();
    final dateformat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    DateTime startTime = now.subtract(const Duration(hours: 2));
    DateTime endTime = now.add(const Duration(hours: 2));
    try {
      final response = await apiService.request(
        APIConst.forecastWeather,
        method: DioMethod.get,
        contentType: ContentType.json,
        params: {
          'apikey': APIConst.apiKey,
          'location': '${position.latitude}, ${position.longitude}',
          'fields': 'temperature,humidity,windSpeed,weatherCode',
          'startTime': dateformat.format(startTime),
          'endTime': dateformat.format(endTime),
          'timesteps': '1h',
        },
      );
      log('Response fecthDailyWeather : ${response.data}');

      return ResponseForecastWeather.fromJson(response.data);
    } catch (e) {
      log("Error on fecthDailyWeather() : $e");
      return null;
    }
  }

  Future<ResponseForecastWeather?> fetchForecastWeater(
      Position position) async {
    try {
      final response = await apiService.request(
        APIConst.forecastWeather,
        method: DioMethod.get,
        contentType: ContentType.json,
        params: {
          'apikey': APIConst.apiKey,
          'location': '${position.latitude}, ${position.longitude}',
          'fields': 'temperature,humidity,windSpeed,weatherCode',
          'startTime': 'now',
          'endTime': 'nowPlus5d',
          'timesteps': '1d',
        },
      );
      log('Response fetchForecastWeater : ${response.data}');

      return ResponseForecastWeather.fromJson(response.data);
    } catch (e) {
      log("Error on fetchForecastWeater() : $e");
      return null;
    }
  }

  Future<ResponseGeocoding?> reverseGeocoding(Position position) async {
    try {
      final response = await apiService.request(
        'https://nominatim.openstreetmap.org/reverse',
        method: DioMethod.get,
        params: {
          'lat': '${position.latitude}',
          'lon': '${position.longitude}',
          'format': 'json',
        },
        contentType: ContentType.json,
      );

      log("Response reverseGeocoding : ${response.data}");

      return (response.statusCode == 200)
          ? ResponseGeocoding.fromJson(response.data)
          : null;
    } catch (e) {
      log('Error on reverseGeocoding() : $e');
      return null;
    }
  }
}
