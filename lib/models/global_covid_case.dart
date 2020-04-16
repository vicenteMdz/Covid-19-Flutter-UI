class GlobalCovidCase {
  final int updated;
  final int cases;
  final int todayCases;
  final int deaths;
  final int todayDeaths;
  final int recovered;
  final int active;
  final int critical;
  final int casesPerOneMillion;
  final int deathsPerOneMillion;
  final int tests;
  final double testsPerOneMillion;
  final int affectedCountries;

  GlobalCovidCase(
      {this.updated,
      this.cases,
      this.todayCases,
      this.deaths,
      this.todayDeaths,
      this.recovered,
      this.active,
      this.critical,
      this.casesPerOneMillion,
      this.deathsPerOneMillion,
      this.tests,
      this.testsPerOneMillion,
      this.affectedCountries});

  factory GlobalCovidCase.fromJson(Map<String, dynamic> json) {
    return GlobalCovidCase(
        updated: json['updated'],
        cases: json['cases'],
        todayCases: json['todayCases'],
        deaths: json['deaths'],
        todayDeaths: json['todayDeaths'],
        recovered: json['recovered'],
        active: json['active'],
        critical: json['critical'],
        casesPerOneMillion: json['casesPerOneMillion'],
        deathsPerOneMillion: json['deathsPerOneMillion'],
        tests: json['tests'],
        testsPerOneMillion: double.parse(json['testsPerOneMillion'].toString()),
        affectedCountries: json['affectedCountries']);
  }
}
