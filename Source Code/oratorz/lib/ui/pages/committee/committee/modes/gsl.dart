import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '../widgets/add_speaker_card.dart';
import '../widgets/past_speakers_card.dart';
import '../widgets/speakers_info_card.dart';
import '../widgets/stopwatch.dart';

class GSLTab extends StatelessWidget {
  const GSLTab({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SpeechController(), tag: "gsl");

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
                      Center(
                        child: StopwatchWidget(
                          tag: "gsl",
                          canYield: true,
                        ),
                      ),
                      SizedBox(width: 48),
                      SpeakersInfoWidget(tag: "gsl"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const PastSpeakersCard(tag: "gsl"),
            ],
          ),
        ),
        const SizedBox(width: 36),
        const AddSpeakerCard(tag: "gsl"),
      ],
    );
  }
}
