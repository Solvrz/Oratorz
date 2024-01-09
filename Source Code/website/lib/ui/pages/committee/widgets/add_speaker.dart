import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/speech.dart';
import '/ui/widgets/delegate_tile.dart';

class AddSpeaker extends StatelessWidget {
  final String tag;

  const AddSpeaker({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final SpeechController controller = Get.find<SpeechController>(tag: tag);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add Speaker",
          style: context.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Obx(() {
          final List<String> speakers =
              Get.find<CommitteeController>().committee.presentDelegates;

          return speakers.isNotEmpty
              ? Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: speakers.length,
                    itemBuilder: (_, index) {
                      return Obx(() {
                        final bool isAdded =
                            controller.isAdded(speakers[index]);

                        return Opacity(
                          opacity: isAdded ? 0.6 : 1,
                          child: DelegateTile(
                            delegate: speakers[index],
                            onTap: () {
                              if (!isAdded) {
                                controller.addSpeaker(
                                  speakers[index],
                                );
                                controller.update();
                              }
                            },
                          ),
                        );
                      });
                    },
                    separatorBuilder: (_, __) => Divider(
                      indent: 65,
                      height: 6,
                      color: Colors.grey.shade400,
                    ),
                  ),
                )
              : Text(
                  "Conduct a roll call before adding speakers",
                  style: context.textTheme.bodyLarge,
                );
        }),
      ],
    );
  }
}
