import 'package:flutter/material.dart' hide Router, Route;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/config/constants.dart';
import '/config/data.dart';
import '/models/committee.dart';
import '/models/router.dart';
import '/services/cloud_storage.dart';
import '/services/local_storage.dart';
import '/tools/controllers/app.dart';
import '/tools/controllers/route.dart';
import '/tools/controllers/setup.dart';
import '/ui/widgets/rounded_button.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GetBuilder<SetupController>(
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Other Info",
                    style: context.textTheme.headlineSmall,
                  ),
                  Row(
                    children: [
                      Text(
                        "Committee Type: ",
                        style: context.textTheme.titleLarge,
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        child: DropdownButton(
                          value: controller.committee.type,
                          borderRadius: BorderRadius.circular(16),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          underline: const SizedBox(),
                          focusColor: Colors.transparent,
                          iconEnabledColor: Colors.grey.shade400,
                          items: TYPES
                              .map<DropdownMenuItem<String>>(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.committee.type = value;
                              controller.update();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  RoundedButton(
                    style: RoundedButtonStyle.border,
                    onPressed: () {
                      controller.clearOptionsPage();
                      controller.update();
                    },
                    child: Text(
                      "Reset Options",
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RoundedButton(
                    style: RoundedButtonStyle.border,
                    onPressed: () {
                      controller.showOptions.value = false;
                      controller.update();
                    },
                    child: Text(
                      "Configure Delegates",
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => RoundedButton(
                      color: controller.status.value ? Colors.blueGrey : null,
                      onPressed: controller.status.value
                          ? null
                          : () async {
                              // if (INVITE_CODES_ENABLED) {
                              //   await showDialog(
                              //     context: context,
                              //     builder: (_) => const _InviteCodeDialog(),
                              //   );
                              // } else {
                              controller.status.value = true;
                              await submit(context);
                              controller.status.value = false;
                              // }
                            },
                      child: Text(
                        "Publish Committee",
                        style: context.textTheme.bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<void> submit(
  BuildContext context, {
  String? code,
  Rx<bool>? error,
}) async {
  LocalStorage.clearSetup();

  if (error != null) error.value = false;

  final String _code = code?.trim().toUpperCase() ?? "";

  if (INVITE_CODES.contains(_code) || !INVITE_CODES_ENABLED) {
    final SetupController setupController = Get.find<SetupController>();
    final AppController appController = Get.find<AppController>();

    if (!setupController.validate(context)) {
      return;
    }

    final Committee committee = setupController.committee;

    if (!setupController.editing) {
      appController.user!.addCommittee(committee);
      appController.update();
    }

    await CloudStorage.createCommittee();

    await Get.delete<SetupController>();

    final controller = Get.find<RouteController>();

    controller.path = Router.home.path;
    controller.args = {};

    if (context.mounted) {
      context.go(Router.home.path);
    }
  } else {
    if (error != null) error.value = false;
  }
}
