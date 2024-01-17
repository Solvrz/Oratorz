import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/services/local_storage.dart';
import '/tools/controllers/comittee/speech.dart';
import '/ui/pages/committee/modes/widgets/add_speaker_card.dart';
import '/ui/pages/committee/modes/widgets/past_speakers_card.dart';
import '/ui/pages/committee/widgets/hourglass.dart';
import '/ui/pages/committee/widgets/speakers_info.dart';

class ModMode extends StatelessWidget {
  const ModMode({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SpeechController>()) {
      final bool exists = LocalStorage.loadSpeech("mod");

      if (!exists) {
        final SpeechController controller =
            Get.put<SpeechController>(SpeechController("mod"), tag: "mod");

        controller.overallDuration = const Duration(minutes: 15);
        controller.subtopic = {"Topic": "Your Topic"};

        Get.put<SpeechController>(controller, tag: "mod");
        LocalStorage.saveSpeech(controller);
      }
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
                      Center(child: Hourglass(tag: "mod")),
                      SizedBox(width: 48),
                      SpeakersInfo(tag: "mod"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const PastSpeakersCard(tag: "mod"),
            ],
          ),
        ),
        const SizedBox(width: 36),
        const AddSpeakerCard(tag: "mod"),
      ],
    );
  }
}
