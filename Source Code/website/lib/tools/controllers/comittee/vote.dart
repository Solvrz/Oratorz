import 'package:get/get.dart';

import '/tools/controllers/comittee/committee.dart';

class VoteController extends GetxController {
  VoteController() {
    voters =
        Get.find<CommitteeController>().committee.presentAndVotingDelegates;
  }

  final RxString _topic = "Your Topic".obs;
  final RxInt _majority = 0.obs;

  final RxList<String> _voters = <String>[].obs;
  final RxList<Map<String, bool>> _pastVoters = <Map<String, bool>>[].obs;

  final RxList<Map<String, dynamic>> _pastVotes = <Map<String, dynamic>>[].obs;

  List<Map<String, dynamic>> get pastVotes => _pastVotes;
  set pastVotes(List<Map<String, dynamic>> votes) => _pastVotes.value = votes;

  String get topic => _topic.value;
  set topic(String newTopic) => _topic.value = newTopic;

  int get majority => _majority.value;
  set majority(int newMajority) => _majority.value = newMajority;

  List<String> get voters => _voters;
  set voters(List<String> newVoters) => _voters.value = newVoters;

  List<Map<String, bool>> get pastVoters => _pastVoters;
  set pastVoters(List<Map<String, bool>> newVoters) =>
      _pastVoters.value = newVoters;

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

  bool voteVal({required String delegate, required bool invert}) {
    if (hasVoted(delegate)) {
      final bool _result = _pastVoters
          .firstWhere(
            (_voter) => _voter.keys.first == delegate,
          )
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
        return ((2 / 3) * totalVoters).ceil();
      case 2:
        return totalVoters;

      default:
        return 0;
    }
  }

  bool hasVoted(String delegate) {
    for (final Map<String, bool> voter in _pastVoters) {
      if (voter.keys.first == delegate) {
        return true;
      }
    }

    return false;
  }

  void reset() {
    _voters.value =
        Get.find<CommitteeController>().committee.presentAndVotingDelegates;
    _pastVoters.value = [];
  }

  void removeVoter(String delegate) {
    _voters.remove(delegate);
  }

  void vote({required bool vote, String? voter}) {
    final String _voter = voter ?? _voters[0];

    if (!hasVoted(_voter)) {
      _pastVoters.add({_voter: vote});
      _voters.remove(_voter);
    } else {
      _pastVoters.removeWhere((_vote) => _vote.keys.first == _voter);
      _pastVoters.add({_voter: vote});
    }
  }

  void addVoteData(Map<String, dynamic> data) {
    _pastVotes.add(data);
    reset();
  }

  Map<String, dynamic> toJson() => {
        "topic": _topic.value,
        "majority": _majority.value,
        "voters": _voters,
        "past": _pastVoters,
      };
}
