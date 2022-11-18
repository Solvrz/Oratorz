class Committee {
  late String name;
  late List<String> countries;
  late List<String> speakers;

  int get count => countries.length;

  void addSpeaker(String country) => speakers.add(country);
  void removeSpeaker(String country) => speakers.remove(country);

  Committee({
    String? name,
    List<String>? countries,
    List<String>? speakers,
  }) {
    this.name = name ?? "";
    this.countries = countries ?? [];
    this.speakers = speakers ?? [];
  }
}
