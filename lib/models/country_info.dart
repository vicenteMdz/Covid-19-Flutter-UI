class CountryInfo {
  final int id;
  final String iso2;
  final String iso3;
  final double lat;
  final double long;
  final String flag;

  CountryInfo(
      {this.id,
      this.iso2,
      this.iso3,
      this.lat,
      this.long,
      this.flag});

  factory CountryInfo.fromJson(Map<String, dynamic> json) {
    return CountryInfo(
        id: json['_id'],
        iso2: json['iso2'],
        iso3: json['iso3'],
        lat: double.parse(json['lat'].toString()),
        long: double.parse(json['long'].toString()),
        flag: json['flag']);
  }
}
