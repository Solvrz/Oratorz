import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                              trailing: Text(
                                "$inMinutes:${(inSeconds - inMinutes * 60).toString().padLeft(2, "0")}",
                                style: context.textTheme.bodyText1,
                              ),
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
