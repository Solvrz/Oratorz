import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '../../widgets/add_speaker.dart';
import '../../widgets/hourglass.dart';
import '../../widgets/speakers_info.dart';

class DebateCard extends StatelessWidget {
  const DebateCard({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<SpeechController>(SpeechController("motions"), tag: "motions");

    return Expanded(
      child: Card(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: context.height * 0.9,
          ),
          margin: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Debate on Motion",
                style: context.textTheme.headline5,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Row(
                  children: [
                    Hourglass(
                      tag: "motions",
                      height: context.height / 3.5,
                      radius: 85,
                    ),
                    const SizedBox(width: 48),
                    const SpeakersInfo(tag: "motions"),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Divider(),
              SizedBox(
                height: context.height / 2.75,
                child: const AddSpeaker(tag: "motions"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
