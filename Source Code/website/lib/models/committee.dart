import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/config/data.dart';
import '/services/uid.dart';

abstract class RollCall {
  static const int presentAndVoting = 2;
  static const int present = 1;
  static const int absent = 0;
  static const int none = -1;
}

class Committee {
  late final String id;
  late String name;
  late String agenda;
  late final Timestamp? createdAt;
  late List<String> delegates;
  late Map<String, int> rollCall;
  late List<String> members;
  late List<DateTime?> days;

  String get type {
    for (final MapEntry<String, List<String>> entry in COMMITTEES.entries) {
      if (entry.value.every((element) => delegates.contains(element))) {
        return entry.key.contains("AIPPM") ? "AIPPM" : entry.key;
      }
    }

    return "Custom";
  }

  void initRollCall() => rollCall = {
        for (final String delegate in delegates) delegate: RollCall.none,
      };

  Committee({
    String? id,
    this.name = "Your Committee",
    this.agenda = "Your Agenda",
    List<String>? delegates,
    List<String>? members,
    List<DateTime?>? days,
    Timestamp? createdAt,
  }) {
    this.id = id ?? Uid.generate();
    this.delegates = delegates ?? [];
    this.members = members ?? [FirebaseAuth.instance.currentUser!.email!];
    this.days = days ?? [];
    this.createdAt = createdAt ?? Timestamp.now();

    initRollCall();
  }

  Committee.fromTemplate(String id) {
    name = id;
    agenda = "Your Agenda";
    delegates = COMMITTEES[id]!;
    initRollCall();
  }

  Committee.fromJson(Map<String, dynamic> data) {
    id = data["id"] ?? "";
    name = data["name"] ?? "Your Committee";
    agenda = data["agenda"] ?? "Your Agenda";
    delegates = (data["delegates"] ?? []).cast<String>();
    members = (data["members"] ?? []).cast<String>();

    days = [];
    for (final Timestamp? day in data["days"] ?? []) {
      days.add(day != null ? day.toDate() : null);
    }

    createdAt = data["createdAt"];

    if (data["rollCall"] != null) {
      rollCall = Map<String, int>.from(data["rollCall"]);
    } else {
      initRollCall();
    }
  }

  Committee.fromJsonConfig(Map<String, dynamic> data) {
    id = data["id"] ?? "";
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

    if (data["rollCall"] != null) {
      rollCall = Map<String, int>.from(data["rollCall"]);
    } else {
      initRollCall();
    }
  }

  int get count => delegates.length;

  List<String> get absentDelegates => delegates
      .where((element) => rollCall[element]! == RollCall.absent)
      .toList();

  List<String> get presentDelegates => delegates
      .where((element) => rollCall[element]! >= RollCall.present)
      .toList();

  List<String> get presentAndVotingDelegates => delegates
      .where((element) => rollCall[element]! == RollCall.presentAndVoting)
      .toList();

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "agenda": agenda,
        "delegates": delegates,
        "rollCall": rollCall,
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
