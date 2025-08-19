import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/motions.dart';
import '/tools/functions.dart';
import './motion_tile.dart';

class FutureMotionsCard extends StatelessWidget {
  const FutureMotionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final MotionsController _motionsController = Get.find<MotionsController>();

    return SizedBox(
      width: context.width / 3,
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Future Motions",
                style: context.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (_motionsController.nextMotions.isNotEmpty) {
                  return Expanded(
                    child: ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      proxyDecorator: proxyDecorator,
                      onReorder: (oldIndex, newIndex) =>
                          _motionsController.reorder(oldIndex, newIndex),
                      itemCount: _motionsController.nextMotions.length,
                      itemBuilder: (_, index) => ReorderableDragStartListener(
                        index: index,
                        key: ValueKey(index),
                        child: Column(
                          children: [
                            MotionTile(
                              motion: _motionsController.nextMotions[index],
                            ),
                            if (index !=
                                _motionsController.nextMotions.length - 1)
                              const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Text(
                    "No motions added yet.",
                    style: context.textTheme.bodyLarge,
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
