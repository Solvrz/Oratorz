import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/arguments/committee.dart';
import '/config/country_info.dart';
import '/ui/widgets/dialog_title.dart';
import '../../../../controllers/committee.dart';
import '../widgets/roll_call_button.dart';

class RollCallPage extends StatelessWidget {
  const RollCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Roll Call PAGE",
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}

AlertDialog takeRollCall(BuildContext context, CommitteeArguments args) =>
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const DialogTitle(title: "Roll Call"),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 2,
        child: GetX<CommitteeController>(
          init: Get.find<CommitteeController>(),
          builder: (controller) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RollCallButton(
                        text: "SET ALL PRESENT",
                        color: Colors.amber.shade400,
                        selected: controller.areAllPresent,
                        onPressed: () => controller.setAllPresent(),
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: RollCallButton(
                        text: "SET ALL ABSENT",
                        color: Colors.amber.shade400,
                        selected: controller.areAllAbsent,
                        onPressed: () => controller.setAllAbsent(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        args.committee.count,
                        (index) => ListTile(
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
                              "flags/${args.committee.countries[index]}.svg",
                            ),
                          ),
                          title: Text(
                            COUNTRIES[args.committee.countries[index]]!,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          trailing: Builder(
                            builder: (context) {
                              final int rollCall = controller
                                  .rollCall[args.committee.countries[index]]!;

                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RollCallButton(
                                    text: "PV",
                                    color: Colors.blue.shade400,
                                    onPressed: () => controller.setRollCall(
                                      args.committee.countries[index],
                                      2,
                                    ),
                                    selected: rollCall == 2,
                                  ),
                                  const SizedBox(width: 4),
                                  RollCallButton(
                                    text: "P",
                                    color: Colors.amber.shade400,
                                    onPressed: () => controller.setRollCall(
                                      args.committee.countries[index],
                                      1,
                                    ),
                                    selected: rollCall == 1,
                                  ),
                                  const SizedBox(width: 4),
                                  RollCallButton(
                                    text: "A",
                                    color: Colors.red.shade400,
                                    onPressed: () => controller.setRollCall(
                                      args.committee.countries[index],
                                      0,
                                    ),
                                    selected: rollCall == 0,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: RollCallButton(
            padding: const EdgeInsets.symmetric(vertical: 4),
            text: "DONE",
            color: const Color(0xff0d1520),
            onPressed: () => Navigator.of(context).pop(),
            selected: true,
          ),
        ),
      ],
    );
