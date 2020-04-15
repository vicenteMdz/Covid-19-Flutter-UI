class CountryInfo {
  final int id;
  final String iso2;
  final String iso3;
  final String country;
  final int lat;
  final int long;
  final String flag;

  CountryInfo(
      {this.id,
      this.iso2,
      this.iso3,
      this.country,
      this.lat,
      this.long,
      this.flag});

  factory CountryInfo.fromJson(Map<String, dynamic> json) {
    return CountryInfo(
        id: json['id'],
        iso2: json['iso2'],
        iso3: json['iso3'],
        country: json['country'],
        lat: json['lat'],
        long: json['long'],
        flag: json['flag']);
  }
}
