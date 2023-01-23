import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/comittee/scorecard.dart';
import 'delegate_data.dart';
import 'header.dart';

class ScoreTable extends StatelessWidget {
  const ScoreTable({super.key});

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
            width: 320.0 + (200 * controller.parameters.length),
            child: Column(
              children: [
                const TableHeader(),
                Expanded(
                  child: ListView.separated(
                    itemCount: delegates.length,
                    itemBuilder: (context, index) =>
                        DelegateData(delegate: delegates[index]),
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
