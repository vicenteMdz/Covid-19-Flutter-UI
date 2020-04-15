import 'package:covid19/models/country_info.dart';

class Country {
  final String country;
  final CountryInfo countryInfo;
  final int cases;
  final int todayCases;
  final int deaths;
  final int todayDeaths;
  final int recovered;
  final int active;
  final int critical;
  final int casesPerOneMillion;
  final int deathsPerOneMillion;
  final int updated;

  Country(
      {this.country,
      this.countryInfo,
      this.cases,
      this.todayCases,
      this.deaths,
      this.todayDeaths,
      this.recovered,
      this.active,
      this.critical,
      this.casesPerOneMillion,
      this.deathsPerOneMillion,
      this.updated});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      country: json['country'],
      countryInfo: CountryInfo.fromJson(json['countryInfo']),
      cases: json['cases'],
      todayCases: json['todayCases'],
      deaths: json['deaths'],
      todayDeaths: json['todayDeaths'],
      recovered: json['recovered'],
      active: json['active'],
      critical: json['critical'],
      casesPerOneMillion: json['casesPerOneMillion'],
      deathsPerOneMillion: json['deathsPerOneMillion'],
      updated: json['updated'],
    );
  }
}
