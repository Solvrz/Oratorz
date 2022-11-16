class Committee {
  late String name;
  late List<String> countries;
  late List<String> speakers;

  int get count => countries.length;

  void addSpeaker(String country) => speakers.add(country);
  void removeSpeaker(String country) => speakers.remove(country);

  Committee({
    String? name_,
    List<String>? countries_,
    List<String>? speakers_,
  }) {
    name = name_ ?? "";
    countries = countries_ ?? [];
    speakers = speakers_ ?? [];
  }
}
