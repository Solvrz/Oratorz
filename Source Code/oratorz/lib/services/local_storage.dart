import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/models/committee.dart';
import '/tools/controllers/comittee/committee.dart';

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

  static void clearCommittee() {
    box.write("committee", "");
  }
}
