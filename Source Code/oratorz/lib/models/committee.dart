import '/config/data.dart';

class Committee {
  late String name;
  late String agenda;
  late List<String> delegates;
  late List<String> speakers;

  Committee({
    this.name = "Your Committee",
    this.agenda = "Your Agenda",
    List<String>? delegates,
    List<String>? speakers,
  }) {
    this.delegates = delegates ?? [];
    this.speakers = speakers ?? [];
  }

  Committee.fromTemplate(String template) {
    name = template;
    agenda = "Your Agenda";
    delegates = COMMITTEES[template]!;
  }

  int get count => delegates.length;

  void addSpeaker(String delegate) => speakers.add(delegate);
  void removeSpeaker(String delegate) => speakers.remove(delegate);
}
