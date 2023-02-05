import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '/tools/functions.dart';
import '../widgets/hourglass.dart';

class AdjournTab extends StatelessWidget {
  const AdjournTab({super.key});

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
        carousel(context),
      ],
    );
  }
}
