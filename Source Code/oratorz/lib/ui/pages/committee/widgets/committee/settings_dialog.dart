import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '/ui/widgets/dialog_box.dart';

class SettingsDialog extends StatelessWidget {
  final SpeechController controller;

  const SettingsDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DialogBox(
      heading: "Settings",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        value: controller.duration.value.inMinutes,
                        change: (value) {
                          if (controller.duration.value.inMinutes + value <=
                              60) {
                            controller.duration.value +=
                                Duration(minutes: value);
                          }
                        },
                        subtitle: "minutes",
                      ),
                      const SizedBox(width: 16),
                      TimerButton(
                        value: controller.duration.value.inSeconds -
                            controller.duration.value.inMinutes * 60,
                        change: (value) => controller.duration.value +=
                            Duration(seconds: value),
                        subtitle: "seconds",
                      ),
                    ],
                  ),
                ),
                if (controller.overallDuration != null) ...[
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
                          value: controller.overallDuration!.value.inMinutes,
                          change: (value) {
                            if (controller.overallDuration!.value.inMinutes +
                                    value <=
                                60) {
                              controller.duration.value +=
                                  Duration(minutes: value);
                            }
                          },
                          subtitle: "minutes",
                        ),
                        const SizedBox(width: 16),
                        TimerButton(
                          value: controller.overallDuration!.value.inSeconds -
                              controller.overallDuration!.value.inMinutes * 60,
                          change: (value) => controller.overallDuration!
                              .value += Duration(seconds: value),
                          subtitle: "seconds",
                        ),
                      ],
                    ),
                  ),
                ],
                if (controller.hasSubtopic) ...[
                  const SizedBox(height: 20),
                  Text(
                    controller.subtopic.keys.first,
                    style: context.textTheme.headline5,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: TextField(
                      cursorColor: Colors.black,
                      onChanged: (value) => controller
                          .subtopic[controller.subtopic.keys.first] = value,
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
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class TimerButton extends StatelessWidget {
  final int value;
  final String subtitle;
  final Function(int) change;

  const TimerButton({
    super.key,
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
