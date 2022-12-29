import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/tools/controllers/comittee/vote.dart';
import '/ui/widgets/dialog_box.dart';

class VoeSettingsDialog extends StatelessWidget {
  const VoeSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final VoteController _voteController =
        Get.find<VoteController>(tag: "motions");

    return DialogBox(
      heading: "Settings",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Majority",
                style: context.textTheme.headline5,
              ),
              Obx(
                () => Column(
                  children: [
                    Row(
                      children: [
                        Radio<int>(
                          value: 0,
                          groupValue: _voteController.majority,
                          onChanged: (value) =>
                              _voteController.majority = value!,
                        ),
                        Text(
                          "Simple Majority (${_voteController.majorityVal(value: 0)})",
                          style: context.textTheme.bodyText1,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio<int>(
                          value: 1,
                          groupValue: _voteController.majority,
                          onChanged: (value) =>
                              _voteController.majority = value!,
                        ),
                        Text(
                          "Two Third Majority (${_voteController.majorityVal(value: 1)})",
                          style: context.textTheme.bodyText1,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio<int>(
                          value: 2,
                          groupValue: _voteController.majority,
                          onChanged: (value) =>
                              _voteController.majority = value!,
                        ),
                        Text(
                          "Consensus Vote (${_voteController.majorityVal(value: 2)})",
                          style: context.textTheme.bodyText1,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Change"),
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
