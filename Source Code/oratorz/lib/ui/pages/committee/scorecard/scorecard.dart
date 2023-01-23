import 'package:flutter/material.dart' hide Table;
import 'package:get/get.dart';

import '/services/local_storage.dart';
import '/tools/controllers/comittee/scorecard.dart';
import '/ui/widgets/rounded_button.dart';
import '../widgets/body.dart';
import 'widgets/scoretable.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(
            () => Row(
              children: [
                Text(
                  "Scorecard",
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Spacer(),
                if (controller.mode.value == 1) ...[
                  RoundedButton(
                    border: true,
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
          const SizedBox(height: 24),
          const Expanded(child: ScoreTable()),
        ],
      ),
    );
  }
}
