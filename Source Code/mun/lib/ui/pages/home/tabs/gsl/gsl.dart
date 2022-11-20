import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/gsl.dart';
import '../../widgets/stopwatch.dart';
import 'add_speaker.dart';
import 'past_speakers.dart';
import 'speakers_info.dart';

class GSLTab extends StatefulWidget {
  const GSLTab({super.key});

  @override
  State<GSLTab> createState() => _GSLTabState();
}

class _GSLTabState extends State<GSLTab> {
  final GSLController gslController = Get.put(GSLController());

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.25,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: StopwatchWidget(onTimeEnd: () {})),
                      const SizedBox(width: 48),
                      Expanded(
                        child: SpeakersInfoWidget(gslController: gslController),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(child: PastSpeakersCard(gslController: gslController)),
            ],
          ),
        ),
        const SizedBox(width: 36),
        Expanded(child: AddSpeakerCard(gslController: gslController)),
      ],
    );
  }
}
