import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/scorecard.dart';
import '/ui/widgets/delegate_tile.dart';
import 'scorecell.dart';

class DelegateData extends StatelessWidget {
  const DelegateData({
    super.key,
    required this.delegate,
  });

  final String delegate;

  @override
  Widget build(BuildContext context) {
    final ScorecardController controller = Get.find<ScorecardController>();

    return Obx(
      () => Row(
        children: [
          SizedBox(
            width: 200,
            child: DelegateTile(delegate: delegate),
          ),
          ...List.generate(
            controller.parameters.length,
            (index) => SizedBox(
              width: 200,
              child: ScoreCell(delegate: delegate, index: index),
            ),
          ),
          SizedBox(
            width: 100,
            child: Center(
              child: Obx(
                () => Text(
                  controller.scores[delegate]!.sum.toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
