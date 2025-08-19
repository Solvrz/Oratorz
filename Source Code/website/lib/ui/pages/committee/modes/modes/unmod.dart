import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '/ui/pages/committee/widgets/hourglass.dart';

class UnmodMode extends StatelessWidget {
  const UnmodMode({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SpeechController>(tag: "unmod")) {
      Get.put<SpeechController>(
        SpeechController("unmod", autosave: false),
        tag: "unmod",
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
            child: const Hourglass(tag: "unmod"),
          ),
        ),
      ],
    );
  }
}
