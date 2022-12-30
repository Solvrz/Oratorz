import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

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

    return Obx(
      () => Expanded(
        child: Card(
          child: Container(
            margin: const EdgeInsets.all(16),
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
                      onPressed: () async {
                        final TextEditingController _controller =
                            TextEditingController(
                          text: _setupController.committee.name,
                        );

                        await showDialog(
                          context: context,
                          builder: (_) => DialogBox(
                            heading: "Set Committee Name",
                            content: TextField(
                              autofocus: true,
                              controller: _controller,
                              onSubmitted: (value) {
                                _setupController.committee.name = value;

                                context.pop();
                              },
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.grey[600],
                              decoration: InputDecoration(
                                fillColor: Colors.grey[200],
                                hintText: "Committee Name",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _setupController.committee.name =
                                      _controller.value.text;

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
                      onTap: () => _setupController.removeAt(index),
                      trailing: Icon(Icons.remove, color: Colors.grey[400]),
                    ),
                    separatorBuilder: (_, index) => Divider(
                      indent: 66,
                      thickness: 0.5,
                      height: 6,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                RoundedButton(
                  border: true,
                  onPressed: () => _setupController.clear(),
                  child: Text(
                    "Reset Selection",
                    style: context.textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 12),
                RoundedButton(
                  onPressed: () {
                    final CommitteeController controller = CommitteeController(
                      committee: _setupController.committee,
                    );

                    Get.put(controller);
                    LocalStorage.saveCommittee(controller);

                    context.pushReplacement("/committee/gsl");
                  },
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
      ),
    );
  }
}
