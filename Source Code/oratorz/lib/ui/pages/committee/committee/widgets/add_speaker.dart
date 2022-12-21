import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/speech.dart';
import '/ui/widgets/delegate_tile.dart';

class AddSpeakerCard extends StatelessWidget {
  final String tag;

  const AddSpeakerCard({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final CommitteeController _committeeController =
        Get.find<CommitteeController>();
    final SpeechController _speechController =
        Get.find<SpeechController>(tag: tag);

    return Expanded(
      child: Card(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: context.height * 0.8,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Speaker",
                style: context.textTheme.headline5,
              ),
              const SizedBox(height: 8),
              Obx(() {
                final List<String> speakers =
                    _committeeController.committee.value.presentDelegates;

                return speakers.isNotEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              speakers.length * 2 - 1,
                              (index) {
                                final bool isAdded = _speechController
                                    .isAdded(speakers[index ~/ 2]);

                                return index % 2 == 0
                                    ? Opacity(
                                        opacity: isAdded ? 0.6 : 1,
                                        child: DelegateTile(
                                          delegate: speakers[index ~/ 2],
                                          onTap: isAdded
                                              ? null
                                              : () =>
                                                  _speechController.addSpeaker(
                                                    speakers[index ~/ 2],
                                                  ),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      )
                                    : Divider(
                                        height: 6,
                                        color: Colors.grey.shade400,
                                      );
                              },
                            ),
                          ),
                        ),
                      )
                    : Text(
                        "Conduct a roll call before adding speakers",
                        style: context.textTheme.bodyText1,
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
