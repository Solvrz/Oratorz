import 'package:get/get.dart';

import '/config/constants/committee.dart';
import '/models/committee.dart';

class CommitteeController extends GetxController {
  late Rx<Committee> _committee;
  late RxMap<String, int> rollCall;
  late RxInt _tab;

  CommitteeController({required Committee committee, int tab = 0}) {
    _tab = tab.obs;
    _committee = committee.obs;
    rollCall = {for (String delegate in committee.delegates) delegate: -1}.obs;
  }

  Committee get committee => _committee.value;

  bool? get areAllPresent => rollCall.values.toList().every(
        (call) => call >= 1,
      );
  bool? get areAllAbsent => rollCall.values.toList().every(
        (call) => call == 0,
      );

  void setAllPresent() => rollCall.updateAll((key, value) => 1);
  void setAllAbsent() => rollCall.updateAll((key, value) => 0);
  void setRollCall(String delegate, int attendance) =>
      rollCall[delegate] = attendance;

  int get tab => _tab.value;
  set tab(int newTab) => tab = newTab;

  dynamic get currentTab => COMMITTEE_TABS[tab]["tab"];
  Map<String, dynamic> get currentTabDetails => COMMITTEE_TABS[tab];

  Map<String, dynamic> toJson() {
    return {
      "committee": committee.toJson(),
      "rollCall": rollCall,
      "tab": tab,
    };
  }
}
