import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/models/committee.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/speech.dart';
import '../tools/controllers/comittee/motions.dart';
import '../tools/controllers/comittee/scorecard.dart';
import '../tools/controllers/comittee/vote.dart';

// ignore: avoid_classes_with_only_static_members
class LocalStorage {
  static GetStorage box = GetStorage();

  static void saveCommittee(CommitteeController committee) {
    //TODO: Assign a unique ID to each committee
    box.write("committee", committee.toJson());
  }

  static bool updateCommittee(String key, dynamic value) {
    final Map<String, dynamic>? data = box.read("committee");

    if (data == null) return false;

    data[key] = value;

    box.write("committee", data);

    return true;
  }

  static bool loadCommittee() {
    final Map<String, dynamic>? data = box.read("committee");

    if (data == null) return false;

    final Committee committee = Committee(
      name: data["committee"]["name"],
      agenda: data["committee"]["agenda"],
      delegates: data["committee"]["delegates"].cast<String>(),
    );

    final CommitteeController controller =
        CommitteeController(committee: committee);
    controller.rollCall = Map<String, int>.from(data["rollCall"]);

    Get.put<CommitteeController>(controller);

    return true;
  }

  static void saveSpeech(SpeechController controller) =>
      box.write(controller.tag, controller.toJson());

  static bool updateSpeech(String key, dynamic value, String tag) {
    final Map<String, dynamic>? data = box.read(tag);

    if (data == null) return false;

    data[key] = value;

    box.write(tag, data);

    return true;
  }

  static bool loadSpeech(String tag) {
    final Map<String, dynamic>? data = box.read(tag);

    if (data == null) return false;

    final SpeechController controller = SpeechController(tag);

    controller.subtopic = Map<String, String>.from(data["subtopic"]);
    controller.overallDuration = Duration(seconds: data["overall"]);
    controller.duration = Duration(seconds: data["duration"]);
    controller.currentSpeaker = data["current"];

    final List<Map<String, int>> past = data["past"]
        .map<Map<String, int>>((element) => Map<String, int>.from(element))
        .toList();

    controller.pastSpeakers.value = past
        .map<Map<String, Duration>>(
          (element) => <String, Duration>{
            element.keys.first: Duration(seconds: element.values.first)
          },
        )
        .toList();

    controller.nextSpeakers.value = List<String>.from(data["next"]);

    Get.put<SpeechController>(controller, tag: tag);

    return true;
  }

  static void saveVote(VoteController vote) {
    box.write("vote", vote.toJson());
  }

  static bool updateVote(String key, dynamic value) {
    final Map<String, dynamic>? data = box.read("vote");

    if (data == null) return false;

    data[key] = value;

    box.write("vote", data);

    return true;
  }

  static bool loadVote() {
    final Map<String, dynamic>? data = box.read("vote");

    if (data == null) return false;

    final VoteController controller = VoteController();

    controller.topic = data["topic"];
    controller.majority = data["majority"];
    controller.voters = List<String>.from(data["voters"]);
    controller.pastVoters = data["past"]
        .map<Map<String, bool>>((element) => Map<String, bool>.from(element))
        .toList();

    Get.put<VoteController>(controller, tag: "vote");

    return true;
  }

  static void saveMotions(MotionsController motions) {
    box.write("motions", motions.toJson());
  }

  static bool updateMotions(String key, dynamic value) {
    final Map<String, dynamic>? data = box.read("motions");

    if (data == null) return false;

    data[key] = value;

    box.write("motions", data);

    return true;
  }

  static bool loadMotions() {
    final Map<String, dynamic>? data = box.read("motions");

    if (data == null) return false;

    final MotionsController controller = MotionsController();

    controller.mode = data["mode"];
    controller.currentMotion = Map<String, dynamic>.from(data["current"]);

    controller.nextMotions = data["next"]
        .map<Map<String, dynamic>>(
          (element) => Map<String, dynamic>.from(element),
        )
        .toList();

    controller.pastMotions = data["past"]
        .map<Map<Map<String, dynamic>, bool>>(
          (element) => Map<Map<String, dynamic>, bool>.from(element),
        )
        .toList();

    Get.put<MotionsController>(controller);

    return true;
  }

  static void saveScore(ScorecardController score) {
    box.write("score", score.toJson());
  }

  static bool updateScore(String key, dynamic value) {
    final Map<String, dynamic>? data = box.read("score");

    if (data == null) return false;

    data[key] = value;

    box.write("score", data);

    return true;
  }

  static bool loadScore() {
    final Map<String, dynamic>? data = box.read("score");

    if (data == null) return false;

    final ScorecardController controller = ScorecardController();

    controller.parameters.value = List<String>.from(data["parameters"]);
    controller.maxScores.value = List<int>.from(data["maxScores"]);
    controller.scores.value = Map<String, List<double>>.from(
      data["scores"].map<String, List<double>>(
        (key, value) =>
            MapEntry<String, List<double>>(key, List<double>.from(value)),
      ),
    );

    Get.put<ScorecardController>(controller);

    return true;
  }

  static void clearData() => box.erase();
}
