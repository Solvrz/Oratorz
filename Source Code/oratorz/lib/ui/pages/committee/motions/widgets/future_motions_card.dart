import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/motions.dart';
import './motion_tile.dart';

class FutureMotionsCard extends StatelessWidget {
  const FutureMotionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final MotionsController _motionsController = Get.put(MotionsController());
    final List<Map<String, dynamic>> motions = _motionsController.motions
      ..removeAt(0);

    return SizedBox(
      height: context.height / 1.965,
      width: context.width / 3,
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Future Motions",
                style: context.textTheme.headline5,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: motions.isNotEmpty
                    ? ListView.builder(
                        itemCount: motions.length,
                        itemBuilder: (_, index) =>
                            MotionTile(motion: motions[index]),
                      )
                    : Text(
                        "No motions added yet.",
                        style: context.textTheme.bodyText1,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
