import 'package:flutter/material.dart' hide TabController;
import 'package:get/get.dart';

import '/models/committee.dart';
import '/tools/arguments/home.dart';
import '/tools/controllers/home.dart';
import '/tools/controllers/route.dart';
import '/tools/controllers/tabs.dart';
import './widgets/sidebar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    late final TabController _tabController;
    final RouteController _routeController = Get.find<RouteController>();

    // TODO: Remove after Testing
    final HomeArguments args = _routeController.args.value as HomeArguments? ??
        HomeArguments(committee: Committee.fromTemplate("UNSC"));

    // if (args == null) {
    //   AdvancedNavigator.openNamed(context, "/setup");
    // } else {
    Get.put(HomeController(committee: args.committee));
    _tabController = Get.put(
      TabController(
        tabVal: TabController.tabsInfo
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
                        () => _tabController.currentTab()["tab"],
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
