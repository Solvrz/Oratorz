import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/tools/controllers/comittee/speech.dart';
import '/ui/widgets/dialog_box.dart';

class SettingsDialog extends StatelessWidget {
  final String tag;

  const SettingsDialog({super.key, required this.tag});

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
                      onSubmitted: (value) {
                        _speechController.subtopic[_speechController.subtopic
                            .keys.first] = _subtopicController.text.trim();

                        context.pop();
                      },
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.grey[600],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: _speechController.subtopic.keys.first,
                      ),
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
                      _TimerButton(
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
                      _TimerButton(
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
                        _TimerButton(
                          value: _speechController.overallDuration.inMinutes,
                          change: (value) {
                            if (_speechController.overallDuration.inMinutes +
                                    value <=
                                60) {
                              _speechController.duration +=
                                  Duration(minutes: value);
                            }
                          },
                          subtitle: "minutes",
                        ),
                        const SizedBox(width: 16),
                        _TimerButton(
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
        TextButton(
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

class _TimerButton extends StatelessWidget {
  final int value;
  final String subtitle;
  final Function(int) change;

  const _TimerButton({
    required this.value,
    required this.subtitle,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: value.toString().padLeft(2, '0'));

    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            width: 140,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    cursorColor: Colors.grey.shade700,
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.transparent,
                      hintText: "00",
                      hintStyle: context.textTheme.headline1!.copyWith(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (text) {
                      if (0 <= int.parse(text) && int.parse(text) < 60) {
                        change(int.parse(text) - value);
                        controller.text = text.padLeft(2, '0');
                      } else {
                        controller.text = value.toString().padLeft(2, '0');
                      }

                      controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: controller.text.length),
                      );
                    },
                    style: context.textTheme.headline1!.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                Column(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: () => change(1),
                        hoverColor: const Color.fromARGB(255, 250, 250, 250),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(Icons.add, size: 18),
                        ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: () => change(-1),
                        hoverColor: const Color.fromARGB(255, 250, 250, 250),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(Icons.remove, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Text(
          subtitle.toUpperCase(),
          style: context.textTheme.bodyText1!.copyWith(
            fontSize: 12,
            color: Colors.grey.shade600,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
