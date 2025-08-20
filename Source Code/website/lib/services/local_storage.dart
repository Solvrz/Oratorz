// ignore_for_file: avoid_classes_with_only_static_members

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/models/committee.dart';
import '/tools/controllers/app.dart';
import '/tools/controllers/setup.dart';

class LocalStorage {
  static GetStorage box = GetStorage();
  static AppController get controller => Get.find<AppController>();

  static Committee? loadSetup() {
    final Map<String, dynamic>? data = box.read("setup-committee");

    return data != null ? Committee.fromJsonConfig(data) : null;
  }

  static void saveSetup() => box.write(
        "setup-committee",
        Get.find<SetupController>().committee.toJsonConfig(),
      );

  static void clearSetup() => box.remove("setup-committee");

  static bool committeeExists(String id) =>
      controller.user!.committees.any((committee) => committee.id == id);

  static Committee getCommittee(String id) => Committee.fromJson(box.read(id));

  // static bool saveVote(VoteController vote) {
  //   if (!Get.isRegistered<CommitteeController>()) return false;

  //   final Committee committee = Get.find<CommitteeController>().committee;

  //   final Map<String, dynamic> data = box.read(committee.id);

  //   data["vote"] = vote.toJson();

  //   box.write(committee.id, data);

  //   return true;
  // }

  // static bool updateVote(String key, dynamic value) {
  //   if (!Get.isRegistered<CommitteeController>()) return false;

  //   final Committee committee = Get.find<CommitteeController>().committee;

  //   final Map<String, dynamic> data = box.read(committee.id);

  //   if (data["vote"] == null) return false;

  //   data["vote"][key] = value;
  //   box.write(committee.id, data);

  //   return true;
  // }

  // static bool loadVote() {
  //   if (!Get.isRegistered<CommitteeController>()) return false;

  //   final Committee committee = Get.find<CommitteeController>().committee;

  //   final Map<String, dynamic> data = box.read(committee.id);

  //   if (data["vote"] == null) return false;

  //   final VoteController controller = VoteController();

  //   controller.topic = data["vote"]["topic"];
  //   controller.majority = data["vote"]["majority"];
  //   controller.voters = List<String>.from(data["vote"]["voters"]);
  //   controller.pastVoters = data["vote"]["past"]
  //       .map<Map<String, bool>>((element) => Map<String, bool>.from(element))
  //       .toList();

  //   Get.put<VoteController>(controller, tag: "vote");

  //   return true;
  // }

  static void clearData() => box.erase();
}
