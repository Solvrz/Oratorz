import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/config/country_info.dart';
import '/tools/controllers/setup.dart';
import '/ui/widgets/dialog_title.dart';

class LoadCommitteeCard extends StatelessWidget {
  const LoadCommitteeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Load Committee",
              style: Theme.of(context).textTheme.headline5,
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
                      final List<String> templates = COMMITTEES.keys.toList();
                      final SetupController controller =
                          Get.find<SetupController>();

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: const DialogTitle(title: "Select Template"),
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Scrollbar(
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                primary: true,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: List.generate(
                                    COMMITTEES.length * 2 - 1,
                                    (index) => index % 2 == 0
                                        ? ListTile(
                                            hoverColor: Colors.grey[100],
                                            onTap: () {
                                              controller.setName(
                                                templates[index ~/ 2],
                                              );
                                              controller.setAs(
                                                COMMITTEES[
                                                        templates[index ~/ 2]]!
                                                    .toList(),
                                              );
                                              Navigator.of(context).pop();
                                            },
                                            title: Text(
                                              "${templates[index ~/ 2]} (${COMMITTEES[templates[index ~/ 2]]!.length})",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          )
                                        : Divider(
                                            height: 2,
                                            color: Colors.grey[300],
                                          ),
                                  ),
                                ),
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
    );
  }
}
