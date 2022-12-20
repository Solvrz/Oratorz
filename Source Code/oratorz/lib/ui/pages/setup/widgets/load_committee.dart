import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/data.dart';
import '/tools/controllers/setup.dart';
import '/ui/widgets/dialog_box.dart';

class LoadCommitteeCard extends StatelessWidget {
  const LoadCommitteeCard({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: context.height / 6,
        child: Card(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Load Committee",
                  style: context.textTheme.headline5,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        child: const Text("From File"),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextButton(
                        child: const Text("From Template"),
                        onPressed: () {
                          final List<String> templates =
                              COMMITTEES.keys.toList();
                          final SetupController _setupController =
                              Get.find<SetupController>();

                          showDialog(
                            context: context,
                            builder: (context) => DialogBox(
                              heading: "Select Template",
                              content: SizedBox(
                                height: context.height / 2,
                                width: context.width / 2.5,
                                child: ListView.builder(
                                  itemCount: COMMITTEES.length * 2 - 1,
                                  itemBuilder: (context, index) => index % 2 ==
                                          0
                                      ? ListTile(
                                          hoverColor: Colors.grey[100],
                                          onTap: () {
                                            _setupController.setName(
                                              templates[index ~/ 2],
                                            );
                                            _setupController.setAs(
                                              COMMITTEES[templates[index ~/ 2]]!
                                                  .toList(),
                                            );

                                            Navigator.pop(context);
                                          },
                                          title: Text(
                                            "${templates[index ~/ 2]} (${COMMITTEES[templates[index ~/ 2]]!.length})",
                                            style: context.textTheme.bodyText1,
                                          ),
                                        )
                                      : Divider(
                                          height: 2,
                                          color: Colors.grey[300],
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
}
