import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/rounded_button.dart';

class SpeakersInfo extends StatelessWidget {
  final String tag;

  const SpeakersInfo({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final SpeechController _speechController =
        Get.find<SpeechController>(tag: tag);

    //TODO: Cofirmation on clicking Next/Done

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current Speaker",
                style: context.textTheme.headline5,
              ),
              RoundedButton(
                color: Colors.blue.shade400,
                padding: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 4,
                ),
                onPressed: _speechController.nextSpeaker,
                child: Obx(
                  () => Text(
                    _speechController.isSpeaking ? "Done" : "Next",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(
            () => _speechController.currentSpeaker.isNotEmpty
                ? DelegateTile(
                    delegate: _speechController.currentSpeaker,
                    trailing: RoundedButton(
                      color: Colors.red.shade400,
                      padding: const EdgeInsets.all(4),
                      onPressed: () => _speechController.removeCurrentSpeaker(),
                      tooltip: "Remove Delegate",
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Text(
                    "No speaker currently added",
                    style: context.textTheme.bodyText1,
                  ),
          ),
          const Divider(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Upcoming Speakers",
              style: context.textTheme.headline5,
            ),
          ),
          Obx(
            () => _speechController.nextSpeakers.isNotEmpty
                ? Expanded(
                    child: ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      onReorder: (oldIndex, newIndex) =>
                          _speechController.reorder(oldIndex, newIndex),
                      itemCount: _speechController.nextSpeakers.length,
                      itemBuilder: (_, index) => ReorderableDragStartListener(
                        index: index,
                        key: ValueKey(index),
                        child: Column(
                          children: [
                            DelegateTile(
                              delegate: _speechController.nextSpeakers[index],
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RoundedButton(
                                    color: Colors.blue.shade400,
                                    padding: const EdgeInsets.all(4),
                                    onPressed: () => _speechController
                                        .swapWithCurrentSpeaker(index),
                                    tooltip: "Swap with Current Speaker",
                                    child: const Icon(
                                      Icons.swap_calls,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  RoundedButton(
                                    color: Colors.red.shade400,
                                    padding: const EdgeInsets.all(4),
                                    onPressed: () =>
                                        _speechController.removeSpeaker(
                                      _speechController.nextSpeakers[index],
                                    ),
                                    tooltip: "Remove Delegate",
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.drag_handle,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            ),
                            if (index !=
                                _speechController.nextSpeakers.length - 1)
                              Divider(
                                indent: 65,
                                height: 6,
                                color: Colors.grey.shade400,
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Text(
                    "No upcoming speakers",
                    style: context.textTheme.bodyText1,
                  ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 2),
        ],
      ),
    );
  }
}
