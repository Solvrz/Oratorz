import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/services/local_storage.dart';
import '/tools/controllers/comittee/vote.dart';
import '/ui/widgets/dialog_box.dart';

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

                      LocalStorage.updateVote("topic", _voteController.topic);

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
              ],
              Text(
                "Majority",
                style: context.textTheme.headline5,
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
                    title: "Two Thirds Majority",
                  ),
                  _Majority(
                    tag: tag,
                    value: 2,
                    title: "Consensus Majority",
                  ),
                ],
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
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
            "$title (${_voteController.majorityVal(value: value)})",
            style: context.textTheme.bodyText1
                ?.copyWith(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
