import 'package:get/get.dart';

import './committee.dart';

class VoteController extends GetxController {
  final RxString _topic = "Your Topic".obs;
  final RxInt _majority = 0.obs;

  RxList<String> voters = <String>[].obs;
  RxList<Map<String, bool>> pastVoters = <Map<String, bool>>[].obs;

  String get topic => _topic.value;
  set topic(String newTopic) => _topic.value = newTopic;

  int get majority => _majority.value;
  set majority(int newMajority) => _majority.value = newMajority;

  String get currentVoter => voters.isNotEmpty ? voters[0] : "";
  int get totalVoters => voters.length + pastVoters.length;

  int get inFavor {
    int _inFavor = 0;

    pastVoters.forEach((voter) {
      if (voter.values.first) _inFavor++;
    });

    return _inFavor;
  }

  int get against {
    int _against = 0;

    pastVoters.forEach((voter) {
      if (!voter.values.first) _against++;
    });

    return _against;
  }

  int majorityVal({int? value}) {
    switch (value ?? majority) {
      case 0:
        return (totalVoters / 2 + (totalVoters > 0 ? 1 : 0)).floor();
      case 1:
        return (((2 / 3) * totalVoters) + (totalVoters > 0 ? 1 : 0)).floor();
      case 2:
        return totalVoters;

      default:
        return 0;
    }
  }

  bool hasVoted(String delegate) {
    bool _voted = false;

    pastVoters.forEach((_voter) {
      _voted = _voter.keys.first == delegate;
    });

    return _voted;
  }

  void reset() {
    voters.value =
        Get.find<CommitteeController>().committee.presentAndVotingDelegates;
    pastVoters.value = [];
  }

  void removeVoter(String delegate) => voters.remove(delegate);

  void nextVoter({required bool vote}) {
    pastVoters.add({voters[0]: vote});
    voters.removeAt(0);
  }
}
