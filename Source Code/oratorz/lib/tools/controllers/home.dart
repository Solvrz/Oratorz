import 'package:get/get.dart';

import '/models/committee.dart';
import './comittee/committee.dart';

class HomeController extends GetxController {
  late RxMap<String, int> rollCall;
  late Rx<CommitteeController> committeeController;

  HomeController({required Committee committee}) {
    rollCall = {for (String country in committee.countries) country: -1}.obs;
    committeeController = Get.put(
      CommitteeController(committee: committee),
    ).obs;
  }

  Rx<Committee> get committee => committeeController.value.committee;

  bool get areAllPresent => rollCall.values.toList().every((call) => call == 1);
  bool get areAllAbsent => rollCall.values.toList().every((call) => call == 0);

  void setAllPresent() => rollCall.updateAll((key, value) => 1);
  void setAllAbsent() => rollCall.updateAll((key, value) => 0);
  void setRollCall(String country, int attendance) =>
      rollCall[country] = attendance;
}
