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
import '/tools/functions.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';
import 'setup_delegate_tile.dart';

class CommitteeCard extends StatelessWidget {
  const CommitteeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(
      builder: (controller) => Expanded(
        child: Card(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: context.height * 0.9,
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      controller.committee.name,
                      style: context.textTheme.headlineSmall,
                    ),
                    const SizedBox(width: 16),
                    RoundedButton(
                      style: RoundedButtonStyle.border,
                      color: Colors.amber.shade400,
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => const _CommitteeNameDialog(),
                      ),
                      tooltip: "Set Committee Name",
                      child: Icon(
                        Icons.edit,
                        color: Colors.amber.shade400,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${controller.committee.count} Delegates",
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: controller.committee.count,
                    itemBuilder: (_, index) => SetupDelegateTile(
                      delegate: controller.committee.delegates[index],
                      index: index,
                    ),
                    separatorBuilder: (_, index) => Divider(
                      indent: 66,
                      thickness: 0.5,
                      height: 6,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                RoundedButton(
                  style: RoundedButtonStyle.border,
                  onPressed: () {
                    controller.clear();
                    controller.update();
                  },
                  child: Text(
                    "Reset Selection",
                    style: context.textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => RoundedButton(
                    color: controller.status.value == false
                        ? null
                        : Colors.blueGrey,
                    onPressed: controller.status.value == false
                        ? () async {
                            if (INVITE_CODES_ENABLED) {
                              await showDialog(
                                context: context,
                                builder: (_) => const _InviteCodeDialog(),
                              );
                            } else {
                              if (controller.committee.delegates.isEmpty) {
                                snackbar(
                                  context,
                                  const Center(
                                    child: Text(
                                      "Add atleast 1 delegate to continue",
                                    ),
                                  ),
                                );
                              } else {
                                controller.status.value = true;
                                await submit(context);
                                controller.status.value = false;
                              }
                            }
                          }
                        : null,
                    child: Text(
                      "Configure Options",
                      style: context.textTheme.bodyLarge
                          ?.copyWith(color: Colors.white),
                    ),
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

class _InviteCodeDialog extends StatelessWidget {
  const _InviteCodeDialog();

  @override
  Widget build(BuildContext context) {
    final TextEditingController inviteCodeController = TextEditingController();
    final Rx<bool> error = false.obs;

    return DialogBox(
      heading: "Enter Invite Code",
      content: SizedBox(
        height: error.value ? 85 : 50,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              controller: inviteCodeController,
              decoration: const InputDecoration(
                hintText: "Invite Code",
                prefixIcon: Icon(Icons.vpn_key),
              ),
              onSubmitted: (value) => submit(context, code: value),
            ),
            if (error.value) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: context.theme.colorScheme.error,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Invalid Invite Code",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        RoundedButton(
          style: RoundedButtonStyle.border,
          color: Colors.amber.shade400,
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          onPressed: () =>
              submit(context, code: inviteCodeController.text, error: error),
          child: const Text("Done"),
        ),
      ],
    );
  }
}

class _CommitteeNameDialog extends StatelessWidget {
  const _CommitteeNameDialog();

  @override
  Widget build(BuildContext context) {
    final SetupController _setupController = Get.find<SetupController>();
    final TextEditingController _controller = TextEditingController(
      text: _setupController.committee.name,
    );

    return DialogBox(
      heading: "Set Committee Name",
      content: TextField(
        autofocus: true,
        controller: _controller,
        decoration: const InputDecoration(
          hintText: "Committee Name",
          prefixIcon: Icon(Icons.group),
        ),
        onSubmitted: (value) {
          _setupController.committee.name = value;
          _setupController.update();

          context.pop();
        },
      ),
      actions: [
        RoundedButton(
          style: RoundedButtonStyle.border,
          color: Colors.amber.shade400,
          onPressed: () {
            _setupController.committee.name = _controller.value.text;
            _setupController.update();

            context.pop();
          },
          child: const Text("Select"),
        ),
      ],
    );
  }
}

Future<void> submit(
  BuildContext context, {
  String? code,
  Rx<bool>? error,
}) async {
  if (error != null) error.value = false;

  final String _code = code?.trim().toUpperCase() ?? "";

  if (INVITE_CODES.contains(_code) || !INVITE_CODES_ENABLED) {
    final SetupController setupController = Get.find<SetupController>();
    final AppController appController = Get.find<AppController>();

    final Committee committee = setupController.committee;
    committee.initRollCall();

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
