import 'package:get/get.dart';

import '/models/committee.dart';
import '../../../config/constants/committee.dart';

class CommitteeController extends GetxController {
  late RxMap<String, int> rollCall;
  late Rx<Committee> committee;
  late RxInt tab;

  CommitteeController({required Committee committee, int tabVal = 0}) {
    rollCall = {for (String country in committee.countries) country: -1}.obs;
    this.committee = committee.obs;
    tab = tabVal.obs;
  }

  // Roll Call Section
  bool get areAllPresent => rollCall.values.toList().every((call) => call == 1);
  bool get areAllAbsent => rollCall.values.toList().every((call) => call == 0);

  void setAllPresent() => rollCall.updateAll((key, value) => 1);
  void setAllAbsent() => rollCall.updateAll((key, value) => 0);
  void setRollCall(String country, int attendance) =>
      rollCall[country] = attendance;

  // Tab Section
  int get tabVal => tab.value;
  set tabVal(int newTab) => tab.value = newTab;

  Map<String, dynamic> currentTab() => COMMITTEE_TABS[tab.value];
}
