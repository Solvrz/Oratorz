import 'dart:math';

import 'package:get/get.dart';

import '/config/constants/data.dart';
import '/tools/controllers/comittee/committee.dart';

class Committee {
  late String id;
  late String name;
  late String agenda;
  late List<String> delegates;
  late String type;

  Committee({
    String? id,
    this.name = "Your Committee",
    this.agenda = "Your Agenda",
    List<String>? delegates,
    String? type,
  }) {
    this.id =
        id ?? (Random().nextInt(pow(10, 8) as int) + pow(10, 8)).toString();
    this.delegates = delegates ?? [];
    this.type = type ?? "Custom";
  }

  Committee.fromTemplate(String id) {
    name = id;
    agenda = "Your Agenda";
    delegates = COMMITTEES[id]!;
    type = id;
  }

  Committee.fromJson(Map<String, dynamic> data) {
    name = data["name"] ?? "Your Committee";
    agenda = data["agenda"] ?? "Your Agenda";
    delegates = data["delegates"] ?? [];
    type = data["type"] ?? "Custom";
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
        "name": name,
        "agenda": agenda,
        "delegates": delegates,
        "type": type,
      };
}
