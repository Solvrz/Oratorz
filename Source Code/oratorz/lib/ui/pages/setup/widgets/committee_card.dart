import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/config/constants/constants.dart';
import '/services/local_storage.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/setup.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';

class CommitteeCard extends StatelessWidget {
  const CommitteeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final SetupController _setupController = Get.find<SetupController>();

    return GetBuilder<SetupController>(
      builder: (_) {
        return Expanded(
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
                        _setupController.committee.name,
                        style: context.textTheme.headline5,
                      ),
                      const SizedBox(width: 16),
                      RoundedButton(
                        border: true,
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
                    "${_setupController.committee.count} Delegates",
                    style: context.textTheme.headline6,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _setupController.committee.count,
                      itemBuilder: (_, index) => DelegateTile(
                        delegate: _setupController.committee.delegates[index],
                        onTap: () {
                          _setupController.removeAt(index);
                          _setupController.update();
                        },
                        trailing: Icon(
                          Icons.remove,
                          color: Colors.grey.shade400,
                        ),
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
                    border: true,
                    onPressed: () {
                      _setupController.clear();
                      _setupController.update();
                    },
                    child: Text(
                      "Reset Selection",
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RoundedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => const _InviteCodeDialog(),
                    ),
                    child: Text(
                      "Start Session",
                      style: context.textTheme.bodyLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InviteCodeDialog extends StatefulWidget {
  const _InviteCodeDialog();

  @override
  State<_InviteCodeDialog> createState() => _InviteCodeDialogState();
}

class _InviteCodeDialogState extends State<_InviteCodeDialog> {
  final TextEditingController _inviteCodeController = TextEditingController();
  bool error = false;

  void submit({String? value}) {
    final String _code =
        (value ?? _inviteCodeController.text).trim().toUpperCase();

    setState(() => error = false);

    if (INVITE_CODES.contains(_code) || TESTING) {
      Get.put<CommitteeController>(
        CommitteeController(
          committee: Get.find<SetupController>().committee,
        ),
      );

      LocalStorage.saveCommittee();

      context.pushReplacement("/committee/gsl");
    } else {
      setState(() => error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogBox(
      heading: "Enter Invite Code",
      content: SizedBox(
        height: error ? 85 : 50,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              controller: _inviteCodeController,
              decoration: const InputDecoration(
                hintText: "Invite Code",
                prefixIcon: Icon(Icons.vpn_key),
              ),
              onSubmitted: (value) => submit(value: value),
            ),
            if (error) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: context.theme.errorColor,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Invalid Invite Code",
                    style: context.textTheme.bodyText2?.copyWith(
                      color: context.theme.errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
      actions: [
        RoundedButton(
          border: true,
          color: Colors.amber.shade400,
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          onPressed: submit,
          child: const Text("Done"),
        )
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
          border: true,
          color: Colors.amber.shade400,
          onPressed: () {
            _setupController.committee.name = _controller.value.text;
            _setupController.update();

            context.pop();
          },
          child: const Text("Select"),
        )
      ],
    );
  }
}
