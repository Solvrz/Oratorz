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
    final CommitteeController _committeeController =
        Get.find<CommitteeController>();

    return DialogBox(
      heading: "Roll Call",
      actionsAlignment: MainAxisAlignment.center,
      content: SizedBox(
        height: context.height / 1.5,
        width: context.width / 3,
        child: _committeeController.committee.count > 0
            ? Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RoundedButton(
                                border: true,
                                onPressed: () {
                                  _committeeController.setAllPresent();
                                  _committeeController.update();
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
                                border: true,
                                onPressed: () {
                                  _committeeController.setAllAbsent();
                                  _committeeController.update();
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
                                border: true,
                                onPressed: () {
                                  _committeeController.setAllPresentAndVoting();
                                  _committeeController.update();
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
                      itemCount: _committeeController.committee.count,
                      itemBuilder: (_, index) {
                        final String _delegate =
                            _committeeController.committee.delegates[index];

                        return GetBuilder<CommitteeController>(
                          builder: (_) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: DelegateTile(
                              delegate: _delegate,
                              trailing: Builder(
                                builder: (_) {
                                  final int? rollCall =
                                      _committeeController.rollCall[_delegate];

                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RoundedButton(
                                        border: rollCall != 2,
                                        color: Colors.blue.shade400,
                                        onPressed: () {
                                          _committeeController.setRollCall(
                                            _delegate,
                                            2,
                                          );

                                          _committeeController.update();
                                        },
                                        child: const Text("PV"),
                                      ),
                                      const SizedBox(width: 4),
                                      RoundedButton(
                                        border: rollCall != 1,
                                        color: Colors.amber.shade400,
                                        onPressed: () {
                                          _committeeController.setRollCall(
                                            _delegate,
                                            1,
                                          );

                                          _committeeController.update();
                                        },
                                        child: const Text("P"),
                                      ),
                                      const SizedBox(width: 4),
                                      RoundedButton(
                                        border: rollCall != 0,
                                        color: Colors.red.shade400,
                                        onPressed: () {
                                          _committeeController.setRollCall(
                                            _delegate,
                                            0,
                                          );

                                          _committeeController.update();
                                        },
                                        child: const Text("A"),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  "No delegates are there in the commitee.",
                  style: context.textTheme.bodyText1,
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
