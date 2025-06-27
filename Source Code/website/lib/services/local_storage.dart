// ignore_for_file: avoid_classes_with_only_static_members

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/config/constants.dart';
import '/models/committee.dart';
import '/models/scorecard.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/motions.dart';
import '/tools/controllers/comittee/scorecard.dart';
import '/tools/controllers/comittee/speech.dart';
import '/tools/controllers/comittee/vote.dart';
import '../models/user.dart';
import '../tools/controllers/app.dart';

class LocalStorage {
  static GetStorage box = GetStorage();
  static AppController get controller => Get.find<AppController>();

  static List<String> get pinned {
    final List<String>? data = box.read("pinned")?.cast<String>();

    if (data == null) {
      box.write("pinned", []);

      return [];
    }

    return data;
  }

  static Future<void> deleteCommittee(String id) async {
    final User user = controller.user!;
    user.committees.removeWhere((committee) => committee.id == id);
    controller.update();

    await FirebaseFirestore.instance.collection("committees").doc(id).delete();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.email)
        .set(user.toJson());
  }

  static bool committeeExists(String id) =>
      controller.user!.committees.any((committee) => committee.id == id);

  static Committee getCommittee(String id) => Committee.fromJson(box.read(id));

  static void loadCommittee(String id) {
    //FIXME: Fix according to new Firebase structure
    final Map<String, dynamic>? data = box.read(id);

    if (data == null) return;

    Get.put<CommitteeController>(
      CommitteeController(committee: getCommittee(id)),
    );

    ANALYTICS.logEvent(name: "committe_loaded");
  }

  static bool saveSpeech(SpeechController controller) {
    if (!Get.isRegistered<CommitteeController>()) return false;

    final Committee committee = Get.find<CommitteeController>().committee;

    final Map<String, dynamic> data = box.read(committee.id);

    data[controller.tag] = controller.toJson();

    box.write(committee.id, data);

    return true;
  }

  static bool updateSpeech(String key, dynamic value, String tag) {
    if (!Get.isRegistered<CommitteeController>()) return false;

    final Committee committee = Get.find<CommitteeController>().committee;

    final Map<String, dynamic> data = box.read(committee.id);

    if (data[tag] == null) return false;

    data[tag][key] = value;

    box.write(committee.id, data);

    return true;
  }

  static bool loadSpeech(String tag) {
    if (!Get.isRegistered<CommitteeController>()) return false;

    final Committee committee = Get.find<CommitteeController>().committee;

    final Map<String, dynamic> data = box.read(committee.id);

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
            element.keys.first: Duration(seconds: element.values.first),
          },
        )
        .toList();

    controller.nextSpeakers.value = List<String>.from(data[tag]["next"]);

    Get.put<SpeechController>(controller, tag: tag);

    return true;
  }

  static bool saveVote(VoteController vote) {
    if (!Get.isRegistered<CommitteeController>()) return false;

    final Committee committee = Get.find<CommitteeController>().committee;

    final Map<String, dynamic> data = box.read(committee.id);

    data["vote"] = vote.toJson();

    box.write(committee.id, data);

    return true;
  }

  static bool updateVote(String key, dynamic value) {
    if (!Get.isRegistered<CommitteeController>()) return false;

    final Committee committee = Get.find<CommitteeController>().committee;

    final Map<String, dynamic> data = box.read(committee.id);

    if (data["vote"] == null) return false;

    data["vote"][key] = value;
    box.write(committee.id, data);

    return true;
  }

  static bool loadVote() {
    if (!Get.isRegistered<CommitteeController>()) return false;

    final Committee committee = Get.find<CommitteeController>().committee;

    final Map<String, dynamic> data = box.read(committee.id);

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
    if (!Get.isRegistered<CommitteeController>()) return false;

    final Committee committee = Get.find<CommitteeController>().committee;

    final Map<String, dynamic> data = box.read(committee.id);

    data["motions"] = Get.find<MotionsController>().toJson();

    box.write(committee.id, data);

    return true;
  }

  static bool updateMotions(String key, dynamic value) {
    if (!Get.isRegistered<CommitteeController>()) return false;

    final Committee committee = Get.find<CommitteeController>().committee;

    final Map<String, dynamic> data = box.read(committee.id);

    if (data["motions"] == null) return false;

    data["motions"][key] = value;
    box.write(committee.id, data);

    return true;
  }

  static bool loadMotions() {
    if (!Get.isRegistered<CommitteeController>()) return false;

    final Committee committee = Get.find<CommitteeController>().committee;

    final Map<String, dynamic> data = box.read(committee.id);
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

    Get.put<MotionsController>(controller);

    return true;
  }

  static bool saveScore() {
    if (!Get.isRegistered<CommitteeController>()) return false;

    final Committee committee = Get.find<CommitteeController>().committee;

    final Map<String, dynamic> data = box.read(committee.id);

    data["score"] = Get.find<ScorecardController>().scorecard.toJson();

    box.write(committee.id, data);

    return true;
  }

  static bool updateScore(String key, dynamic value) {
    if (!Get.isRegistered<CommitteeController>()) return false;

    final Committee committee = Get.find<CommitteeController>().committee;

    final Map<String, dynamic> data = box.read(committee.id);

    if (data["score"] == null) return false;

    data["score"][key] = value;
    box.write(committee.id, data);

    return true;
  }

  static bool loadScore() {
    if (!Get.isRegistered<CommitteeController>()) return false;

    final Map<String, dynamic> data =
        box.read(Get.find<CommitteeController>().committee.id);

    if (data["score"] == null) return false;

    final ScorecardController controller =
        ScorecardController(Scorecard.fromJson(data["score"]));

    Get.put<ScorecardController>(controller);

    return true;
  }

  static void clearData() => box.erase();
}
