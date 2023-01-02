import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/services/local_storage.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/vote.dart';
import './widgets/past_voters_card.dart';
import './widgets/result_card.dart';
import './widgets/voting_card.dart';
import '../widgets/body.dart';

class VotePage extends StatelessWidget {
  const VotePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<VoteController>()) {
      final bool exists = LocalStorage.loadVote();

      if (!exists) {
        final VoteController controller = VoteController();
        controller.voters =
            Get.find<CommitteeController>().committee.presentAndVotingDelegates;

        Get.put(controller, tag: "vote");
        LocalStorage.saveVote(controller);
      }
    }

    return Body(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: const [
              ResultCard(),
              SizedBox(height: 12),
              PastVotersCard(),
            ],
          ),
          const SizedBox(width: 36),
          const VotingCard(),
        ],
      ),
    );
  }
}
