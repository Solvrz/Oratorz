import '/config/data.dart';
import '/services/uid.dart';

abstract class RollCall {
  static const int presentAndVoting = 2;
  static const int present = 1;
  static const int absent = 0;
  static const int none = -1;
}

class Committee {
  late String id;
  late String name;
  late String agenda;
  late List<String> delegates;
  late Map<String, int> rollCall;

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
  }) {
    this.id = id ?? Uid.generate();
    this.delegates = delegates ?? [];

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
    delegates = data["delegates"].cast<String>() ?? [];

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
      };
}
