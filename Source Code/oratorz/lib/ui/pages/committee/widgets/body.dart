import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/tools/controllers/comittee/committee.dart';
import '/ui/widgets/dialog_box.dart';
import '/ui/widgets/rounded_button.dart';

class Body extends StatelessWidget {
  final Widget child;

  final Widget? trailing;

  const Body({
    super.key,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final CommitteeController _committeeController =
        Get.find<CommitteeController>();

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            height: context.height / 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Agenda: ",
                          style: context.textTheme.displayMedium,
                          children: [
                            TextSpan(
                              text: _committeeController.committee.agenda,
                              style: context.textTheme.headlineSmall!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      RoundedButton(
                        style: RoundedButtonStyle.border,
                        color: Colors.amber.shade400,
                        tooltip: "Set Agenda",
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => const _AgendaDialog(),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.amber.shade400,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing ?? const SizedBox()
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _AgendaDialog extends StatelessWidget {
  const _AgendaDialog();

  @override
  Widget build(BuildContext context) {
    final CommitteeController _committeeController =
        Get.find<CommitteeController>();
    final TextEditingController _controller = TextEditingController(
      text: _committeeController.committee.agenda,
    );

    return DialogBox(
      heading: "Set Agenda",
      content: TextField(
        autofocus: true,
        controller: _controller,
        decoration: const InputDecoration(
          hintText: "Agenda",
          prefixIcon: Icon(Icons.edit_note),
        ),
        onSubmitted: (value) {
          _committeeController.setAgenda(_controller.text);

          context.pop();
        },
      ),
      actions: [
        RoundedButton(
          style: RoundedButtonStyle.border,
          color: Colors.amber.shade400,
          onPressed: () {
            _committeeController.setAgenda(_controller.text);

            context.pop();
          },
          child: const Text("Select"),
        )
      ],
    );
  }
}
