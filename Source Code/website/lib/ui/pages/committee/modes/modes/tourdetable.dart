import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '/ui/pages/committee/modes/widgets/add_speaker_card.dart';
import '/ui/pages/committee/modes/widgets/past_speakers_card.dart';
import '/ui/pages/committee/widgets/hourglass.dart';
import '/ui/pages/committee/widgets/speakers_info.dart';

class TourDeTableMode extends StatelessWidget {
  const TourDeTableMode({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SpeechController>(tag: "tourdetable")) {
      final SpeechController _speechController = Get.put<SpeechController>(
        SpeechController("tourdetable"),
        tag: "tourdetable",
      );

      _speechController.subtopic = {"Topic": "Your Topic"};
    }

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
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Hourglass(tag: "tourdetable")),
                      SizedBox(width: 48),
                      SpeakersInfo(tag: "tourdetable"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const PastSpeakersCard(tag: "tourdetable"),
            ],
          ),
        ),
        const SizedBox(width: 36),
        const AddSpeakerCard(tag: "tourdetable"),
      ],
    );
  }
}
