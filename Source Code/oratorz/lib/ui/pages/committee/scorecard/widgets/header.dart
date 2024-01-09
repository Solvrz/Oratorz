import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './table.dart' show DIMENSIONS;
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
            ),
            width: DIMENSIONS[0],
            height: DIMENSIONS[2],
            child: Text(
              "Delegate",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ...List.generate(
            controller.parameters.length,
            (index) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300, width: 2),
                ),
              ),
              width: DIMENSIONS[1],
              height: DIMENSIONS[2],
              child: ParameterWidget(
                index: index,
                mode: controller.mode.value,
              ),
            ),
          ),
          Container(
            width: DIMENSIONS[1],
            height: DIMENSIONS[2],
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ParameterWidget(
              index: controller.parameters.length,
              mode: controller.mode.value,
              isTotal: true,
            ),
          ),
        ],
      ),
    );
  }
}
