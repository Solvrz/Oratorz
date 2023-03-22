import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/services/uid.dart';
import '/tools/controllers/comittee/committee.dart';

class Committee {
  late String id;
  late String name;
  late String agenda;
  late List<String> delegates;

  String get type {
    for (final MapEntry<String, List<String>> entry in COMMITTEES.entries) {
      if (entry.value.every((element) => delegates.contains(element))) {
        return entry.key;
      }
    }

    return "Custom";
  }

  Committee({
    String? id,
    this.name = "Your Committee",
    this.agenda = "Your Agenda",
    List<String>? delegates,
  }) {
    this.id = id ?? Uid.generate();
    this.delegates = delegates ?? [];
  }

  Committee.fromTemplate(String id) {
    name = id;
    agenda = "Your Agenda";
    delegates = COMMITTEES[id]!;
  }

  Committee.fromJson(Map<String, dynamic> data) {
    name = data["name"] ?? "Your Committee";
    agenda = data["agenda"] ?? "Your Agenda";
    delegates = data["delegates"] ?? [];
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "agenda": agenda,
        "delegates": delegates,
        "type": type,
      };
}
