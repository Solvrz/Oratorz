import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/motions.dart';
import './widgets/add_motion_card.dart';
import './widgets/current_motions_card.dart';
import './widgets/debate_card.dart';
import './widgets/future_motions_card.dart';
import './widgets/vote_card.dart';
import '../widgets/body.dart';

class MotionsPage extends StatelessWidget {
  const MotionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MotionsController _motionsController = Get.put(MotionsController());

    return Body(
      child: Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: const [
                CurrentMotionCard(),
                SizedBox(height: 12),
                FutureMotionsCard(),
              ],
            ),
            const SizedBox(width: 36),
            Obx(() {
              if (_motionsController.mode == 0) {
                return const AddMotionCard();
              } else if (_motionsController.mode == 1) {
                return const DebateCard();
              } else {
                return const VoteCard();
              }
            }),
          ],
        ),
      ),
    );
  }
}
