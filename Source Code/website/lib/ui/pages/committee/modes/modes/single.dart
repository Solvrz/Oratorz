import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/hourglass.dart';
import '../../widgets/speakers_info.dart';
import '../widgets/add_speaker_card.dart';
import '/tools/controllers/comittee/speech.dart';

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
              const SizedBox(height: 50),
              Center(
                child: Text(
                  "Carousel Placeholder",
                  style: context.textTheme.bodyLarge,
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
