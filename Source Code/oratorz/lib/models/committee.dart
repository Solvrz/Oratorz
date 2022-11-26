import '/config/country_info.dart';

class Committee {
  late String? name;
  late List<String> countries;
  late List<String> speakers;

  Committee({
    this.name,
    List<String>? countries,
    List<String>? speakers,
  }) {
    this.countries = countries ?? [];
    this.speakers = speakers ?? [];
  }

  Committee.fromTemplate(String template) {
    name = template;
    countries = COMMITTEES[template]!;
  }

  int get count => countries.length;

  void addSpeaker(String country) => speakers.add(country);
  void removeSpeaker(String country) => speakers.remove(country);
}
