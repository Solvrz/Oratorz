import 'package:flutter/material.dart' hide Router, Route;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/config/constants.dart';
import '/models/committee.dart';
import '/models/router.dart';
import '/services/cloud_storage.dart';
import '/tools/controllers/app.dart';
import '/tools/controllers/route.dart';
import '/tools/controllers/setup.dart';
import '/ui/widgets/rounded_button.dart';
import '../../../../../services/local_storage.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final SetupController controller = Get.find<SetupController>();

    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Other Info",
                style: context.textTheme.headlineSmall,
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
    final Route route = Router.modes.first;

    controller.path = route.path;
    controller.args = {"id": committee.id};

    if (context.mounted) {
      context.go("${route.path}?id=${committee.id}");
    }
  } else {
    if (error != null) error.value = false;
  }
}
