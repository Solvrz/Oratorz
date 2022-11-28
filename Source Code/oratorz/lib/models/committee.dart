import '/config/data.dart';

class Committee {
  late String name;
  late String agenda;
  late List<String> countries;
  late List<String> speakers;

  Committee({
    this.name = "Your Committee",
    this.agenda = "Your Agenda",
    List<String>? countries,
    List<String>? speakers,
  }) {
    this.countries = countries ?? [];
    this.speakers = speakers ?? [];
  }

  Committee.fromTemplate(String template) {
    name = template;
    agenda = "Your Agenda";
    countries = COMMITTEES[template]!;
  }

  int get count => countries.length;

  void addSpeaker(String country) => speakers.add(country);
  void removeSpeaker(String country) => speakers.remove(country);
}
