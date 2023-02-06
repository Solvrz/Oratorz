import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/scorecard.dart';
import 'parameter.dart';
import 'scoretable.dart' show DIMENSIONS;

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
            width: DIMENSIONS[0],
            child: Text(
              "Delegate",
              style: Theme.of(context).textTheme.titleLarge,
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
              width: DIMENSIONS[1],
              child: Parameter(
                index: index,
                mode: controller.mode.value,
              ),
            ),
          ),
          Container(
            width: DIMENSIONS[2],
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => controller.sort.value = !controller.sort.value,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: controller.sort.value
                          ? Colors.grey[700]
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.arrow_downward,
                      color: controller.sort.value
                          ? Colors.grey[300]
                          : Colors.grey[400],
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
