import 'dart:async';

import 'package:covid19/about_app.dart';
import 'package:covid19/constant.dart';
import 'package:covid19/models/country.dart';
import 'package:covid19/services/novel_covid_api_service.dart';
import 'package:covid19/services/service_locator.dart';
import 'package:covid19/widgets/counter.dart';
import 'package:covid19/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'info_screen.dart';
import 'models/global_covid_case.dart';

void main() {
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: kBodyTextColor),
          )),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  Timer timer;
  double _offset = 0;
  String _selectedCountry = "MEX";

  GlobalCovidCase _globalCovidCase = new GlobalCovidCase();
  Country _countryResumeCases = new Country();
  List<Country> _countries = [];

  NovelCovidApiService _apiService = locator<NovelCovidApiService>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  DateTime _lastUpdate = DateTime.now();
  DateFormat _dateFormat = DateFormat('yyyy-MM-dd kk:mm:ss');

  Choice _selectedChoice = choices[0]; // The app's "state".

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
    this.updateDataFromApi();
    timer =
        Timer.periodic(Duration(minutes: 10), (Timer t) => updateDataFromApi());
  }

  Future<Null> updateDataFromApi() {
    print('Quering data... ' + new DateTime.now().toString());
    this._apiService.getGlobalResume().then((data) {
      if (_globalCovidCase.updated == data.updated) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Data updated successfully"),
              content: new Text(
                  'Last updated at ${_dateFormat.format(_lastUpdate)} ${_lastUpdate.timeZoneName}'),
            );
          },
        );
      } else {
        _globalCovidCase = data;
        _lastUpdate =
            new DateTime.fromMillisecondsSinceEpoch(_globalCovidCase.updated);
        this._apiService.getCountriesResume().then((data) {
          _countries = data;
          getDataByCurrentCountrySelected();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop(true);
              });
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Data updated successfully"),
                content: new Text(
                    'Last updated at ${_dateFormat.format(_lastUpdate)} ${_lastUpdate.timeZoneName}'),
              );
            },
          );
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      _offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  void getDataByCurrentCountrySelected() {
    this
        ._apiService
        .getResumeByCountry(_selectedCountry, true, false)
        .then((data) {
      _countryResumeCases = data;
      onScroll(); //for reloading data automatically
    });
  }

  Future<Null> _refresh() {
    return this._apiService.getGlobalResume().then((data) {
      if (_globalCovidCase.updated == data.updated) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Data updated successfully"),
              content: new Text(
                  'Last updated at ${_dateFormat.format(_lastUpdate)} ${_lastUpdate.timeZoneName}'),
            );
          },
        );
      } else {
        _globalCovidCase = data;
        _lastUpdate =
            new DateTime.fromMillisecondsSinceEpoch(_globalCovidCase.updated);
        this._apiService.getCountriesResume().then((data) {
          _countries = data;
          getDataByCurrentCountrySelected();
          onScroll();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop(true);
              });
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Data updated successfully"),
                content: new Text(
                    'Last updated at ${_dateFormat.format(_lastUpdate)} ${_lastUpdate.timeZoneName}'),
              );
            },
          );
        });
      }
    });
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
      switch (_selectedChoice.id) {
        case 'get_to_know':
          {}
          break;
        case 'sites_references':
          {}
          break;
        case 'about':
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutApp()),
            );
          }
          break;
        default:
          {}
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this._apiService.getGlobalResume().then((data) {
      _globalCovidCase = data;
    });

    if (_countries.length == 0) {
      this._apiService.getCountriesResume().then((data) {
        _countries = data;
        getDataByCurrentCountrySelected();
      });
    }
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                Color(0xFF3383CD),
                Color(0xFF3383CD),
              ])),
        ),
        title: Text(
          "Covid-19",
          style: kHeadingTextStyle.copyWith(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Row(
                    children: <Widget>[
                      Icon(choice.icon, size: 30.0, color: kPrimaryColor),
                      Text(choice.title),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: Scrollbar(
            child: ListView(
              controller: controller,
              children: <Widget>[
                MyHeader(
                  image: "assets/icons/Drcorona.svg",
                  textTop: "All you need",
                  textBottom: "is stay at home.",
                  offset: _offset,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Global Statistics\n",
                                  style: kTitleTextstyle,
                                ),
                                TextSpan(
                                  text:
                                      'Last updated at ${_dateFormat.format(_lastUpdate)} ${_lastUpdate.timeZoneName}',
                                  style: TextStyle(
                                      color: kTextLightColor, fontSize: 13.0),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Text(
                            "See details",
                            style: TextStyle(
                              color: kInfectedColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 30,
                              color: kShadowColor,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Counter(
                              color: kInfectedColor,
                              number: _globalCovidCase.cases,
                              title: "Infected",
                            ),
                            Counter(
                              color: kDeathColor,
                              number: _globalCovidCase.deaths,
                              title: "Deaths",
                            ),
                            Counter(
                              color: kRecovercolor,
                              number: _globalCovidCase.recovered,
                              title: "Recovered",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Select your country: ",
                            style: kTitleTextstyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Color(0xFFE5E5E5),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                            SizedBox(width: 20),
                            Expanded(
                              child: DropdownButton(
                                isExpanded: true,
                                underline: SizedBox(),
                                icon: SvgPicture.asset(
                                    "assets/icons/dropdown.svg"),
                                value: _selectedCountry,
                                //this code is by default
                                items: _countries.map<DropdownMenuItem<String>>(
                                    (Country value) {
                                  return DropdownMenuItem<String>(
                                    value: value.countryInfo.iso3,
                                    child: Text(value.country),
                                  );
                                }).toList(),
                                onChanged: (selectedValue) {
                                  setState(() {
                                    _selectedCountry = selectedValue;
                                    getDataByCurrentCountrySelected();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 30,
                              color: kShadowColor,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Counter(
                              color: kInfectedColor,
                              number: _countryResumeCases.cases,
                              title: "Infected",
                            ),
                            Counter(
                              color: kDeathColor,
                              number: _countryResumeCases.deaths,
                              title: "Deaths",
                            ),
                            Counter(
                              color: kRecovercolor,
                              number: _countryResumeCases.recovered,
                              title: "Recovered",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon, this.id});

  final String title;
  final IconData icon;
  final String id;
}
