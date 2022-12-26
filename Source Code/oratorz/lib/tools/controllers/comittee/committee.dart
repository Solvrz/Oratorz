import 'package:get/get.dart';

import '/config/constants/committee.dart';
import '/models/committee.dart';

class CommitteeController extends GetxController {
  late final Rx<Committee> _committee;
  late final RxMap<String, int> _rollCall;

  late RxInt _tab;

  CommitteeController({required Committee committee, int tab = 0}) {
    _tab = tab.obs;
    _committee = committee.obs;
    _rollCall = {for (String delegate in committee.delegates) delegate: -1}.obs;
  }

  Committee get committee => _committee.value;
  Map<String, int> get rollCall => _rollCall;

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
  set tab(int newTab) => _tab.value = newTab;

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
