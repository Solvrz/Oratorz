import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/services/cloud_storage.dart';
import '/tools/controllers/comittee/motions.dart';
import '../../../../../tools/controllers/comittee/committee.dart';
import './motion_tile.dart';

class PastMotionsCard extends StatelessWidget {
  const PastMotionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final MotionsController controller = Get.find<MotionsController>();

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
                child: GetBuilder<CommitteeController>(
                  builder: (_) => FutureBuilder(
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

                      final List<Map<String, dynamic>> pastMotions = controller
                          .pastMotions
                          .toList()
                          .sorted(
                            (a, b) =>
                                a["timestamp"].compareTo(b["timestamp"]) * -1,
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
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
