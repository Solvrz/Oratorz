import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/services/cloud_storage.dart';
import '/tools/controllers/comittee/autosave.dart';
import '/tools/controllers/comittee/committee.dart';

class DayPicker extends StatelessWidget {
  const DayPicker({super.key});

  void fetchNewScorecard() {
    final AutoSaveController saveController = Get.find<AutoSaveController>();
    final CommitteeController committeeController =
        Get.find<CommitteeController>();

    if (saveController.timers["scorecard"] != null) {
      saveController.timers["scorecard"]?.cancel();
      CloudStorage.saveScorecard(
        data: committeeController.committee.scorecard!.toJson(),
      );
    }

    committeeController.refetch = true;
  }

  @override
  Widget build(BuildContext context) {
    final CommitteeController controller = Get.find<CommitteeController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(50),
          hoverColor: Colors.white10,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.selectedDay -= 1;

            if (controller.selectedDay.value < 0) {
              controller.selectedDay.value =
                  controller.committee.days.length - 1;
            }

            fetchNewScorecard();
          },
          child: const Icon(Icons.arrow_left_rounded, color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Obx(
            () {
              return Text(
                "Day ${controller.selectedDay.value + 1}",
                style:
                    context.textTheme.titleLarge!.copyWith(color: Colors.white),
              );
            },
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(50),
          hoverColor: Colors.white10,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.selectedDay.value += 1;

            if (controller.selectedDay.value >
                controller.committee.days.length - 1) {
              controller.selectedDay.value = 0;
            }

            fetchNewScorecard();
          },
          child: const Icon(Icons.arrow_right_rounded, color: Colors.white),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(50),
          hoverColor: Colors.white10,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.selectedDay.value = controller.committee.currDay;
            fetchNewScorecard();
          },
          child: const Padding(
            padding: EdgeInsets.all(2),
            child: Icon(
              Icons.restart_alt_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
