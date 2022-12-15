import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/config/constants/constants.dart';
import '/tools/arguments/committee.dart';
import '/tools/controllers/setup.dart';
import '/ui/widgets/delegate_tile.dart';
import '/ui/widgets/dialog_box.dart';

class CommitteeCard extends StatelessWidget {
  const CommitteeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final SetupController _setupController = Get.find<SetupController>();

    return Obx(
      () => Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      _setupController.committee.value.name,
                      style: theme.textTheme.headline5,
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        final SetupController _committeeController =
                            Get.find<SetupController>();

                        final TextEditingController _controller =
                            TextEditingController(
                          text: _committeeController.committee.value.name,
                        );

                        showDialog(
                          context: context,
                          builder: (context) => DialogBox(
                            heading: "Set Committee Name",
                            content: TextField(
                              autofocus: true,
                              controller: _controller,
                              onSubmitted: (value) {
                                _committeeController.setName(value);
                                Navigator.pop(context);
                              },
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.grey[600],
                              decoration: InputDecoration(
                                fillColor: Colors.grey[200],
                                hintText: "Committee Name",
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 24, 16, 0),
                            actionsPadding: const EdgeInsets.all(16),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _committeeController
                                      .setName(_controller.value.text);
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
                Text(
                  "${_setupController.committee.value.count} Delegates",
                  style: theme.textTheme.headline6,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => DelegateTile(
                      delegate:
                          _setupController.committee.value.delegates[index],
                      onTap: () => _setupController.removeAt(index),
                      trailing: Icon(Icons.remove, color: Colors.grey[400]),
                    ),
                    separatorBuilder: (context, index) => Divider(
                      indent: 66,
                      thickness: 0.5,
                      height: 6,
                      color: Colors.grey[400],
                    ),
                    itemCount: _setupController.committee.value.count,
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => _setupController.clear(),
                  child: const Text("Clear Selection"),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go(
                    "/committee/gsl",
                    extra: CommitteeArguments(
                      committee: _setupController.committee.value,
                    ),
                  ),
                  child: const Text("Start Session"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
