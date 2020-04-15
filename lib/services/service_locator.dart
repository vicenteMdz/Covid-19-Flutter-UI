import 'package:covid19/services/novel_covid_api_service_impl.dart';
import 'novel_covid_api_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton<NovelCovidApiService>(
      () => NovelCovidApiServiceImpl());
}
