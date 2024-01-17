import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '/ui/pages/committee/widgets/hourglass.dart';

class ConsultationMode extends StatelessWidget {
  const ConsultationMode({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SpeechController>(tag: "consultation")) {
      final SpeechController _speechController = Get.put<SpeechController>(
        SpeechController("consultation"),
        tag: "consultation",
      );

      _speechController.subtopic = {"Topic": "Your Topic"};
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Card(
          child: Container(
            width: context.width / 5,
            margin: const EdgeInsets.symmetric(
              horizontal: 100,
              vertical: 18,
            ),
            child: const Hourglass(tag: "consultation"),
          ),
        ),
      ],
    );
  }
}
