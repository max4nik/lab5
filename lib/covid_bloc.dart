import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/covid.dart';

class Country {
  Country(this._name);

  final String _name;

  String get name => _name;
}

class ItemBloc extends Bloc<Country, Covid> {
  ItemBloc(Covid initialState) : super(initialState);
  Covid todayInfo = Covid('0', '0', '0', DateTime.now(), 0.5, 0.5);

  @override
  Stream<Covid> mapEventToState(Country event) async* {
    String countryName = event._name.toString();

    // handle multiple names usage for one country
    if (countryName.contains('[')){
      countryName = countryName.split(',')[1].replaceAll(' ', '').replaceAll(']', '');
    }

    final response = await http.get(Uri.parse(
        'https://corona.lmao.ninja/v2/countries/$countryName?yesterday'));
    if (response.statusCode == 200) {
      todayInfo = Covid.fromJson(jsonDecode(response.body));
    } else {
      todayInfo = Covid.fromJson(jsonDecode(
          '{"active": "NaN", "todayDeaths": "NaN", "todayRecovered": "NaN", "oneCasePerPeople": 1, "tests": 0, "population": 1, "updated": 0}'));
    }
    yield todayInfo;
  }
}
