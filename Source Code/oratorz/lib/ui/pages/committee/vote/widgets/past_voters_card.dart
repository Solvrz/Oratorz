import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/vote.dart';
import '/ui/widgets/delegate_tile.dart';

class PastVotersCard extends StatelessWidget {
  const PastVotersCard({super.key});

  @override
  Widget build(BuildContext context) {
    final VoteController controller = Get.find<VoteController>(tag: "vote");

    return SizedBox(
      height: context.height / 2.5,
      width: context.width / 4,
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Past Voters",
                style: context.textTheme.headline5,
              ),
              const SizedBox(height: 8),
              Obx(
                () => controller.pastVoters.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          itemCount: controller.pastVoters.length,
                          itemBuilder: (_, index) => DelegateTile(
                            delegate: controller.pastVoters[index].keys.first,
                            trailing: CircleAvatar(
                              radius: 5,
                              backgroundColor:
                                  controller.pastVoters[index].values.first
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                          separatorBuilder: (_, __) => Divider(
                            height: 6,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      )
                    : Text(
                        "No one has voted yet.",
                        style: context.textTheme.bodyText1,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
