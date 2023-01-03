import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/scorecard.dart';
import '/ui/widgets/rounded_button.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final ScorecardController _scorecardController =
        Get.find<ScorecardController>();

    return Obx(
      () => Row(
        children: [
          Text(
            "Scorecard",
            style: Theme.of(context).textTheme.headline5,
          ),
          const Spacer(),
          if (_scorecardController.mode.value == 1) ...[
            RoundedButton(
              border: true,
              onPressed: () => _scorecardController.addParameter(
                "New Parameter",
                10,
              ),
              child: const Text("Add Parameter"),
            ),
            const SizedBox(width: 10),
          ],
          RoundedButton(
            onPressed: _scorecardController.toggleMode,
            child: Text(
              _scorecardController.mode.value == 0 ? "Edit Parameters" : "Done",
            ),
          ),
        ],
      ),
    );
  }
}
