import 'dart:convert';

ResponseGeocoding responseGeocodingFromJson(String str) =>
    ResponseGeocoding.fromJson(json.decode(str));

String responseGeocodingToJson(ResponseGeocoding data) =>
    json.encode(data.toJson());

class ResponseGeocoding {
  int? placeId;
  String? licence;
  String? osmType;
  int? osmId;
  String? lat;
  String? lon;
  String? responseGeocodingClass;
  String? type;
  int? placeRank;
  double? importance;
  String? addresstype;
  String? name;
  String? displayName;
  Address? address;
  List<String>? boundingbox;

  ResponseGeocoding({
    this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    this.lat,
    this.lon,
    this.responseGeocodingClass,
    this.type,
    this.placeRank,
    this.importance,
    this.addresstype,
    this.name,
    this.displayName,
    this.address,
    this.boundingbox,
  });

  factory ResponseGeocoding.fromJson(Map<String, dynamic> json) =>
      ResponseGeocoding(
        placeId: json["place_id"],
        licence: json["licence"],
        osmType: json["osm_type"],
        osmId: json["osm_id"],
        lat: json["lat"],
        lon: json["lon"],
        responseGeocodingClass: json["class"],
        type: json["type"],
        placeRank: json["place_rank"],
        importance: json["importance"]?.toDouble(),
        addresstype: json["addresstype"],
        name: json["name"],
        displayName: json["display_name"],
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        boundingbox: json["boundingbox"] == null
            ? []
            : List<String>.from(json["boundingbox"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "licence": licence,
        "osm_type": osmType,
        "osm_id": osmId,
        "lat": lat,
        "lon": lon,
        "class": responseGeocodingClass,
        "type": type,
        "place_rank": placeRank,
        "importance": importance,
        "addresstype": addresstype,
        "name": name,
        "display_name": displayName,
        "address": address?.toJson(),
        "boundingbox": boundingbox == null
            ? []
            : List<dynamic>.from(boundingbox!.map((x) => x)),
      };
}

class Address {
  String? road;
  String? village;
  String? county;
  String? state;
  String? iso31662Lvl4;
  String? region;
  String? iso31662Lvl3;
  String? postcode;
  String? country;
  String? countryCode;

  Address({
    this.road,
    this.village,
    this.county,
    this.state,
    this.iso31662Lvl4,
    this.region,
    this.iso31662Lvl3,
    this.postcode,
    this.country,
    this.countryCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        road: json["road"],
        village: json["village"],
        county: json["county"],
        state: json["state"],
        iso31662Lvl4: json["ISO3166-2-lvl4"],
        region: json["region"],
        iso31662Lvl3: json["ISO3166-2-lvl3"],
        postcode: json["postcode"],
        country: json["country"],
        countryCode: json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "road": road,
        "village": village,
        "county": county,
        "state": state,
        "ISO3166-2-lvl4": iso31662Lvl4,
        "region": region,
        "ISO3166-2-lvl3": iso31662Lvl3,
        "postcode": postcode,
        "country": country,
        "country_code": countryCode,
      };
}
