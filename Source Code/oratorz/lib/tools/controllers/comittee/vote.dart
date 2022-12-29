import 'package:get/get.dart';

import './committee.dart';

class VoteController extends GetxController {
  final RxString _topic = "Your Topic".obs;
  final RxInt _majority = 0.obs;

  final RxList<String> _voters = <String>[].obs;
  final RxList<Map<String, bool>> _pastVoters = <Map<String, bool>>[].obs;

  String get topic => _topic.value;
  set topic(String newTopic) => _topic.value = newTopic;

  int get majority => _majority.value;
  set majority(int newMajority) => _majority.value = newMajority;

  List<String> get voters => _voters;
  set voters(List<String> newVoters) => _voters.value = newVoters;

  List<Map<String, bool>> get pastVoters => _pastVoters;

  String get currentVoter => _voters.isNotEmpty ? _voters[0] : "";
  int get totalVoters => _voters.length + _pastVoters.length;

  int get inFavor {
    int _inFavor = 0;

    _pastVoters.forEach((voter) {
      if (voter.values.first) _inFavor++;
    });

    return _inFavor;
  }

  int get against {
    int _against = 0;

    _pastVoters.forEach((voter) {
      if (!voter.values.first) _against++;
    });

    return _against;
  }

  bool voteVal(String delegate, {bool invert = false}) {
    if (hasVoted(delegate)) {
      final bool _result = _pastVoters
          .where(
            (_voter) => _voter.keys.first == delegate,
          )
          .first
          .values
          .first;

      return invert ? !_result : _result;
    } else {
      return true;
    }
  }

  int majorityVal({int? value}) {
    switch (value ?? _majority.value) {
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

    _pastVoters.forEach((_voter) {
      _voted = _voter.keys.first == delegate;
    });

    return _voted;
  }

  void reset() {
    _voters.value =
        Get.find<CommitteeController>().committee.presentAndVotingDelegates;
    _pastVoters.value = [];
  }

  void removeVoter(String delegate) => _voters.remove(delegate);

  void vote({
    required bool vote,
    bool remove = true,
    String? voter,
  }) {
    final String _voter = voter ?? _voters[0];

    if (!hasVoted(_voter)) {
      _pastVoters.add({voter ?? _voters[0]: vote});
      if (remove) _voters.removeAt(0);
    } else {
      _pastVoters.removeWhere((_vote) => _vote.keys.first == _voter);
      _pastVoters.add({voter ?? _voters[0]: vote});
    }
  }
}
