import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants/constants.dart';
import '/tools/controllers/comittee/speech.dart';
import '../widgets/stopwatch.dart';

class PrayerTab extends StatelessWidget {
  const PrayerTab({super.key});

  @override
  Widget build(BuildContext context) {
    final SpeechController _speechController =
        Get.put(SpeechController(), tag: "prayer");

    _speechController.subtopic.value = {"Cause": ""};

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
            child: const StopwatchWidget(tag: "prayer"),
          ),
        ),
        Text("Carousel Placeholder", style: theme.textTheme.bodyText1),
      ],
    );
  }
}
