import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants/constants.dart';
import '/tools/controllers/comittee/speech.dart';
import '../widgets/stopwatch.dart';

class CustomTab extends StatelessWidget {
  const CustomTab({super.key});

  @override
  Widget build(BuildContext context) {
    final SpeechController _speechController =
        Get.put(SpeechController(), tag: "custom");

    _speechController.hasSubtopic.value = true;
    _speechController.subtopic.value = {"Title": ""};

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Card(
          child: Container(
            width: MediaQuery.of(context).size.width / 5,
            margin: const EdgeInsets.symmetric(
              horizontal: 100,
              vertical: 18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => RichText(
                    text: TextSpan(
                      text: "${_speechController.subtopic.keys.first}: ",
                      style: theme.textTheme.headline2,
                      children: [
                        TextSpan(text: _speechController.subtopic.values.first)
                      ],
                    ),
                  ),
                ),
                const StopwatchWidget(tag: "custom"),
              ],
            ),
          ),
        ),
        Text("Carousel Placeholder", style: theme.textTheme.bodyText1),
      ],
    );
  }
}
