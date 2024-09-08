import 'dart:convert';

ResponseForecastWeather responseForecastWeatherFromJson(String str) =>
    ResponseForecastWeather.fromJson(json.decode(str));

String responseForecastWeatherToJson(ResponseForecastWeather data) =>
    json.encode(data.toJson());

class ResponseForecastWeather {
  Data? data;
  int code;
  String type;
  String message;

  ResponseForecastWeather({
    this.data,
    required this.code,
    required this.type,
    required this.message,
  });

  factory ResponseForecastWeather.fromJson(Map<String, dynamic> json) =>
      ResponseForecastWeather(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        code: json["code"] ?? 200,
        type: json["type"] ?? "Successfully fetch data",
        message: json["message"] ?? "Successfully fetch data",
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "code": code,
        "type": type,
        "message": message,
      };
}

class Data {
  Timeline timelines;

  Data({
    required this.timelines,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        timelines: Timeline.fromJson(json["timelines"][0]),
      );

  Map<String, dynamic> toJson() => {
        "timelines": timelines.toJson(),
      };
}

class Timeline {
  String timestep;
  DateTime endTime;
  DateTime startTime;
  List<WeatherInterval> intervals;

  Timeline({
    required this.timestep,
    required this.endTime,
    required this.startTime,
    required this.intervals,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
        timestep: json["timestep"],
        endTime: DateTime.parse(json["endTime"]),
        startTime: DateTime.parse(json["startTime"]),
        intervals: List<WeatherInterval>.from(
            json["intervals"]!.map((x) => WeatherInterval.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "timestep": timestep,
        "endTime": endTime.toIso8601String(),
        "startTime": startTime.toIso8601String(),
        "intervals": List<dynamic>.from(intervals.map((x) => x.toJson())),
      };
}

class WeatherInterval {
  DateTime startTime;
  Values values;

  WeatherInterval({
    required this.startTime,
    required this.values,
  });

  factory WeatherInterval.fromJson(Map<String, dynamic> json) =>
      WeatherInterval(
        startTime: DateTime.parse(json["startTime"]),
        values: Values.fromJson(json["values"]),
      );

  Map<String, dynamic> toJson() => {
        "startTime": startTime.toIso8601String(),
        "values": values.toJson(),
      };
}

class Values {
  double humidity;
  double temperature;
  int weatherCode;
  double windSpeed;

  Values({
    required this.humidity,
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        humidity: json["humidity"],
        temperature: json["temperature"],
        weatherCode: json["weatherCode"],
        windSpeed: json["windSpeed"],
      );

  Map<String, dynamic> toJson() => {
        "humidity": humidity,
        "temperature": temperature,
        "weatherCode": weatherCode,
        "windSpeed": windSpeed,
      };
}
