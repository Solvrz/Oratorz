import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/vote.dart';
import '/ui/pages/committee/widgets/body.dart';
import './widgets/past_votes_card.dart';
import './widgets/result_card.dart';
import './widgets/voting_card.dart';

class VotePage extends StatelessWidget {
  const VotePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<VoteController>()) {
      Get.put<VoteController>(VoteController(), tag: "vote");
    }

    return const Body(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              ResultCard(),
              SizedBox(height: 12),
              Expanded(child: PastVotesCard()),
            ],
          ),
          SizedBox(width: 36),
          VotingCard(),
        ],
      ),
    );
  }
}
