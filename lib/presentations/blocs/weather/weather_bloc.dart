import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/utilities/validator.dart';
import '../../../data/models/response_forecast_weather.dart';
import '../../../data/models/response_geocoding.dart';
import '../../../data/models/response_realtime_weather.dart';
import '../../../data/repositories/weather_repository.dart';

import '../../../core/configs/asset_const.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final weatherRepository = const WeatherRepository();
  final _newNotifications = [
    {
      'message':
          "A sunny day in your location. Consider using the UV protection.",
      "icon_asset": AssetConst.iconSun,
      "date": "10 minutes ago",
      "is_read": false
    },
  ];

  final _earlyNotifications = [
    {
      'message':
          "A cloudy day will occure all day long, don't worry about the heat of the sun.",
      "icon_asset": AssetConst.iconCloud,
      "date": "08 Sep 2024",
      "is_read": true
    },
    {
      'message':
          "Potential for rain today is 84%, don't forget to bring your umbrella or rain coat",
      "icon_asset": AssetConst.iconWind,
      "date": "06 Sep 2024",
      "is_read": true
    },
  ];

  WeatherBloc() : super(const WeatherOnLoading()) {
    // event fetch forcast weather
    on<FetchRealtimeWeather>((event, emit) async {
      try {
        emit(const WeatherOnLoading());

        final permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          // jika ditolak, minta akses lagi
          await Geolocator.requestPermission();
        }

        // jika tidak diizinkan sama sekali, beri pesan error
        if (permission == LocationPermission.deniedForever) {
          emit(
            const WeatherFetchError(
                message:
                    'Izin akses lokasi ditolak selamanya\nSistem tidak bisa melakukan permohonan izin lokasi.'),
          );
          return;
        }

        final position = await Geolocator.getCurrentPosition();

        // cek koneksi internet
        final isOnline = await Validator.isConnectedToInternet();

        if (!isOnline) {
          emit(const WeatherNoInternet());
          return;
        }

        // initaial variable
        ResponseRealtimeWeather? responseRealtimeWeather;
        ResponseGeocoding? responseGeocoding;

        // send api asynchronous, lalu assign ke variable
        await Future.wait([
          weatherRepository
              .fetchRealtimeWeather(position)
              .then((value) => responseRealtimeWeather = value),
          weatherRepository
              .reverseGeocoding(position)
              .then((value) => responseGeocoding = value),
        ]);

        if (responseRealtimeWeather != null && responseGeocoding != null) {
          emit(
            responseRealtimeWeather!.code == 200
                ? WeatherFetchSuccess(
                    realtimeWeather: responseRealtimeWeather!,
                    geocoding: responseGeocoding!,
                    position: position,
                    earlyNotifications: _earlyNotifications,
                    newNotifications: _newNotifications,
                  )
                : WeatherFetchError(
                    message: "${responseRealtimeWeather?.type}"),
          );
        } else {
          // set error state
          emit(const WeatherFetchError(
              message: "Terjadi kesalahan saat memuat data cuaca!"));
        }
      } catch (e) {
        log("Error on FetchForecastEvent on WeatherBloc : $e");
        // set error state
        emit(
          const WeatherFetchError(
              message: "Terjadi kesalahan saat memuat data cuaca!"),
        );
      }
    });

    on<FetchDetailWeather>((event, emit) async {
      try {
        emit(const WeatherOnLoading());
        final isOnline = await Validator.isConnectedToInternet();

        if (!isOnline) {
          emit(const WeatherNoInternet());
          return;
        }

        ResponseForecastWeather? todayWeather, forecastWeather;

        await Future.wait([
          weatherRepository
              .fecthDailyWeather(event.position)
              .then((value) => todayWeather = value),
          weatherRepository
              .fetchForecastWeater(event.position)
              .then((value) => forecastWeather = value),
        ]);

        if (todayWeather != null && forecastWeather != null) {
          emit(
            todayWeather!.code == 200
                ? WeatherForecastSuccess(
                    todayForecast: todayWeather!,
                    dailyForecast: forecastWeather!)
                : WeatherFetchError(message: "${todayWeather?.type}"),
          );
        } else {
          emit(
            const WeatherFetchError(
                message: 'Terjadi kesalahan saat memuat data cuaca'),
          );
        }
      } catch (e) {
        log("Error on FetchDetailWeather : $e");
        emit(
          const WeatherFetchError(
              message: 'Terjadi kesalahan saat memuat data cuaca'),
        );
      }
    });
  }
}
