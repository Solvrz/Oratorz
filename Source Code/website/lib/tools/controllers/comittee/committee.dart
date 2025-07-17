import 'dart:async';

import 'package:get/get.dart';

import '/models/committee.dart';
import './vote.dart';
import 'scorecard.dart';

class CommitteeController extends GetxController {
  late final Rx<Committee> _committee;
  late final RxInt _tab;
  static const Duration DELAY = Duration(seconds: 20);
  Timer? _timer;
  RxBool saving = false.obs;

  CommitteeController({required Committee committee, int tab = 0}) {
    if (committee.rollCall.isEmpty) {
      committee.initRollCall();
    }

    _tab = tab.obs;
    _committee = committee.obs;
  }

  Committee get committee => _committee.value;

  void resetTimer() {
    _timer?.cancel();
    _timer = Timer(DELAY, save);
  }

  void save() {
    print("AUTOSAVE");

    if (Get.isRegistered<ScorecardController>()) {
      Get.find<ScorecardController>().syncToFirebase();
    }
  }

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
