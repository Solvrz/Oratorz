import 'package:get/get.dart';

import '/models/committee.dart';
import './vote.dart';
import 'autosave.dart';

class CommitteeController extends GetxController {
  late final Rx<Committee> _committee;
  late final RxInt _tab;
  late RxInt selectedDay;
  bool refetch = false;

  final List<void Function()> _deletions = [];

  CommitteeController({required Committee committee, int tab = 0}) {
    _tab = tab.obs;
    _committee = committee.obs;
    selectedDay = committee.currDay.obs;
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

  void trackController<T extends GetxController>(T controller, {String? tag}) {
    _deletions.add(() => Get.delete<T>(tag: tag));
  }

  Committee get committee => _committee.value;

  void setAgenda(String agenda) {
    _committee.update((committee) {
      if (committee != null) committee.agenda = agenda;
    });

    //FIXME: Update Firebase Data
    // LocalStorage.updateCommittee("committee", committee.toJson());
  }

  void _updateVoteControllers() {
    //FIXME: Update Firebase Data
    // LocalStorage.updateCommittee("rollCall", committee.rollCall);

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

  int get tab => _tab.value;
  set tab(int newTab) => _tab.value = newTab;

  Map<String, dynamic> toJson() => _committee.value.toJson();
}
