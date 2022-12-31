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
                          style: context.textTheme.headline2,
                          children: [
                            TextSpan(
                              text: _committeeController.committee.agenda,
                              style: context.textTheme.headline5!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      RoundedButton(
                        border: true,
                        color: Colors.amber.shade400,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        onPressed: () async {
                          final TextEditingController _controller =
                              TextEditingController(
                            text: _committeeController.committee.agenda,
                          );

                          await showDialog(
                            context: context,
                            builder: (_) => DialogBox(
                              heading: "Set Committee Name",
                              content: TextField(
                                autofocus: true,
                                controller: _controller,
                                onSubmitted: (value) {
                                  _committeeController
                                      .setAgenda(_controller.text);

                                  context.pop();
                                },
                                keyboardType: TextInputType.name,
                                cursorColor: Colors.grey[600],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hintText: "Agenda",
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    _committeeController
                                        .setAgenda(_controller.text);

                                    context.pop();
                                  },
                                  child: const Text("Select"),
                                )
                              ],
                            ),
                          );
                        },
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
          child,
        ],
      ),
    );
  }
}
