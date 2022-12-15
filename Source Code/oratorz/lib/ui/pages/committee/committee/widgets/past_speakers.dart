import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/constants/constants.dart';
import '/tools/controllers/comittee/speech.dart';
import '/ui/widgets/delegate_tile.dart';

class PastSpeakersCard extends StatelessWidget {
  final String tag;

  const PastSpeakersCard({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final SpeechController _speechController =
        Get.find<SpeechController>(tag: tag);

    return Expanded(
      child: Card(
        child: Container(
          height: MediaQuery.of(context).size.height / 2.5,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Past Speakers",
                style: theme.textTheme.headline5,
              ),
              const SizedBox(height: 8),
              Obx(
                () => _speechController.pastSpeakers.isEmpty
                    ? Text(
                        "No past speakers have been recorded",
                        style: theme.textTheme.bodyText1,
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              _speechController.pastSpeakers.length * 2 - 1,
                              (index) {
                                if (index % 2 == 1) {
                                  return Divider(
                                    height: 6,
                                    color: Colors.grey.shade400,
                                  );
                                }

                                final Map<String, Duration> speaker =
                                    _speechController.pastSpeakers[index ~/ 2];
                                final int inMinutes =
                                    speaker.values.first.inMinutes;
                                final int inSeconds =
                                    speaker.values.first.inSeconds;

                                return DelegateTile(
                                  delegate: speaker.keys.first,
                                  contentPadding: EdgeInsets.zero,
                                  trailing: Text(
                                    "$inMinutes:${(inSeconds - inMinutes * 60).toString().padLeft(2, '0')}",
                                    style: theme.textTheme.bodyText1,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
