import 'package:flutter/material.dart' hide Table;
import 'package:get/get.dart';

import '/services/cloud_storage.dart';
import '/tools/controllers/comittee/autosave.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/scorecard.dart';
import '/ui/pages/committee/widgets/body.dart';
import '/ui/widgets/rounded_button.dart';
import './widgets/table.dart';

class ScorecardPage extends StatelessWidget {
  const ScorecardPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ScorecardController>()) {
      Get.put<ScorecardController>(ScorecardController());
    }

    final ScorecardController controller = Get.find<ScorecardController>();
    final CommitteeController committeeController =
        Get.find<CommitteeController>();

    return Body(
      footer: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 350,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Search Delegate",
                  fillColor: Colors.white,
                ),
                onChanged: (value) => controller.query.value = value,
              ),
            ),
            const Spacer(),
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade700),
                ),
                child: DropdownButton(
                  value: committeeController.selectedDay.value,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  underline: const SizedBox(),
                  focusColor: Colors.transparent,
                  iconEnabledColor: Colors.grey.shade400,
                  items: List.generate(
                    committeeController.committee.days.length,
                    (index) => DropdownMenuItem(
                      value: index,
                      child: Text("Day ${index + 1}"),
                    ),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      final AutoSaveController saveController =
                          Get.find<AutoSaveController>();

                      if (saveController.timers["scorecard"] != null) {
                        saveController.timers["scorecard"]?.cancel();
                        CloudStorage.saveScorecard(
                          data:
                              committeeController.committee.scorecard!.toJson(),
                        );
                      }

                      committeeController.refetch = true;
                      committeeController.selectedDay.value = value;
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Obx(
              () => Row(
                children: [
                  if (controller.mode.value == 1) ...[
                    RoundedButton(
                      style: RoundedButtonStyle.border,
                      onPressed: () => controller.addParameter(
                        "New",
                        10,
                      ),
                      child: const Text("Add Parameter"),
                    ),
                    const SizedBox(width: 10),
                  ],
                  RoundedButton(
                    onPressed: controller.toggleMode,
                    child: Text(
                      controller.mode.value == 0 ? "Edit Parameters" : "Done",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      child: Obx(
        () {
          //FIXME: Find a better way to update this Obx

          // NOTE: Do not remove the variable print
          // ignore: unnecessary_statements
          print(committeeController.selectedDay);

          return FutureBuilder(
            future: CloudStorage.fetchDayData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(
                      color: Color(0xff2a313b),
                    ),
                  ),
                );
              }

              // NOTE: Do not add const
              // ignore: prefer_const_constructors
              return Table();
            },
          );
        },
      ),
    );
  }
}
