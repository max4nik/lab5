class Covid {
  // dynamic values are needed for "NaN" value displaying when info for country doesn't exist
  String active;
  String todayDeaths;
  String todayRecovered;
  String lastUpdated;
  String affectedInPercents;
  String vaccinatedInPercents;

  Covid(this.active, this.todayDeaths, this.todayRecovered, this.lastUpdated,
      this.affectedInPercents, this.vaccinatedInPercents);

  factory Covid.fromJson(dynamic json) {
    if (json['active'] == "NaN"){
      return Covid(
          json['active'].toString(),
          json['todayDeaths'].toString(),
          json['todayRecovered'].toString(),
          json['updated'].toString(),
          '1',
          '1');
    }
    DateTime updated =
        DateTime.fromMillisecondsSinceEpoch(json['updated']);
    double affectedInPercents = (1 / json['oneCasePerPeople']);
    double vaccinatedInPercents = (json['tests'] / json['population']);
    if (vaccinatedInPercents > 1){
      vaccinatedInPercents = 1;
    }
    return Covid(
        json['active'].toString(),
        json['todayDeaths'].toString(),
        json['todayRecovered'].toString(),
        updated.toString(),
        affectedInPercents.toString(),
        vaccinatedInPercents.toString());
  }
}
