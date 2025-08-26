import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/vote.dart';
import '/ui/pages/committee/widgets/body.dart';
import '../../../../tools/controllers/comittee/committee.dart';
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

    final CommitteeController controller = Get.find<CommitteeController>();

    return Body(
      child: Obx(
        () => controller.readOnly
            ? const Row(children: [PastVotesCard()])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: context.width / 4,
                    child: const Column(
                      children: [
                        ResultCard(),
                        SizedBox(height: 12),
                        PastVotesCard(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 36),
                  const VotingCard(),
                ],
              ),
      ),
    );
  }
}
