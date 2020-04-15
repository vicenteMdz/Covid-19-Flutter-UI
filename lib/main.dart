import 'package:covid19/constant.dart';
import 'package:covid19/models/country.dart';
import 'package:covid19/services/novel_covid_api_service.dart';
import 'package:covid19/services/service_locator.dart';
import 'package:covid19/widgets/counter.dart';
import 'package:covid19/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

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
      debugShowCheckedModeBanner: true,
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
  double offset = 0;
  String selectedCountry = "MEX";

  GlobalCovidCase globalCovidCase = new GlobalCovidCase();
  Country countryResumeCases = new Country();
  List<Country> countries = [];

  NovelCovidApiService _apiService = locator<NovelCovidApiService>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  void getDataByCurrentCountrySelected() {
    if(this.countries.length == 0)
      return;
    List<Country> temp = this
        .countries
        .where((item) => item.countryInfo.iso3 == this.selectedCountry)
        .toList();
    if (temp.length > 0) {
      this.countryResumeCases = temp[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    this._apiService.getGlobalResume().then((data) {
      this.globalCovidCase = data;
    });

    if (this.countries.length == 0) {
      this._apiService.getCountriesResume().then((data) {
        this.countries = data;
        getDataByCurrentCountrySelected();
      });
    }

    return Scaffold(
      body: ListView(
        controller: controller,
        children: <Widget>[
          MyHeader(
            image: "assets/icons/Drcorona.svg",
            textTop: "All you need",
            textBottom: "is stay at home.",
            offset: offset,
          ),
          /* SizedBox(height: 20),*/
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
                            text: 'Last updated at ' +
                                new DateTime.fromMillisecondsSinceEpoch(
                                        globalCovidCase == null
                                            ? 0
                                            : globalCovidCase.updated)
                                    .toString(),
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
                        number: globalCovidCase.cases,
                        title: "Infected",
                      ),
                      Counter(
                        color: kDeathColor,
                        number: globalCovidCase.deaths,
                        title: "Deaths",
                      ),
                      Counter(
                        color: kRecovercolor,
                        number: globalCovidCase.recovered,
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
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                          icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                          value: this.selectedCountry,
                          //this code is by default
                          items: countries
                              .map<DropdownMenuItem<String>>((Country value) {
                            return DropdownMenuItem<String>(
                              value: value.countryInfo.iso3,
                              child: Text(value.country),
                            );
                          }).toList(),
                          onChanged: (selectedValue) {
                            setState(() {
                              this.selectedCountry = selectedValue;
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
                        number: countryResumeCases.cases,
                        title: "Infected",
                      ),
                      Counter(
                        color: kDeathColor,
                        number: countryResumeCases.deaths,
                        title: "Deaths",
                      ),
                      Counter(
                        color: kRecovercolor,
                        number: countryResumeCases.recovered,
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
    );
  }
}
