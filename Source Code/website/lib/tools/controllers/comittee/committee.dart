import 'package:get/get.dart';

import '/models/committee.dart';
import './vote.dart';
import 'autosave.dart';

class CommitteeController extends GetxController {
  late final Rx<Committee> _committee;
  late final RxInt _tab;
  late RxInt selectedDay;

  Map<int, Map<String, dynamic>> data = {};

  final List<void Function()> _deletions = [];

  CommitteeController({required Committee committee, int tab = 0}) {
    _tab = tab.obs;
    _committee = committee.obs;

    if (committee.currDay == -1 && committee.lastDay != -1) {
      selectedDay = committee.lastDay.obs;
    } else {
      selectedDay = committee.currDay.obs;
    }

    for (int i = 0; i <= selectedDay.value; i++) {
      data[i] = <String, dynamic>{};
    }
  }

  @override
  void onInit() {
    super.onInit();

    final AutoSaveController controller = AutoSaveController();
    Get.put<AutoSaveController>(controller);

    trackController(controller);
  }

  @override
  void onClose() {
    _deletions.forEach((del) => del());
    _deletions.clear();

    super.onClose();
  }

  Committee get committee => _committee.value;

  int get tab => _tab.value;
  set tab(int newTab) => _tab.value = newTab;

  bool get readOnly => selectedDay.value != committee.currDay;

  void trackController<T extends GetxController>(T controller, {String? tag}) {
    _deletions.add(() => Get.delete<T>(tag: tag));
  }

  void setAgenda(String agenda) => _committee.update((committee) {
        if (committee != null) committee.agenda = agenda;
      });

  void _updateVoteControllers() {
    if (Get.isRegistered<VoteController>(tag: "vote")) {
      Get.find<VoteController>(tag: "vote").voters =
          _committee.value.presentAndVotingDelegates;
    }

    if (Get.isRegistered<VoteController>(tag: "motions")) {
      Get.find<VoteController>(tag: "motions").voters =
          _committee.value.presentAndVotingDelegates;
    }
  }

  void setAllPresentAndVoting() {
    _committee.update((committee) {
      if (committee != null) {
        committee.rollCall.updateAll((_, __) => RollCall.presentAndVoting);
      }
    });

    _updateVoteControllers();
  }

  void setAllPresent() {
    _committee.update((committee) {
      if (committee != null) {
        committee.rollCall.updateAll((_, __) => RollCall.present);
      }
    });

    _updateVoteControllers();
  }

  void setAllAbsent() {
    _committee.update((committee) {
      if (committee != null) {
        committee.rollCall.updateAll((_, __) => RollCall.absent);
      }
    });

    _updateVoteControllers();
  }

  void setRollCall(String delegate, int attendance) {
    _committee.update((committee) {
      if (committee != null) committee.rollCall[delegate] = attendance;
    });

    _updateVoteControllers();
  }

  void nextDay() {
    selectedDay.value += 1;
    selectedDay.value %= committee.lastDay + 1;
    update();
  }

  void prevDay() {
    selectedDay.value -= 1;
    selectedDay.value %= committee.lastDay + 1;
    update();
  }

  void resetDay() {
    selectedDay.value = committee.lastDay;
    update();
  }

  bool hasData(String tag) => data[selectedDay.value]!.containsKey(tag);

  void addData(String tag, Map<String, dynamic> data_) =>
      data[selectedDay.value]![tag] = data_;

  Map<String, dynamic> fetchData(String tag) => data[selectedDay.value]![tag];

  Map<String, dynamic> toJson() => _committee.value.toJson();
}
