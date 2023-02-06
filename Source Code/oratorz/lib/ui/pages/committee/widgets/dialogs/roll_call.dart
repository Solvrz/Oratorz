import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/tools/controllers/comittee/committee.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';

class RollCallDialog extends StatelessWidget {
  const RollCallDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final CommitteeController controller = Get.find<CommitteeController>();

    return DialogBox(
      heading: "Roll Call",
      content: SizedBox(
        height: context.height / 1.5,
        width: context.width / 3,
        child: controller.committee.count > 0
            ? Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RoundedButton(
                                style: RoundedButtonStyle.border,
                                onPressed: () {
                                  controller.setAllPresent();
                                  controller.update();
                                },
                                child: Text(
                                  "SET ALL PRESENT",
                                  style: context.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              child: RoundedButton(
                                style: RoundedButtonStyle.border,
                                onPressed: () {
                                  controller.setAllAbsent();
                                  controller.update();
                                },
                                child: Text(
                                  "SET ALL ABSENT",
                                  style: context.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: RoundedButton(
                                style: RoundedButtonStyle.border,
                                onPressed: () {
                                  controller.setAllPresentAndVoting();
                                  controller.update();
                                },
                                child: Text(
                                  "SET ALL PRESENT & VOTING",
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: ListView.builder(
                      itemCount: controller.committee.count,
                      itemBuilder: (_, index) {
                        final String delegate =
                            controller.committee.delegates[index];

                        return GetBuilder<CommitteeController>(
                          builder: (_) {
                            final int? rollCall = controller.rollCall[delegate];

                            return DelegateTile(
                              delegate: delegate,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RoundedButton(
                                    style: rollCall == RollCall.presentAndVoting
                                        ? RoundedButtonStyle.fill
                                        : RoundedButtonStyle.border,
                                    color: Colors.blue.shade400,
                                    onPressed: () {
                                      controller.setRollCall(
                                        delegate,
                                        RollCall.presentAndVoting,
                                      );

                                      controller.update();
                                    },
                                    child: const Text("PV"),
                                  ),
                                  const SizedBox(width: 4),
                                  RoundedButton(
                                    style: rollCall == RollCall.present
                                        ? RoundedButtonStyle.fill
                                        : RoundedButtonStyle.border,
                                    color: Colors.amber.shade400,
                                    onPressed: () {
                                      controller.setRollCall(
                                        delegate,
                                        RollCall.present,
                                      );

                                      controller.update();
                                    },
                                    child: const Text("P"),
                                  ),
                                  const SizedBox(width: 4),
                                  RoundedButton(
                                    style: rollCall == RollCall.absent
                                        ? RoundedButtonStyle.fill
                                        : RoundedButtonStyle.border,
                                    color: Colors.red.shade400,
                                    onPressed: () {
                                      controller.setRollCall(
                                        delegate,
                                        RollCall.absent,
                                      );

                                      controller.update();
                                    },
                                    child: const Text("A"),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  "No delegates are there in the commitee.",
                  style: context.textTheme.bodyLarge,
                ),
              ),
      ),
      actions: [
        SizedBox(
          width: context.width / 3,
          child: RoundedButton(
            onPressed: () => context.pop(),
            child: const Text("DONE"),
          ),
        ),
      ],
    );
  }
}
