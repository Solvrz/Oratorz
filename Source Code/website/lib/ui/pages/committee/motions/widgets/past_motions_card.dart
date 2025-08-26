import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/services/cloud_storage.dart';
import '/tools/controllers/comittee/motions.dart';
import './motion_tile.dart';

class PastMotionsCard extends StatelessWidget {
  const PastMotionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final MotionsController _motionsController = Get.find<MotionsController>();

    return Expanded(
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Past Motions",
                style: context.textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder(
                  future: CloudStorage.fetchPastMotions(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(
                            color: Color(0xff2a313b),
                          ),
                        ),
                      );
                    }

                    return Obx(() {
                      final List<Map<String, dynamic>> pastMotions =
                          _motionsController.pastMotions.sorted(
                        (a, b) => a["timestamp"].compareTo(b["timestamp"]) * -1,
                      );

                      if (pastMotions.isNotEmpty) {
                        return ListView.builder(
                          itemCount: pastMotions.length,
                          itemBuilder: (_, index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: index != pastMotions.length - 1 ? 20 : 0,
                            ),
                            child: MotionTile(motion: pastMotions[index]),
                          ),
                        );
                      } else {
                        return Text(
                          "No motions added yet.",
                          style: context.textTheme.bodyLarge,
                        );
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
