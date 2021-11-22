class Covid {
  // dynamic values are needed for "NaN" value displaying when info for country doesn't exist
  dynamic active;
  dynamic todayDeaths;
  dynamic todayRecovered;
  dynamic lastUpdated;
  dynamic affectedInPercents;
  dynamic vaccinatedInPercents;

  Covid(this.active, this.todayDeaths, this.todayRecovered, this.lastUpdated,
      this.affectedInPercents, this.vaccinatedInPercents);

  factory Covid.fromJson(dynamic json) {
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
        updated,
        affectedInPercents,
        vaccinatedInPercents);
  }
}
