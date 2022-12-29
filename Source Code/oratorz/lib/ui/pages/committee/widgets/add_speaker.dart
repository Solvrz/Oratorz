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
    final SpeechController _speechController =
        Get.find<SpeechController>(tag: tag);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add Speaker",
          style: context.textTheme.headline5,
        ),
        const SizedBox(height: 8),
        GetBuilder<SpeechController>(
          tag: tag,
          builder: (_) {
            final List<String> speakers =
                Get.find<CommitteeController>().committee.presentDelegates;

            return speakers.isNotEmpty
                ? Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: speakers.length,
                      itemBuilder: (_, index) {
                        final bool isAdded =
                            _speechController.isAdded(speakers[index]);

                        return Opacity(
                          opacity: isAdded ? 0.6 : 1,
                          child: DelegateTile(
                            delegate: speakers[index],
                            onTap: isAdded
                                ? null
                                : () {
                                    _speechController.addSpeaker(
                                      speakers[index],
                                    );
                                    _speechController.update();
                                  },
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => Divider(
                        height: 6,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  )
                : Text(
                    "Conduct a roll call before adding speakers",
                    style: context.textTheme.bodyText1,
                  );
          },
        ),
      ],
    );
  }
}
