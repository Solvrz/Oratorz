import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/gsl.dart';
import '/ui/widgets/country_tile.dart';

class SpeakersInfoWidget extends StatelessWidget {
  const SpeakersInfoWidget({
    super.key,
    required this.gslController,
  });

  final GSLController gslController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Current Speaker",
              style: Theme.of(context).textTheme.headline5,
            ),
            TextButton(
              onPressed: gslController.nextSpeaker,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue.shade400),
                side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(color: Colors.blue.shade400),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                overlayColor: MaterialStateProperty.all<Color>(Colors.white12),
              ),
              child: const Text("Next"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(
          () => gslController.currentSpeaker.value != ""
              ? CountryTile(
                  country: gslController.currentSpeaker.value,
                  contentPadding: EdgeInsets.zero,
                )
              : Text(
                  "No speaker currently added",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
        ),
        const Divider(height: 16),
        const SizedBox(height: 8),
        Text(
          "Upcoming Speakers",
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(height: 8),
        Obx(
          () => gslController.nextSpeakers.isNotEmpty
              ? Expanded(
                  child: ReorderableListView.builder(
                    buildDefaultDragHandles: false,
                    onReorder: (oldIndex, newIndex) =>
                        gslController.reorder(oldIndex, newIndex),
                    itemCount: gslController.nextSpeakers.length,
                    itemBuilder: (context, index) =>
                        ReorderableDragStartListener(
                      key: ValueKey(index),
                      index: index,
                      child: Column(
                        children: [
                          CountryTile(
                            country: gslController.nextSpeakers[index],
                            contentPadding: EdgeInsets.zero,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => gslController.removeSpeaker(
                                    gslController.nextSpeakers[index],
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
                          if (index != gslController.nextSpeakers.length - 1)
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
                  style: Theme.of(context).textTheme.bodyText1,
                ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 2),
      ],
    );
  }
}
