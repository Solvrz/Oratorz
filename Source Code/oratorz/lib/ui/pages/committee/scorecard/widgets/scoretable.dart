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

    final List<String> delegates =
        Get.find<CommitteeController>().committee.delegates;

    return Obx(
      () => SingleChildScrollView(
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
      ),
    );
  }
}
