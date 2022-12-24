import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '../widgets/add_speaker_card.dart';
import '../widgets/speakers_info_card.dart';
import '../widgets/stopwatch.dart';

class SingleTab extends StatelessWidget {
  const SingleTab({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SpeechController(), tag: "single");

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: context.width / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Container(
                  height: context.height / 2.25,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Center(child: StopwatchWidget(tag: "single")),
                      SizedBox(width: 48),
                      SpeakersInfoWidget(tag: "single"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Text(
                  "Carousel Placeholder",
                  style: context.textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 36),
        const AddSpeakerCard(tag: "single"),
      ],
    );
  }
}
