import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/motions.dart';
import '/ui/pages/committee/widgets/body.dart';
import './widgets/add_motion_card.dart';
import './widgets/current_motions_card.dart';
import './widgets/debate_card.dart';
import './widgets/vote_card.dart';
import 'widgets/past_motions_card.dart';

class MotionsPage extends StatelessWidget {
  const MotionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<MotionsController>()) {
      Get.put<MotionsController>(MotionsController());
    }

    final MotionsController controller = Get.find<MotionsController>();
    final CommitteeController committeeController =
        Get.find<CommitteeController>();

    return Body(
      child: Obx(
        () => committeeController.readOnly
            ? const Row(children: [PastMotionsCard()])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: context.width / 3,
                    child: const Column(
                      children: [
                        CurrentMotionCard(),
                        SizedBox(height: 12),
                        PastMotionsCard(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 36),
                  Obx(() {
                    if (controller.mode == 0) {
                      return const AddMotionCard();
                    } else if (controller.mode == 1) {
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
