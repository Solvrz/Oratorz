import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '/ui/widgets/delegate_tile.dart';

class SpeakersInfoWidget extends StatelessWidget {
  final String tag;

  const SpeakersInfoWidget({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final SpeechController _speechController =
        Get.find<SpeechController>(tag: tag);

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
              TextButton(
                onPressed: _speechController.nextSpeaker,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue.shade400),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(color: Colors.blue.shade400),
                  ),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  overlayColor:
                      MaterialStateProperty.all<Color>(Colors.white12),
                ),
                child: Obx(
                  () => Text(
                    _speechController.isSpeaking.value ? "Done" : "Next",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(
            () => _speechController.currentSpeaker.value != ""
                ? DelegateTile(
                    delegate: _speechController.currentSpeaker.value,
                    contentPadding: EdgeInsets.zero,
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
                      itemBuilder: (context, index) =>
                          ReorderableDragStartListener(
                        key: ValueKey(index),
                        index: index,
                        child: Column(
                          children: [
                            DelegateTile(
                              delegate: _speechController.nextSpeakers[index],
                              contentPadding: EdgeInsets.zero,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        _speechController.removeSpeaker(
                                      _speechController.nextSpeakers[index],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red.shade400,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
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
