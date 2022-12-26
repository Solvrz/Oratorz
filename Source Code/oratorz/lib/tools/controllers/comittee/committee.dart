import 'package:get/get.dart';

import '/config/constants/committee.dart';
import '/models/committee.dart';
import '../../../services/local_storage.dart';

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

  void setAgenda(String agenda) {
    _committee.update((val) {
      if (val != null) val.agenda = agenda;
    });

    LocalStorage.updateCommittee("committee", committee.toJson());
  }

  Map<String, int> get rollCall => _rollCall;

  set rollCall(Map<String, int> newRollCall) => _rollCall.value = newRollCall;

  bool? get areAllPresent => rollCall.values.toList().every(
        (call) => call >= 1,
      );
  bool? get areAllAbsent => rollCall.values.toList().every(
        (call) => call == 0,
      );

  void _saveRollCall() => LocalStorage.updateCommittee("rollCall", _rollCall);

  void setAllPresent() {
    _rollCall.updateAll((key, value) => 1);
    _saveRollCall();
  }

  void setAllAbsent() {
    _rollCall.updateAll((key, value) => 0);
    _saveRollCall();
  }

  void setRollCall(String delegate, int attendance) {
    _rollCall[delegate] = attendance;
    _saveRollCall();
  }

  int get tab => _tab.value;
  set tab(int newTab) => _tab.value = newTab;

  dynamic get currentTab => COMMITTEE_TABS[tab]["tab"];
  Map<String, dynamic> get currentTabDetails => COMMITTEE_TABS[tab];

  Map<String, dynamic> toJson() {
    return {
      "committee": committee.toJson(),
      "rollCall": rollCall,
    };
  }
}
