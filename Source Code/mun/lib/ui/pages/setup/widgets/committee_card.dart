import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/widgets/country_tile.dart';
import '/ui/widgets/dialog_title.dart';
import '../../../../tools/arguments/home.dart';
import '../../../../tools/controllers/setup.dart';

class CommitteeCard extends StatelessWidget {
  const CommitteeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<SetupController>(
      init: Get.find<SetupController>(),
      builder: (controller) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      controller.committee.value.name ?? "Your Committee",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        final SetupController committeeController =
                            Get.find<SetupController>();

                        final TextEditingController controller =
                            TextEditingController(
                          text: committeeController.committee.value.name,
                        );

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title:
                                const DialogTitle(title: "Set Committee Name"),
                            content: TextField(
                              autofocus: true,
                              controller: controller,
                              onSubmitted: (value) {
                                committeeController.setName(value);
                                Navigator.of(context).pop();
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
                                  committeeController
                                      .setName(controller.value.text);
                                  Navigator.of(context).pop();
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
                  "${controller.committee.value.count} Countries",
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => CountryTile(
                      country: controller.committee.value.countries[index],
                      onTap: () => controller.removeAt(index),
                      trailing: Icon(Icons.minimize, color: Colors.grey[400]),
                    ),
                    separatorBuilder: (context, index) => Divider(
                      indent: 66,
                      thickness: 0.5,
                      height: 6,
                      color: Colors.grey[400],
                    ),
                    itemCount: controller.committee.value.count,
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => controller.clear(),
                  child: const Text("Clear Selection"),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.popAndPushNamed(
                    context,
                    "/home",
                    arguments: HomeArguments(
                      committee: controller.committee.value,
                    ),
                  ),
                  child: const Text("Start Session"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
