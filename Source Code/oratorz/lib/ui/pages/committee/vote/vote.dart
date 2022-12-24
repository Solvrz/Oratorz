import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/vote.dart';
import './widgets/past_voters_card.dart';
import './widgets/result_card.dart';
import './widgets/voting_card.dart';
import '../widgets/header.dart';

class VotePage extends StatelessWidget {
  const VotePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VoteController());

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Header(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: const [
                  ResultCard(),
                  SizedBox(height: 12),
                  PastVoterCard(),
                ],
              ),
              const SizedBox(width: 36),
              const VotingCard(),
            ],
          ),
        ],
      ),
    );
  }
}
