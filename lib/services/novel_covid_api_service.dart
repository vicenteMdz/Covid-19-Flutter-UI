import 'package:covid19/models/country.dart';
import 'package:covid19/models/global_covid_case.dart';

abstract class NovelCovidApiService {
  Future<GlobalCovidCase> getGlobalResume();

  Future<List<Country>> getCountriesResume();

  Future<Country> getResumeByCountry(
      String iso3Country, bool exactlySearch, bool yesterdayData);
}
