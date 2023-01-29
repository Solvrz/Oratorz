import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/services/local_storage.dart';
import '/tools/controllers/comittee/vote.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';

class VoteSettingsDialog extends StatelessWidget {
  final String tag;
  final bool title;

  const VoteSettingsDialog({
    super.key,
    required this.tag,
    this.title = true,
  });

  @override
  Widget build(BuildContext context) {
    final VoteController _voteController = Get.find<VoteController>(tag: tag);
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
              if (title) ...[
                Text(
                  "Topic",
                  style: context.textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: TextField(
                    autofocus: true,
                    controller: _topicController,
                    decoration: InputDecoration(
                      hintText: _voteController.topic,
                      prefixIcon: const Icon(Icons.edit_note),
                    ),
                    onSubmitted: (value) {
                      _voteController.topic = _topicController.text.trim();

                      LocalStorage.updateVote("topic", _voteController.topic);

                      context.pop();
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Text(
                "Majority",
                style: context.textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  _Majority(
                    tag: tag,
                    value: 0,
                    title: "Simple Majority",
                  ),
                  _Majority(
                    tag: tag,
                    value: 1,
                    title: "Special Majority",
                  ),
                  _Majority(
                    tag: tag,
                    value: 2,
                    title: "Unanimous Vote",
                  ),
                ],
              ),
            ],
          )
        ],
      ),
      actions: [
        RoundedButton(
          border: true,
          color: Colors.amber.shade400,
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: const Text("Change"),
          onPressed: () {
            _voteController.topic = _topicController.text.trim();
            LocalStorage.updateVote("topic", _voteController.topic);

            context.pop();
          },
        ),
      ],
    );
  }
}

class _Majority extends StatelessWidget {
  final String tag;
  final int value;
  final String title;

  const _Majority({
    required this.tag,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final VoteController _voteController = Get.find<VoteController>(tag: tag);

    return Obx(
      () => Row(
        children: [
          Radio<int>(
            value: value,
            groupValue: _voteController.majority,
            onChanged: (value) {
              _voteController.majority = value!;

              LocalStorage.updateVote("majority", value);
            },
          ),
          Text(
            "$title (${_voteController.majorityVal(value: value)}/${_voteController.totalVoters})",
            style: context.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
