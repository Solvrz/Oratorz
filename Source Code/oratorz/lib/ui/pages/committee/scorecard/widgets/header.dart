import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/scorecard.dart';
import 'parameter.dart';

class TableHeader extends StatelessWidget {
  const TableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ScorecardController controller = Get.find<ScorecardController>();

    return Obx(
      () => Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
            ),
            width: 200,
            child: Text(
              "Delegate",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          ...List.generate(
            controller.parameters.length,
            (index) => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300, width: 2),
                ),
              ),
              width: 200,
              child: Parameter(
                index: index,
                mode: controller.mode.value,
              ),
            ),
          ),
          Container(
            width: 100,
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                "Total",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
