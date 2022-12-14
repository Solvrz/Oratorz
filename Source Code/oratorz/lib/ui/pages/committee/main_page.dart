import 'package:flutter/material.dart' hide TabController;
import 'package:get/get.dart';

import '/config/constants/committee.dart';
import '/models/committee.dart';
import '/tools/arguments/committee.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/route.dart';
import 'widgets/sidebar.dart';

class CommitteeMainPage extends StatelessWidget {
  const CommitteeMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RouteController _routeController = Get.find<RouteController>();

    // TODO: Remove after Testing
    final CommitteeArguments args =
        // _routeController.args.value as CommitteeArguments? ??
        CommitteeArguments(committee: Committee.fromTemplate("UNSC"));

    // if (args == null) {
    //   context.go("/setup");
    // } else {
    final CommitteeController _committeeController =
        Get.put<CommitteeController>(
      CommitteeController(
        committee: args.committee,
        tabVal: COMMITTEE_TABS
            .indexWhere(
              (tab) => tab["route"].toString().contains(_routeController.path),
            )
            .clamp(0, double.infinity)
            .toInt(),
      ),
    );
    // }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            const Sidebar(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Expanded(
                      child: Obx(
                        () => _committeeController.currentTab()["tab"],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
