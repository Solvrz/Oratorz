import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '/ui/pages/committee/modes/widgets/add_speaker_card.dart';
import '/ui/pages/committee/widgets/hourglass.dart';
import '/ui/pages/committee/widgets/speakers_info.dart';

class SingleMode extends StatelessWidget {
  const SingleMode({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SpeechController>(tag: "single")) {
      Get.put<SpeechController>(SpeechController("single"), tag: "single");
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
                      Center(child: Hourglass(tag: "single")),
                      SizedBox(width: 48),
                      SpeakersInfo(tag: "single"),
                    ],
                  ),
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
