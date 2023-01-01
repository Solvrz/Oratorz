import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/models/committee.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/speech.dart';

// ignore: avoid_classes_with_only_static_members
class LocalStorage {
  static GetStorage box = GetStorage();

  static void saveCommittee(CommitteeController committee) {
    //TODO: Assign a unique ID to each committee
    box.write("committee", committee.toJson());
  }

  static bool committeeExists() {
    final Map<String, dynamic>? data = box.read("committee");

    if (data == null) return false;
    return true;
  }

  static bool updateCommittee(String key, dynamic value) {
    final Map<String, dynamic>? data = box.read("committee");

    if (data == null) return false;

    data[key] = value;

    box.write("committee", data);

    return true;
  }

  static void loadCommittee() {
    final Map<String, dynamic>? data = box.read("committee");

    if (data == null) return;

    final Committee committee = Committee(
      name: data["committee"]["name"],
      agenda: data["committee"]["agenda"],
      delegates: data["committee"]["delegates"].cast<String>(),
    );

    final CommitteeController controller =
        CommitteeController(committee: committee);
    controller.rollCall = Map<String, int>.from(data["rollCall"]);

    Get.put<CommitteeController>(controller);
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

  static void clearData() => box.erase();
}
