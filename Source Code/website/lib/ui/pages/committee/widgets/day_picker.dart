import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/committee.dart';

class DayPicker extends StatelessWidget {
  const DayPicker({super.key});

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
          },
          child: const Icon(Icons.arrow_left_rounded, color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            "Day ${controller.selectedDay + 1}",
            style: context.textTheme.titleLarge!.copyWith(color: Colors.white),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(50),
          hoverColor: Colors.white10,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            controller.selectedDay += 1;

            if (controller.selectedDay.value >
                controller.committee.days.length - 1) {
              controller.selectedDay.value = 0;
            }
          },
          child: const Icon(Icons.arrow_right_rounded, color: Colors.white),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(50),
          hoverColor: Colors.white10,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () =>
              controller.selectedDay.value = controller.committee.currDay,
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
