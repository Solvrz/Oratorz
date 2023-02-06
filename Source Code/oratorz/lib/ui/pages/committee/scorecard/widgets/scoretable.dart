import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/scorecard.dart';
import '/ui/widgets/delegate_tile.dart';
import 'header.dart';
import 'scorecell.dart';

const List<double> DIMENSIONS = [240, 200, 100];

class ScoreTable extends StatelessWidget {
  const ScoreTable({super.key});

  //TODO (YUG): Add search and auto scroll to matching delegate

  @override
  Widget build(BuildContext context) {
    final ScorecardController controller = Get.find<ScorecardController>();

    return Obx(
      () {
        final List<String> delegates = List.from(
          Get.find<CommitteeController>().committee.delegates,
        );

        if (controller.sort.value) {
          delegates.sort(
            (a, b) =>
                controller.scores[a]!.sum.compareTo(controller.scores[b]!.sum) *
                -1, //In order to sort descending
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 20 +
                DIMENSIONS[0] +
                (DIMENSIONS[1] * controller.parameters.length) +
                DIMENSIONS[2],
            child: Column(
              children: [
                const TableHeader(),
                Expanded(
                  child: ListView.separated(
                    itemCount: delegates.length,
                    itemBuilder: (context, index) {
                      final String delegate = delegates[index];

                      return Obx(
                        () => Row(
                          children: [
                            SizedBox(
                              width: DIMENSIONS[0],
                              child: DelegateTile(delegate: delegate),
                            ),
                            ...List.generate(
                              controller.parameters.length,
                              (index) => SizedBox(
                                width: DIMENSIONS[1],
                                child:
                                    ScoreCell(delegate: delegate, index: index),
                              ),
                            ),
                            SizedBox(
                              width: DIMENSIONS[2],
                              child: Center(
                                child: Obx(
                                  () => Text(
                                    controller.scores[delegate]!.sum.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => Divider(
                      color: Colors.grey.shade300,
                      height: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
