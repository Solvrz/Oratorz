import 'package:flutter/material.dart';

import '../widgets/gsl/add_speaker.dart';
import '../widgets/gsl/past_speakers.dart';
import '../widgets/gsl/speakers_info.dart';
import '../widgets/gsl/stopwatch.dart';

class GSLTab extends StatelessWidget {
  const GSLTab({super.key});

  @override
  Widget build(BuildContext context) => Row(
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
                        const SpeakersInfoWidget(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const PastSpeakersCard(),
              ],
            ),
          ),
          const SizedBox(width: 36),
          const AddSpeakerCard(),
        ],
      );
}
