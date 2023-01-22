import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/rounded_button.dart';

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
          height: context.height / 2.5,
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Past Speakers",
                style: context.textTheme.headline5,
              ),
              const SizedBox(height: 8),
              Obx(
                () => _speechController.pastSpeakers.isEmpty
                    ? Text(
                        "No past speakers have been recorded",
                        style: context.textTheme.bodyText1,
                      )
                    : Expanded(
                        child: ListView.separated(
                          itemCount: _speechController.pastSpeakers.length,
                          itemBuilder: (_, index) {
                            final Map<String, Duration> speaker =
                                _speechController.pastSpeakers[index];

                            final int inMinutes =
                                speaker.values.first.inMinutes;
                            final int inSeconds =
                                speaker.values.first.inSeconds;

                            //TODO: Option to remove from past

                            return DelegateTile(
                              delegate: speaker.keys.first,
                              hover: false,
                              trailing: [
                                Text(
                                  "$inMinutes:${(inSeconds - inMinutes * 60).toString().padLeft(2, "0")}",
                                  style: context.textTheme.bodyText1,
                                ),
                                const SizedBox(width: 10),
                                RoundedButton(
                                  color: Colors.red.shade400,
                                  padding: const EdgeInsets.all(4),
                                  onPressed: () => _speechController
                                      .pastSpeakers
                                      .removeAt(index),
                                  tooltip: "Remove Delegate",
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (_, __) => Divider(
                            height: 6,
                            color: Colors.grey.shade400,
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
