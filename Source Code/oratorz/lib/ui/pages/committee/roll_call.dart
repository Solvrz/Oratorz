import 'package:flutter/material.dart' hide PageController;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/config/constants/constants.dart';
import '/config/data.dart';
import '/tools/controllers/comittee/committee.dart';
import '/ui/widgets/border_button.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/filled_button.dart';

class RollCallDialog extends StatelessWidget {
  const RollCallDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final CommitteeController _committeeController =
        Get.find<CommitteeController>();

    return DialogBox(
      heading: "Roll Call",
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: BorderButton(
                    text: "SET ALL PRESENT",
                    color: Colors.amber.shade400,
                    filled: _committeeController.areAllPresent,
                    onPressed: () {
                      _committeeController.setAllPresent();
                      _committeeController.update();
                    },
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: BorderButton(
                    text: "SET ALL ABSENT",
                    color: Colors.amber.shade400,
                    filled: _committeeController.areAllAbsent,
                    onPressed: () {
                      _committeeController.setAllAbsent();
                      _committeeController.update();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    _committeeController.committee.value.count,
                    (index) {
                      final String _delegate =
                          _committeeController.committee.value.delegates[index];

                      return GetBuilder<CommitteeController>(
                        builder: (_) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            hoverColor: Colors.grey[100],
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    offset: const Offset(1, 1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                "flags/$_delegate.svg",
                              ),
                            ),
                            title: Text(
                              DELEGATES[_delegate]!,
                              style: theme.textTheme.bodyText1,
                            ),
                            trailing: Builder(
                              builder: (context) {
                                final int rollCall =
                                    _committeeController.rollCall[_delegate]!;

                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    BorderButton(
                                      text: "PV",
                                      color: Colors.blue.shade400,
                                      onPressed: () {
                                        _committeeController.setRollCall(
                                          _delegate,
                                          2,
                                        );

                                        _committeeController.update();
                                      },
                                      filled: rollCall == 2,
                                    ),
                                    const SizedBox(width: 4),
                                    BorderButton(
                                      text: "P",
                                      color: Colors.amber.shade400,
                                      onPressed: () {
                                        _committeeController.setRollCall(
                                          _delegate,
                                          1,
                                        );

                                        _committeeController.update();
                                      },
                                      filled: rollCall == 1,
                                    ),
                                    const SizedBox(width: 4),
                                    BorderButton(
                                      text: "A",
                                      color: Colors.red.shade400,
                                      onPressed: () {
                                        _committeeController.setRollCall(
                                          _delegate,
                                          0,
                                        );

                                        _committeeController.update();
                                      },
                                      filled: rollCall == 0,
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
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: FilledButton(
            color: theme.colorScheme.secondary,
            onPressed: () => Navigator.pop(context),
            child: const Text("DONE"),
          ),
        ),
      ],
    );
  }
}
