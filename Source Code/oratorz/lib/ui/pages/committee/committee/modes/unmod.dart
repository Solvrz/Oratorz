import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '../widgets/add_speaker.dart';
import '../widgets/past_speakers.dart';
import '../widgets/speakers_info.dart';
import '../widgets/stopwatch.dart';

class UnmodTab extends StatelessWidget {
  const UnmodTab({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SpeechController(), tag: "unmod");

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.25,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: StopwatchWidget(
                          onTimeEnd: () {},
                          tag: "unmod",
                          canYield: false,
                        ),
                      ),
                      const SizedBox(width: 48),
                      const SpeakersInfoWidget(tag: "unmod"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const PastSpeakersCard(tag: "unmod"),
            ],
          ),
        ),
        const SizedBox(width: 36),
        const AddSpeakerCard(tag: "unmod"),
      ],
    );
  }
}
