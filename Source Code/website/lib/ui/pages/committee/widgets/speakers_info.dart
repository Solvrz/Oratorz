import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/speech.dart';
import '/tools/functions.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/rounded_button.dart';

class SpeakersInfo extends StatelessWidget {
  final String tag;

  const SpeakersInfo({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final SpeechController controller = Get.find<SpeechController>(tag: tag);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current Speaker",
                style: context.textTheme.headlineSmall,
              ),
              RoundedButton(
                color: context.theme.colorScheme.tertiary,
                padding: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 4,
                ),
                onPressed: () {
                  if (controller.stopwatch.elapsedTicks == 0) {
                    snackbar(
                      context,
                      const Center(
                        child: Text("The delegate has not yet spoken"),
                      ),
                    );
                  } else {
                    controller.nextSpeaker();
                  }
                },
                child: Obx(
                  () => Text(
                    controller.isSpeaking ? "Done" : "Next",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(
            () => controller.currentSpeaker.isNotEmpty
                ? DelegateTile(
                    delegate: controller.currentSpeaker,
                    onHover: RoundedButton(
                      color: Colors.red.shade400,
                      padding: const EdgeInsets.all(4),
                      onPressed: () => controller.removeCurrentSpeaker(),
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
                    style: context.textTheme.bodyLarge,
                  ),
          ),
          const Divider(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Upcoming Speakers",
              style: context.textTheme.headlineSmall,
            ),
          ),
          Obx(
            () => controller.nextSpeakers.isNotEmpty
                ? Expanded(
                    child: ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      proxyDecorator: proxyDecorator,
                      onReorder: (oldIndex, newIndex) =>
                          controller.reorder(oldIndex, newIndex),
                      itemCount: controller.nextSpeakers.length,
                      itemBuilder: (_, index) => ReorderableDragStartListener(
                        index: index,
                        key: ValueKey(index),
                        child: Column(
                          children: [
                            DelegateTile(
                              delegate: controller.nextSpeakers[index],
                              trailing: Row(
                                children: [
                                  RoundedButton(
                                    color: context.theme.colorScheme.tertiary,
                                    padding: const EdgeInsets.all(4),
                                    onPressed: () => controller
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
                                    onPressed: () => controller.removeSpeaker(
                                      controller.nextSpeakers[index],
                                    ),
                                    tooltip: "Remove Delegate",
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.drag_handle,
                              color: Colors.grey.shade600,
                            ),
                            if (index != controller.nextSpeakers.length - 1)
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
                    style: context.textTheme.bodyLarge,
                  ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 2),
        ],
      ),
    );
  }
}
