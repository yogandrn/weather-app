part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

final class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

final class WeatherOnLoading extends WeatherState {
  const WeatherOnLoading();
}

final class WeatherFetchSuccess extends WeatherState {
  final ResponseRealtimeWeather realtimeWeather;
  final ResponseGeocoding geocoding;
  final Position position;
  final List<Map<String, dynamic>> newNotifications, earlyNotifications;
  const WeatherFetchSuccess({
    required this.realtimeWeather,
    required this.geocoding,
    required this.position,
    required this.newNotifications,
    required this.earlyNotifications,
  });
}

final class WeatherForecastSuccess extends WeatherState {
  final ResponseForecastWeather todayForecast, dailyForecast;
  final int initialIndex;

  const WeatherForecastSuccess({
    required this.todayForecast,
    required this.dailyForecast,
    this.initialIndex = 0,
  });
}

final class WeatherNoInternet extends WeatherState {
  const WeatherNoInternet();
}

final class WeatherFetchError extends WeatherState {
  final String message;
  const WeatherFetchError({required this.message});
}
