import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/models/committee.dart';
import '/services/cloud_storage.dart';
import '/tools/controllers/comittee/committee.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';

class RollCallDialog extends StatefulWidget {
  const RollCallDialog({super.key});

  @override
  State<RollCallDialog> createState() => _RollCallDialogState();
}

class _RollCallDialogState extends State<RollCallDialog> {
  bool updating = false;

  @override
  Widget build(BuildContext context) {
    final CommitteeController controller = Get.find<CommitteeController>();

    return DialogBox(
      heading: "Roll Call",
      content: SizedBox(
        height: context.height / 1.5,
        width: context.width / 3,
        child: FutureBuilder(
          future: CloudStorage.fetchDayData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    color: Color(0xff2a313b),
                  ),
                ),
              );
            }

            return Column(
              children: [
                if (!controller.readOnly) ...[
                  Row(
                    children: [
                      Expanded(
                        child: RoundedButton(
                          style: RoundedButtonStyle.border,
                          onPressed: updating
                              ? null
                              : () {
                                  controller.setAllPresent();
                                  controller.update();
                                },
                          child: Text(
                            "SET ALL PRESENT",
                            style: context.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: RoundedButton(
                          style: RoundedButtonStyle.border,
                          onPressed: updating
                              ? null
                              : () {
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
                          onPressed: updating
                              ? null
                              : () {
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
                  const SizedBox(height: 16),
                ],
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    itemCount: controller.committee.count,
                    itemBuilder: (_, index) {
                      final String delegate =
                          controller.committee.delegates[index];

                      return GetBuilder<CommitteeController>(
                        builder: (_) {
                          final int? rollCall =
                              controller.committee.rollCall[delegate];

                          return DelegateTile(
                            delegate: delegate,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RoundedButton(
                                  style: rollCall == RollCall.presentAndVoting
                                      ? RoundedButtonStyle.fill
                                      : RoundedButtonStyle.border,
                                  color: context.theme.colorScheme.tertiary,
                                  onPressed: updating || controller.readOnly
                                      ? null
                                      : () {
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
                                  onPressed: updating || controller.readOnly
                                      ? null
                                      : () {
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
                                  onPressed: updating || controller.readOnly
                                      ? null
                                      : () {
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
            );
          },
        ),
      ),
      actions: [
        if (!controller.readOnly)
          SizedBox(
            width: context.width / 3,
            child: RoundedButton(
              color: updating ? Colors.blueGrey : null,
              onPressed: updating
                  ? null
                  : () async {
                      setState(() => updating = true);
                      await CloudStorage.saveRollCall();
                      setState(() => updating = false);

                      if (context.mounted) {
                        context.pop();
                      }
                    },
              child: const Text("UPDATE"),
            ),
          ),
      ],
    );
  }
}
