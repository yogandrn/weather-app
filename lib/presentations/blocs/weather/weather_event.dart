part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

final class FetchRealtimeWeather extends WeatherEvent {
  const FetchRealtimeWeather();
}

final class FetchDetailWeather extends WeatherEvent {
  final Position position;
  const FetchDetailWeather({required this.position});
}
