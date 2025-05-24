import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/data.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/scorecard.dart';
import '/ui/widgets/delegate_tile.dart';
import './cell.dart';
import './header.dart';

const List<double> DIMENSIONS = [240, 200, 50];

class Table extends StatelessWidget {
  const Table({super.key});

  List<String> getDelegates() {
    final ScorecardController controller = Get.find<ScorecardController>();

    final Map<String, List<double>> scores = controller.scorecard.scores;

    final List<String> delegates =
        List<String>.from(Get.find<CommitteeController>().committee.delegates)
            .where(
              (element) => DELEGATES[element]!
                  .toLowerCase()
                  .contains(controller.query.value.toLowerCase()),
            )
            .toList();

    if (controller.sort.value != 0) {
      delegates.sort((a, b) {
        final double valA;
        final double valB;

        if (controller.sortIndex == controller.scorecard.parameters.length) {
          valA = scores[a]!.sum;
          valB = scores[b]!.sum;
        } else {
          valA = scores[a]![controller.sortIndex];
          valB = scores[b]![controller.sortIndex];
        }

        return valA.compareTo(valB) * (controller.sort.value.clamp(-1, 1));
      });
    }

    return delegates;
  }

  @override
  Widget build(BuildContext context) {
    final ScorecardController controller = Get.find<ScorecardController>();

    return Obx(
      () {
        final List<String> delegates = getDelegates();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 20 +
                DIMENSIONS[0] +
                DIMENSIONS[1] * controller.scorecard.parameters.length,
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
                              controller.scorecard.parameters.length - 1,
                              (index) => SizedBox(
                                width: DIMENSIONS[1],
                                child: Cell(delegate: delegate, index: index),
                              ),
                            ),
                            SizedBox(
                              width: DIMENSIONS[1],
                              child: Center(
                                child: Obx(
                                  () => Text(
                                    controller.scorecard.scores[delegate]!.sum
                                        .toString(),
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
