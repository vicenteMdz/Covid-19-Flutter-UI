import 'package:covid19/models/country.dart';
import 'package:covid19/models/global_covid_case.dart';
import 'package:covid19/services/novel_covid_api_service.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NovelCovidApiServiceImpl extends NovelCovidApiService {
  final String apiEndpoint = 'https://corona.lmao.ninja/v2';

  @override
  Future<GlobalCovidCase> getGlobalResume() async {
    final response = await http.get('$apiEndpoint/all');
    if (response.statusCode == 200) {
      // Si el servidor devuelve una repuesta OK, parseamos el JSON
      return GlobalCovidCase.fromJson(json.decode(response.body));
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Future<List<Country>> getCountriesResume() async {
    final response = await http.get('$apiEndpoint/countries?yesterday=false');
    if (response.statusCode == 200) {
      List data = List();
      data = json.decode(response.body) as List;
      List<Country> countries = List<Country>();
      for (var item in data) {
        countries.add(Country.fromJson(json.decode(item)));
      }
      return countries;
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Future<List<Country>> getResumeByCountry(
      String iso3Country, bool exactlySearch, bool yesterdayData) async {
    final response = await http.get(
        '$apiEndpoint/countries/$iso3Country?yesterday=$yesterdayData&strict=$exactlySearch');
    if (response.statusCode == 200) {
      List data = List();
      data = json.decode(response.body) as List;
      List<Country> countries = List<Country>();
      for (var item in data) {
        countries.add(Country.fromJson(json.decode(item)));
      }
      return countries;
    } else {
      // Si esta respuesta no fue OK, lanza un error.
      throw Exception('Failed to load post');
    }
  }

}
