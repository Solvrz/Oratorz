import 'package:get/get.dart';

import '/models/committee.dart';

class CommitteeController extends GetxController {
  late Rx<Committee> committee;
  late RxMap<String, int> rollCall;

  CommitteeController({required Committee committee}) {
    this.committee = committee.obs;
    rollCall = {for (var val in committee.countries) val: -1}.obs;
  }

  bool get areAllPresent => rollCall.values.toList().every((call) => call == 1);
  bool get areAllAbsent => rollCall.values.toList().every((call) => call == 0);

  void setAllPresent() => rollCall.updateAll((key, value) => 1);
  void setAllAbsent() => rollCall.updateAll((key, value) => 0);
  void setRollCall(String country, int attendance) =>
      rollCall[country] = attendance;
}
