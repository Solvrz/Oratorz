import 'package:flutter/material.dart' hide PageController;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/config/country_info.dart';
import '/tools/arguments/home.dart';
import '/tools/controllers/home.dart';
import '/ui/widgets/custom_button.dart';
import '/ui/widgets/dialog_title.dart';

class RollCallDialog extends StatelessWidget {
  final HomeArguments? args;

  const RollCallDialog({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const DialogTitle(title: "Roll Call"),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 2,
        child: GetX<HomeController>(
          init: Get.find<HomeController>(),
          builder: (controller) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "SET ALL PRESENT",
                        color: Colors.amber.shade400,
                        filled: controller.areAllPresent,
                        onPressed: () => controller.setAllPresent(),
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: CustomButton(
                        text: "SET ALL ABSENT",
                        color: Colors.amber.shade400,
                        filled: controller.areAllAbsent,
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
                        args?.committee.count ?? 0,
                        (index) {
                          final String _country =
                              args?.committee.countries[index] ?? "";

                          return ListTile(
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
                                "flags/$_country.svg",
                              ),
                            ),
                            title: Text(
                              COUNTRIES[_country]!,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Builder(
                              builder: (context) {
                                final int rollCall =
                                    controller.rollCall[_country]!;

                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomButton(
                                      text: "PV",
                                      color: Colors.blue.shade400,
                                      onPressed: () =>
                                          controller.setRollCall(_country, 2),
                                      filled: rollCall == 2,
                                    ),
                                    const SizedBox(width: 4),
                                    CustomButton(
                                      text: "P",
                                      color: Colors.amber.shade400,
                                      onPressed: () =>
                                          controller.setRollCall(_country, 1),
                                      filled: rollCall == 1,
                                    ),
                                    const SizedBox(width: 4),
                                    CustomButton(
                                      text: "A",
                                      color: Colors.red.shade400,
                                      onPressed: () =>
                                          controller.setRollCall(_country, 0),
                                      filled: rollCall == 0,
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
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
          child: CustomButton(
            padding: const EdgeInsets.symmetric(vertical: 4),
            text: "DONE",
            color: const Color(0xff0d1520),
            onPressed: () => Navigator.of(context).pop(),
            filled: true,
          ),
        ),
      ],
    );
  }
}
