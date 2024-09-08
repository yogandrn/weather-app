import 'dart:convert';

ResponseRealtimeWeather responseRealtimeWeatherFromJson(String str) =>
    ResponseRealtimeWeather.fromJson(json.decode(str));

String responseRealtimeWeatherToJson(ResponseRealtimeWeather data) =>
    json.encode(data.toJson());

class ResponseRealtimeWeather {
  Data? data;
  Location? location;
  int code;
  String type;
  String message;

  ResponseRealtimeWeather({
    this.data,
    this.location,
    required this.code,
    required this.type,
    required this.message,
  });

  factory ResponseRealtimeWeather.fromJson(Map<String, dynamic> json) =>
      ResponseRealtimeWeather(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        code: json["code"] ??
            200, // jika sukses akan 200, jika error akan sesuai response
        type: json["type"] ?? 'Successfully fetch data',
        message: json["message"] ?? 'Successfully fetch data',
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "location": location?.toJson(),
        "code": code,
        "type": type,
        "message": message,
      };
}

class Data {
  DateTime? time;
  Values values;

  Data({
    this.time,
    required this.values,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        values: Values.fromJson(json['values']),
      );

  Map<String, dynamic> toJson() =>
      {"time": time?.toIso8601String(), "values": values.toJson()};
}

class Values {
  num cloudBase;
  num cloudCeiling;
  num cloudCover;
  num dewPoint;
  num freezingRainIntensity;
  num humidity;
  num precipitationProbability;
  num pressureSurfaceLevel;
  num rainIntensity;
  num sleetIntensity;
  num snowIntensity;
  num temperature;
  num temperatureApparent;
  num uvHealthConcern;
  num uvIndex;
  num visibility;
  num weatherCode;
  num windDirection;
  num windGust;
  num windSpeed;

  Values({
    required this.cloudBase,
    required this.cloudCeiling,
    required this.cloudCover,
    required this.dewPoint,
    required this.freezingRainIntensity,
    required this.humidity,
    required this.precipitationProbability,
    required this.pressureSurfaceLevel,
    required this.rainIntensity,
    required this.sleetIntensity,
    required this.snowIntensity,
    required this.temperature,
    required this.temperatureApparent,
    required this.uvHealthConcern,
    required this.uvIndex,
    required this.visibility,
    required this.weatherCode,
    required this.windDirection,
    required this.windGust,
    required this.windSpeed,
  });

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        cloudBase: json["cloudBase"] ?? 0,
        cloudCeiling: json["cloudCeiling"] ?? 0,
        cloudCover: json["cloudCover"] ?? 0,
        dewPoint: json["dewPoint"] ?? 0,
        freezingRainIntensity: json["freezingRainIntensity"] ?? 0,
        humidity: json["humidity"] ?? 0,
        precipitationProbability: json["precipitationProbability"] ?? 0,
        pressureSurfaceLevel: json["pressureSurfaceLevel"] ?? 0,
        rainIntensity: json["rainIntensity"] ?? 0,
        sleetIntensity: json["sleetIntensity"] ?? 0,
        snowIntensity: json["snowIntensity"] ?? 0,
        temperature: json["temperature"] ?? 0,
        temperatureApparent: json["temperatureApparent"] ?? 0,
        uvHealthConcern: json["uvHealthConcern"] ?? 0,
        uvIndex: json["uvIndex"] ?? 0,
        visibility: json["visibility"] ?? 0,
        weatherCode: json["weatherCode"] ?? 0,
        windDirection: json["windDirection"] ?? 0,
        windGust: json["windGust"] ?? 0,
        windSpeed: json["windSpeed"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "cloudBase": cloudBase,
        "cloudCeiling": cloudCeiling,
        "cloudCover": cloudCover,
        "dewPoint": dewPoint,
        "freezingRainIntensity": freezingRainIntensity,
        "humidity": humidity,
        "precipitationProbability": precipitationProbability,
        "pressureSurfaceLevel": pressureSurfaceLevel,
        "rainIntensity": rainIntensity,
        "sleetIntensity": sleetIntensity,
        "snowIntensity": snowIntensity,
        "temperature": temperature,
        "temperatureApparent": temperatureApparent,
        "uvHealthConcern": uvHealthConcern,
        "uvIndex": uvIndex,
        "visibility": visibility,
        "weatherCode": weatherCode,
        "windDirection": windDirection,
        "windGust": windGust,
        "windSpeed": windSpeed,
      };
}

class Location {
  num? lat;
  num? lon;

  Location({
    this.lat,
    this.lon,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"],
        lon: json["lon"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
      };
}
