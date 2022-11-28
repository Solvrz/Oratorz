import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/gsl.dart';
import '/ui/widgets/country_tile.dart';

class SpeakersInfoWidget extends StatelessWidget {
  const SpeakersInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GSLController _gslController = Get.find<GSLController>();

    return Expanded(
      child: Column(
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
                onPressed: _gslController.nextSpeaker,
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
                    _gslController.isSpeaking.value ? "Done" : "Next",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(
            () => _gslController.currentSpeaker.value != ""
                ? CountryTile(
                    country: _gslController.currentSpeaker.value,
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
            () => _gslController.nextSpeakers.isNotEmpty
                ? Expanded(
                    child: ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      onReorder: (oldIndex, newIndex) =>
                          _gslController.reorder(oldIndex, newIndex),
                      itemCount: _gslController.nextSpeakers.length,
                      itemBuilder: (context, index) =>
                          ReorderableDragStartListener(
                        key: ValueKey(index),
                        index: index,
                        child: Column(
                          children: [
                            CountryTile(
                              country: _gslController.nextSpeakers[index],
                              contentPadding: EdgeInsets.zero,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () => _gslController.removeSpeaker(
                                      _gslController.nextSpeakers[index],
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
                            if (index != _gslController.nextSpeakers.length - 1)
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
      ),
    );
  }
}
