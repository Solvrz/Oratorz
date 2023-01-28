import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/config/constants/constants.dart';
import '/models/committee.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/speech.dart';
import '../tools/controllers/comittee/motions.dart';
import '../tools/controllers/comittee/scorecard.dart';
import '../tools/controllers/comittee/vote.dart';

// ignore: avoid_classes_with_only_static_members
class LocalStorage {
  static GetStorage box = GetStorage();

  static String get selectedCommittee => box.read("selected") ?? "";

  static void deselect() => box.write("selected", "");

  static List<String> get committees {
    final List<dynamic>? data = box.read("committees");

    if (data == null) {
      box.write("committees", []);

      return [];
    }

    return data.cast<String>();
  }

  static void createCommittee(Committee committee) {
    final CommitteeController controller =
        CommitteeController(committee: committee);

    analytics.logEvent(
      name: "committe_created",
      parameters: {
        "committee": controller.toJson().toString(),
        "id": controller.committee.id,
      },
    );

    committees.add(controller.committee.id);

    box.write(controller.committee.id, controller.toJson());
    box.write("selected", controller.committee.id);
    box.write("committees", committees);

    Get.put<CommitteeController>(controller);
  }

  static void deleteCommittee(String id) {
    box.remove(id);

    final List<String> data = committees;
    data.remove(id);

    box.write("committees", data);
  }

  static bool committeeExists(String id) => box.hasData(id);

  static bool updateCommittee(String key, dynamic value) {
    if (selectedCommittee == "") return false;

    final Map<String, dynamic>? data = box.read(selectedCommittee);

    if (data == null) return false;

    analytics.logEvent(
      name: "committe_updated",
      parameters: {
        "committee": data.toString(),
        "id": selectedCommittee,
      },
    );

    data[key] = value;
    box.write(selectedCommittee, data);

    return true;
  }

  static Committee getCommittee(String id) {
    final Map<String, dynamic> data = box.read(id);

    final Committee committee = Committee(
      id: id,
      name: data["committee"]["name"],
      agenda: data["committee"]["agenda"],
      delegates: data["committee"]["delegates"].cast<String>(),
      type: data["committee"]["type"],
    );

    return committee;
  }

  static void loadCommittee(String id) {
    final Map<String, dynamic>? data = box.read(id);

    if (data == null) return;

    final CommitteeController controller =
        CommitteeController(committee: getCommittee(id));

    controller.rollCall = Map<String, int>.from(data["rollCall"]);

    Get.put<CommitteeController>(controller);
    box.write("selected", id);
  }

  static void saveSpeech(SpeechController controller) =>
      box.write(controller.tag, controller.toJson());

  static bool updateSpeech(String key, dynamic value, String tag) {
    if (LocalStorage.selectedCommittee == "") return false;

    final Map<String, dynamic> data = box.read(LocalStorage.selectedCommittee);

    if (data[tag] == null) return false;

    data[tag][key] = value;

    box.write(LocalStorage.selectedCommittee, data);

    return true;
  }

  static bool loadSpeech(String tag) {
    if (LocalStorage.selectedCommittee == "") return false;

    final Map<String, dynamic> data = box.read(LocalStorage.selectedCommittee);

    if (data[tag] == null) return false;

    final SpeechController controller = SpeechController(tag);

    controller.subtopic = Map<String, String>.from(data[tag]["subtopic"]);
    controller.overallDuration = Duration(seconds: data[tag]["overall"]);
    controller.duration = Duration(seconds: data[tag]["duration"]);
    controller.currentSpeaker = data[tag]["current"];

    final List<Map<String, int>> past = data[tag]["past"]
        .map<Map<String, int>>((element) => Map<String, int>.from(element))
        .toList();

    controller.pastSpeakers.value = past
        .map<Map<String, Duration>>(
          (element) => <String, Duration>{
            element.keys.first: Duration(seconds: element.values.first)
          },
        )
        .toList();

    controller.nextSpeakers.value = List<String>.from(data[tag]["next"]);

    Get.put<SpeechController>(controller, tag: tag);

    return true;
  }

  static bool saveVote(VoteController vote) {
    if (LocalStorage.selectedCommittee == "") return false;

    final Map<String, dynamic> data = box.read(LocalStorage.selectedCommittee);

    data["vote"] = vote.toJson();

    box.write(LocalStorage.selectedCommittee, data);

    return true;
  }

  static bool updateVote(String key, dynamic value) {
    if (LocalStorage.selectedCommittee == "") return false;

    final Map<String, dynamic> data = box.read(LocalStorage.selectedCommittee);

    if (data["vote"] == null) return false;

    data["vote"][key] = value;
    box.write(LocalStorage.selectedCommittee, data);

    return true;
  }

  static bool loadVote() {
    if (LocalStorage.selectedCommittee == "") return false;

    final Map<String, dynamic> data = box.read(LocalStorage.selectedCommittee);

    if (data["vote"] == null) return false;

    final VoteController controller = VoteController();

    controller.topic = data["vote"]["topic"];
    controller.majority = data["vote"]["majority"];
    controller.voters = List<String>.from(data["vote"]["voters"]);
    controller.pastVoters = data["vote"]["past"]
        .map<Map<String, bool>>((element) => Map<String, bool>.from(element))
        .toList();

    Get.put<VoteController>(controller, tag: "vote");

    return true;
  }

  static bool saveMotions() {
    if (LocalStorage.selectedCommittee == "") return false;

    final Map<String, dynamic> data = box.read(LocalStorage.selectedCommittee);

    data["motions"] = Get.find<MotionsController>().toJson();

    box.write(LocalStorage.selectedCommittee, data);

    return true;
  }

  static bool updateMotions(String key, dynamic value) {
    if (LocalStorage.selectedCommittee == "") return false;

    final Map<String, dynamic> data = box.read(LocalStorage.selectedCommittee);

    if (data["motions"] == null) return false;

    data["motions"][key] = value;
    box.write(LocalStorage.selectedCommittee, data);

    return true;
  }

  static bool loadMotions() {
    if (LocalStorage.selectedCommittee == "") return false;

    final Map<String, dynamic> data = box.read(LocalStorage.selectedCommittee);

    if (data["motions"] == null) return false;

    final MotionsController controller = MotionsController();

    controller.mode = data["motions"]["mode"];
    controller.currentMotion =
        Map<String, dynamic>.from(data["motions"]["current"]);

    controller.nextMotions = data["motions"]["next"]
        .map<Map<String, dynamic>>(
          (element) => Map<String, dynamic>.from(element),
        )
        .toList();

    controller.pastMotions = data["motions"]["past"]
        .map<Map<Map<String, dynamic>, bool>>(
          (element) => Map<Map<String, dynamic>, bool>.from(element),
        )
        .toList();

    Get.put<MotionsController>(controller);

    return true;
  }

  static bool saveScore() {
    if (LocalStorage.selectedCommittee == "") return false;

    final Map<String, dynamic> data = box.read(LocalStorage.selectedCommittee);

    data["score"] = Get.find<ScorecardController>().toJson();

    box.write(LocalStorage.selectedCommittee, data);

    return true;
  }

  static bool updateScore(String key, dynamic value) {
    if (LocalStorage.selectedCommittee == "") return false;

    final Map<String, dynamic> data = box.read(LocalStorage.selectedCommittee);

    if (data["score"] == null) return false;

    data["score"][key] = value;
    box.write(LocalStorage.selectedCommittee, data);

    return true;
  }

  static bool loadScore() {
    if (LocalStorage.selectedCommittee == "") return false;

    final Map<String, dynamic> data = box.read(LocalStorage.selectedCommittee);

    if (data["score"] == null) return false;

    final ScorecardController controller = ScorecardController();

    controller.parameters.value =
        List<String>.from(data["score"]["parameters"]);
    controller.maxScores.value = List<int>.from(data["score"]["maxScores"]);
    controller.scores.value = Map<String, List<double>>.from(
      data["score"]["scores"].map<String, List<double>>(
        (key, value) =>
            MapEntry<String, List<double>>(key, List<double>.from(value)),
      ),
    );

    Get.put<ScorecardController>(controller);

    return true;
  }

  static void clearData() => box.erase();
}
