import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/tools/controllers/comittee/committee.dart';

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
  List<String> get presentDelegates => delegates
      .where(
        (element) => Get.find<CommitteeController>().rollCall[element]! > 0,
      )
      .toList();
  List<String> get presentAndVotingDelegates => delegates
      .where(
        (element) => Get.find<CommitteeController>().rollCall[element]! > 1,
      )
      .toList();

  void addSpeaker(String delegate) => speakers.add(delegate);
  void removeSpeaker(String delegate) => speakers.remove(delegate);
}
