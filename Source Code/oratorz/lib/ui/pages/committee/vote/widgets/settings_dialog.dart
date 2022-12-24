import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/vote.dart';
import '/ui/widgets/dialog_box.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final VoteController _voteController = Get.find<VoteController>();

    return DialogBox(
      heading: "Settings",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Topic",
                style: context.textTheme.headline5,
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: TextField(
                  cursorColor: Colors.black,
                  onChanged: (value) => _voteController.topic.value = value,
                ),
              ),
              const SizedBox(height: 20),
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
                          groupValue: _voteController.majority.value,
                          onChanged: (value) =>
                              _voteController.majority.value = value!,
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
                          groupValue: _voteController.majority.value,
                          onChanged: (value) =>
                              _voteController.majority.value = value!,
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
                          groupValue: _voteController.majority.value,
                          onChanged: (value) =>
                              _voteController.majority.value = value!,
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
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
