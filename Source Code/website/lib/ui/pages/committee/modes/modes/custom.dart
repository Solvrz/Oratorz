import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/hourglass.dart';
import '/tools/controllers/comittee/speech.dart';
import '/tools/functions.dart';

class CustomMode extends StatelessWidget {
  const CustomMode({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SpeechController>(tag: "custom")) {
      final SpeechController _speechController =
          Get.put<SpeechController>(SpeechController("custom"), tag: "custom");

      _speechController.subtopic = {"Title": "Your Title"};
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
            child: const Hourglass(tag: "custom"),
          ),
        ),
        carousel(context),
      ],
    );
  }
}
