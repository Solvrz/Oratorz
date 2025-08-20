import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/data.dart';
import '/tools/controllers/comittee/vote.dart';
import '/tools/functions.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/rounded_button.dart';
import '../../../../../services/cloud_storage.dart';

class VotingCard extends StatelessWidget {
  const VotingCard({super.key});
  @override
  Widget build(BuildContext context) {
    final VoteController controller = Get.find<VoteController>(tag: "vote");

    return Expanded(
      child: Card(
        child: Container(
          constraints: BoxConstraints(maxHeight: context.height * 0.9),
          padding: const EdgeInsets.all(24),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Voting",
                      style: context.textTheme.headlineSmall,
                    ),
                    const Spacer(),
                    if (controller.pastVoters.isNotEmpty &&
                        controller.voters.isEmpty)
                      RoundedButton(
                        child: const Text("Upload Vote"),
                        onPressed: () => CloudStorage.uploadVote(),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: controller.voters.isNotEmpty ||
                          controller.pastVoters.isNotEmpty
                      ? Column(
                          children: [
                            if (controller.currentVoter != "")
                              Container(
                                height: context.height / 7,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          flag(
                                            size: 100,
                                            controller.currentVoter,
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            DELEGATES[controller.currentVoter]!,
                                            style:
                                                context.textTheme.displayMedium,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RoundedButton(
                                            color: Colors.green,
                                            onPressed: () => controller.vote(
                                              vote: true,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 56,
                                              vertical: 8,
                                            ),
                                            child: const Text("In Favor"),
                                          ),
                                          const SizedBox(height: 8),
                                          RoundedButton(
                                            color: Colors.red,
                                            onPressed: () =>
                                                controller.vote(vote: false),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 56,
                                              vertical: 8,
                                            ),
                                            child: const Text("Against"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Expanded(
                              child: ListView.separated(
                                itemCount: controller.voters.length -
                                    1 +
                                    controller.pastVoters.length,
                                itemBuilder: (_, index) {
                                  final int offset =
                                      controller.voters.length - 1;

                                  return index < offset
                                      ? DelegateTile(
                                          delegate:
                                              controller.voters[index + 1],
                                        )
                                      : DelegateTile(
                                          delegate: controller
                                              .pastVoters[index - offset]
                                              .keys
                                              .first,
                                          trailing: CircleAvatar(
                                            radius: 5,
                                            backgroundColor: controller
                                                    .pastVoters[index - offset]
                                                    .values
                                                    .first
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        );
                                },
                                separatorBuilder: (_, __) => Divider(
                                  height: 6,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          "Conduct a roll call before voting",
                          style: context.textTheme.bodyLarge,
                        ),
                ),
                if (controller.pastVoters.isNotEmpty &&
                    controller.voters.isEmpty)
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Vote Completed",
                        style: context.textTheme.displayMedium,
                        children: [
                          TextSpan(
                            text:
                                "\nResult: Vote ${controller.inFavor >= controller.majorityVal() ? "Passed" : "Failed"}!",
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontSize: 30,
                              color:
                                  controller.inFavor >= controller.majorityVal()
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
