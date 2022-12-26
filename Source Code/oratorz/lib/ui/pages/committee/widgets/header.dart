import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/tools/controllers/comittee/committee.dart';
import '/ui/widgets/dialog_box.dart';

class Header extends StatelessWidget {
  final Widget? trailing;

  const Header({super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    final CommitteeController _committeeController =
        Get.find<CommitteeController>();

    return SizedBox(
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
                InkWell(
                  onTap: () async {
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
                            _committeeController.setAgenda(_controller.text);

                            Navigator.pop(context);
                          },
                          keyboardType: TextInputType.name,
                          cursorColor: Colors.grey[600],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: "Agenda",
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(16, 24, 16, 0),
                        actionsPadding: const EdgeInsets.all(16),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _committeeController.setAgenda(_controller.text);

                              Navigator.pop(context);
                            },
                            child: const Text("Select"),
                          )
                        ],
                      ),
                    );
                  },
                  hoverColor: const Color.fromARGB(255, 250, 250, 250),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.shade400),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.amber.shade400,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          trailing ?? const SizedBox()
        ],
      ),
    );
  }
}
