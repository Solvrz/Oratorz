import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/tools/controllers/comittee/speech.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';
import '../timer_button.dart';

class SpeechSettingsDialog extends StatelessWidget {
  final String tag;

  const SpeechSettingsDialog({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final SpeechController _speechController =
        Get.find<SpeechController>(tag: tag);
    final TextEditingController _subtopicController =
        TextEditingController(text: _speechController.subtopic.values.first);

    return DialogBox(
      heading: "Settings",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_speechController.hasSubtopic) ...[
                  Text(
                    _speechController.subtopic.keys.first,
                    style: context.textTheme.headline5,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: TextField(
                      autofocus: true,
                      controller: _subtopicController,
                      decoration: InputDecoration(
                        hintText: _speechController.subtopic.keys.first,
                        prefixIcon: const Icon(Icons.edit_note),
                      ),
                      onSubmitted: (value) {
                        _speechController.subtopic[_speechController.subtopic
                            .keys.first] = _subtopicController.text.trim();

                        context.pop();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Text(
                  "Speaker Time",
                  style: context.textTheme.headline5,
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TimerButton(
                        value: _speechController.duration.inMinutes,
                        change: (value) {
                          if (_speechController.duration.inMinutes + value <=
                              60) {
                            _speechController.duration +=
                                Duration(minutes: value);
                          }
                        },
                        subtitle: "minutes",
                      ),
                      const SizedBox(width: 16),
                      TimerButton(
                        value: _speechController.duration.inSeconds -
                            _speechController.duration.inMinutes * 60,
                        change: (value) => _speechController.duration +=
                            Duration(seconds: value),
                        subtitle: "seconds",
                      ),
                    ],
                  ),
                ),
                if (_speechController.hasOverallDuration) ...[
                  const SizedBox(height: 20),
                  Text(
                    "Caucus Time",
                    style: context.textTheme.headline5,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TimerButton(
                          value: _speechController.overallDuration.inMinutes,
                          change: (value) {
                            if (_speechController.overallDuration.inMinutes +
                                    value <=
                                60) {
                              _speechController.overallDuration +=
                                  Duration(minutes: value);
                            }
                          },
                          subtitle: "minutes",
                        ),
                        const SizedBox(width: 16),
                        TimerButton(
                          value: _speechController.overallDuration.inSeconds -
                              _speechController.overallDuration.inMinutes * 60,
                          change: (value) => _speechController.overallDuration =
                              _speechController.overallDuration +
                                  Duration(seconds: value),
                          subtitle: "seconds",
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
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
            _speechController.subtopic[_speechController.subtopic.keys.first] =
                _subtopicController.text.trim();

            context.pop();
          },
        ),
      ],
    );
  }
}
