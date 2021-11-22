import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../models/covid.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'covid_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Covid initialInfo = Covid('0', '0', '0', DateTime.now(), 0.5, 0.5);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale("en"),
      ],
      localizationsDelegates: const [
        CountryLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
          create: (context) => ItemBloc(initialInfo),
          child: const MyHomePage(title: 'Covid19')),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: BlocBuilder<ItemBloc, Covid>(builder: (context, todayInfo) {
          return SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.purple, Colors.blue])),
              child: Column(children: [
                Row(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(50)),
                          child: Image.asset('assets/images/corona.jpg')),
                    ),
                    Flexible(
                        child: Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: const Text(
                              "Fight together!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 40),
                            ))),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 20, bottom: 20, left: 40),
                  child: Row(
                    children: [
                      const Text(
                        "Choose country to explore",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Flexible(
                        child: CountryCodePicker(
                          onChanged: (countryCode) =>
                              BlocProvider.of<ItemBloc>(context, listen: false)
                                  .add(Country(countryCode.name.toString())),
                          initialSelection: 'UA',
                          showCountryOnly: true,
                          showOnlyCountryWhenClosed: true,
                          alignLeft: false,
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                covidInfo(Icons.cancel_outlined, Colors.red,
                                    todayInfo.active, "Active"),
                                covidInfo(Icons.warning, Colors.black,
                                    todayInfo.todayDeaths, "Deaths"),
                                covidInfo(Icons.favorite_outlined, Colors.green,
                                    todayInfo.todayRecovered, "Recovered"),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircularPercentIndicator(
                                  radius: 105.0,
                                  lineWidth: 7.0,
                                  percent: todayInfo.affectedInPercents,
                                  center: const Text('Affected',
                                      style: TextStyle(color: Colors.black)),
                                  progressColor: Colors.lightGreen,
                                ),
                                CircularPercentIndicator(
                                  radius: 105.0,
                                  lineWidth: 7.0,
                                  percent: todayInfo.vaccinatedInPercents,
                                  center: const Text('Vaccinated',
                                      style: TextStyle(color: Colors.black)),
                                  progressColor: Colors.yellow,
                                ),
                              ],
                            ),
                          ])),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "Last updated: ${todayInfo.lastUpdated}",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ]),
            ),
          );
        }));
  }

  Widget covidInfo(icon, color, number, title) {
    return Column(
      children: [
        SizedBox(
          height: 25,
          width: 25,
          child: Icon(
            icon,
            color: color,
            size: 24.0,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          number.toString(),
          style: TextStyle(
            fontSize: 25,
            color: color,
          ),
        ),
        Text(title),
      ],
    );
  }
}
