import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '/ui/pages/committee/widgets/hourglass.dart';

class AdjournMode extends StatelessWidget {
  const AdjournMode({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SpeechController>(tag: "adjourn")) {
      Get.put<SpeechController>(
        SpeechController("adjourn"),
        tag: "adjourn",
      );
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
            child: const Hourglass(tag: "adjourn"),
          ),
        ),
      ],
    );
  }
}
