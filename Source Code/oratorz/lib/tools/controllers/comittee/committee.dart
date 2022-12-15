import 'package:get/get.dart';

import '/config/constants/committee.dart';
import '/models/committee.dart';

class CommitteeController extends GetxController {
  late RxMap<String, int> rollCall;
  late Rx<Committee> committee;
  late RxInt tab;

  CommitteeController({required Committee committee, int tabVal = 0}) {
    this.committee = committee.obs;
    rollCall = {for (String delegate in committee.delegates) delegate: -1}.obs;
    tab = tabVal.obs;
  }

  bool get areAllPresent => rollCall.values.toList().every((call) => call == 1);
  bool get areAllAbsent => rollCall.values.toList().every((call) => call == 0);

  void setAllPresent() => rollCall.updateAll((key, value) => 1);
  void setAllAbsent() => rollCall.updateAll((key, value) => 0);
  void setRollCall(String delegate, int attendance) =>
      rollCall[delegate] = attendance;

  int get tabVal => tab.value;
  set tabVal(int newTab) => tab.value = newTab;

  Map<String, dynamic> currentTab() => COMMITTEE_TABS[tab.value];
}
