import 'package:flutter/material.dart' hide Table;
import 'package:get/get.dart';

import './widgets/table.dart';
import '/services/local_storage.dart';
import '/tools/controllers/comittee/scorecard.dart';
import '/ui/pages/committee/widgets/body.dart';
import '/ui/widgets/rounded_button.dart';

class ScorecardPage extends StatelessWidget {
  const ScorecardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScorecardController controller;

    if (!Get.isRegistered<ScorecardController>()) {
      final bool exists = LocalStorage.loadScore();

      if (!exists) {
        Get.put<ScorecardController>(ScorecardController());
        LocalStorage.saveScore();
      }
    }

    controller = Get.find<ScorecardController>();

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
      child: const Table(),
    );
  }
}
