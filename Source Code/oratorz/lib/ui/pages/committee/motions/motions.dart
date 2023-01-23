import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/services/local_storage.dart';
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
    if (!Get.isRegistered<MotionsController>()) {
      final bool exists = LocalStorage.loadMotions();

      if (!exists) {
        Get.put<MotionsController>(MotionsController());
        LocalStorage.saveMotions();
      }
    }

    final MotionsController controller = Get.find<MotionsController>();

    return Body(
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
    );
  }
}
