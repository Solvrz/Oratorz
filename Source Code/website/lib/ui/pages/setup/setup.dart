import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/models/committee.dart';
import '/services/local_storage.dart';
import '/tools/controllers/app.dart';
import '/tools/controllers/route.dart';
import '/tools/controllers/setup.dart';
import '/tools/functions.dart';
import '/ui/widgets/rounded_button.dart';
import './widgets/committee_card.dart';
import './widgets/load_committee.dart';
import './widgets/new_committee.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController appController = Get.find<AppController>();
    final RouteController controller = Get.find<RouteController>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            "Setup Committee",
            style:
                context.textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          actions: [
            RoundedButton(
              child: const Text("Save"),
              onPressed: () {
                LocalStorage.saveSetup();

                snackbar(
                  context,
                  const Center(child: Text("Saved Successfully!")),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: appController.user!.fetchCommittee(controller.args["id"]),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff2a313b),
                ),
              );
            }

            if (!Get.isRegistered<SetupController>()) {
              final Committee? committee = LocalStorage.loadSetup();

              Get.put<SetupController>(
                SetupController(
                  committee: controller.args["id"] == null && committee != null
                      ? committee
                      : snapshot.data!,
                  editing: controller.args["id"] != null,
                ),
              );
            }

            return const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        LoadCommitteeCard(),
                        SizedBox(height: 12),
                        Expanded(child: NewCommitteeCard()),
                      ],
                    ),
                  ),
                  SizedBox(width: 36),
                  CommitteeCard(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
