import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/tools/controllers/comittee/vote.dart';
import '/ui/widgets/dialog_box.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final VoteController _voteController = Get.find<VoteController>();
    final TextEditingController _topicController =
        TextEditingController(text: _voteController.topic);

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
                  autofocus: true,
                  controller: _topicController,
                  onSubmitted: (value) {
                    _voteController.topic = _topicController.text.trim();

                    context.pop();
                  },
                  keyboardType: TextInputType.name,
                  cursorColor: Colors.grey[600],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: _voteController.topic,
                  ),
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
          onPressed: () {
            // TODO: Will Pop Scope on Dialogs
            _voteController.topic = _topicController.text.trim();

            context.pop();
          },
        ),
      ],
    );
  }
}
