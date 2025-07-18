import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '/config/data.dart';
import '/services/uid.dart';
import 'scorecard.dart';

abstract class RollCall {
  static const int presentAndVoting = 2;
  static const int present = 1;
  static const int absent = 0;
  static const int none = -1;
}

class Committee {
  late final String id;
  late String type;
  late String name;
  late String agenda;
  late final Timestamp? createdAt;
  late List<String> delegates;
  late List<String> members;
  late List<DateTime?> days;

  int currDay = -1;
  Rx<Scorecard>? scorecard;
  Map<String, int> rollCall = {};

  void initRollCall() => rollCall = {
        for (final String delegate in delegates) delegate: RollCall.none,
      };

  Committee({
    String? id,
    this.name = "Your Committee",
    this.agenda = "Your Agenda",
    String? type,
    List<String>? delegates,
    List<String>? members,
    List<DateTime?>? days,
    Timestamp? createdAt,
  }) {
    this.id = id ?? Uid.generate();
    this.delegates = delegates ?? [];
    this.type = type ?? "Custom";
    this.members = members ?? [FirebaseAuth.instance.currentUser!.email!];
    this.days = days ?? [];
    this.createdAt = createdAt ?? Timestamp.now();

    _currentDay();
  }

  Committee.fromTemplate(String id) {
    name = id;
    agenda = "Your Agenda";
    delegates = COMMITTEES[id]!;

    _currentDay();
  }

  Committee.fromJson(Map<String, dynamic> data) {
    id = data["id"] ?? "";
    type = data["type"] ?? "Custom";
    name = data["name"] ?? "Your Committee";
    agenda = data["agenda"] ?? "Your Agenda";
    delegates = (data["delegates"] ?? []).cast<String>();
    members = (data["members"] ?? []).cast<String>();

    days = [];
    for (final Timestamp? day in data["days"] ?? []) {
      days.add(day != null ? day.toDate() : null);
    }

    createdAt = data["createdAt"];

    _currentDay();
  }

  Committee.fromJsonConfig(Map<String, dynamic> data) {
    id = data["id"] ?? "";
    type = data["type"] ?? "Custom";
    name = data["name"] ?? "Your Committee";
    agenda = data["agenda"] ?? "Your Agenda";
    delegates = (data["delegates"] ?? []).cast<String>();
    members = (data["members"] ?? []).cast<String>();

    days = [];
    for (final int? day in data["days"] ?? []) {
      days.add(day != null ? DateTime.fromMillisecondsSinceEpoch(day) : null);
    }

    createdAt = data["createdAt"] == null
        ? null
        : Timestamp.fromMillisecondsSinceEpoch(int.parse(data["createdAt"]));

    _currentDay();
  }

  int get count => delegates.length;

  List<String> get absentDelegates => delegates
      .where((element) => (rollCall[element] ?? -1) == RollCall.absent)
      .toList();

  List<String> get presentDelegates => delegates
      .where((element) => (rollCall[element] ?? -1) >= RollCall.present)
      .toList();

  List<String> get presentAndVotingDelegates => delegates
      .where(
        (element) => (rollCall[element] ?? -1) == RollCall.presentAndVoting,
      )
      .toList();

  void _currentDay() {
    for (int i = 0; i < days.length; i++) {
      if (DateTime.now().isAfter(days[i]!) &&
          DateTime.now().isBefore(days[i]!.add(const Duration(days: 1)))) {
        currDay = i;
        return;
      }
    }

    return;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "agenda": agenda,
        "delegates": delegates,
        "type": type,
        if (createdAt != null) "createdAt": createdAt,
        "days": days
            .map<Timestamp?>(
              (day) => day != null ? Timestamp.fromDate(day) : null,
            )
            .toList(),
        "members": members,
      };

  Map<String, dynamic> toJsonConfig() => {
        "id": id,
        "name": name,
        "agenda": agenda,
        "delegates": delegates,
        "type": type,
        if (createdAt != null)
          "createdAt": createdAt!.millisecondsSinceEpoch.toString(),
        "days": days
            .map<int?>(
              (day) => day != null
                  ? Timestamp.fromDate(day).millisecondsSinceEpoch
                  : null,
            )
            .toList(),
        "members": members,
      };
}
