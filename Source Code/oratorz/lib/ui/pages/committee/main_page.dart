import 'package:flutter/material.dart' hide TabController;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_html/html.dart' as html;

import '/config/constants/committee.dart';
import '/config/constants/constants.dart';
import '/models/committee.dart';
import '/tools/arguments/committee.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/route.dart';
import 'roll_call.dart';

class CommitteeMainPage extends StatelessWidget {
  const CommitteeMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    late final CommitteeController _committeeController;
    final RouteController _routeController = Get.find<RouteController>();

    // TODO: Remove after Testing
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final CommitteeArguments? args =
        _routeController.args.value as CommitteeArguments? ??
            CommitteeArguments(committee: Committee.fromTemplate("UNSC"));

    if (args == null) {
      context.go("/setup");
    } else {
      _committeeController = Get.put<CommitteeController>(
        CommitteeController(
          committee: args.committee,
          tabVal: COMMITTEE_TABS
              .indexWhere(
                (tab) =>
                    tab["route"].toString().contains(_routeController.path),
              )
              .clamp(0, double.infinity)
              .toInt(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 8,
              child: Card(
                margin: EdgeInsets.zero,
                color: const Color(0xff0d1520),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        _committeeController.committee.value.name,
                        style: theme.textTheme.headline2!
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ...List.generate(COMMITTEE_TABS.length, (index) {
                        final Map<String, dynamic> _tab = COMMITTEE_TABS[index];

                        return Obx(
                          () => SidebarTile(
                            title: _tab["title"],
                            icon: _tab["icon"],
                            onTap: () {
                              _committeeController.tabVal = index;
                              html.window.history.pushState(
                                null,
                                "tab",
                                COMMITTEE_TABS[index]["route"],
                              );
                            },
                            selected: _committeeController.tabVal == index,
                            iconColor: _tab["color"],
                          ),
                        );
                      }),
                      SidebarTile(
                        title: "Roll Call",
                        icon: Icons.fact_check_outlined,
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => const RollCallDialog(),
                        ),
                      ),
                      const Spacer(),
                      SidebarTile(
                        title: "Setup",
                        icon: Icons.settings_outlined,
                        onTap: () => context.go("/setup"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Obx(
                  () => _committeeController.currentTab()["tab"],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SidebarTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;
  final bool selected;
  final Color? iconColor;

  const SidebarTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.selected = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 4),
        child: ListTile(
          onTap: onTap,
          horizontalTitleGap: 8,
          hoverColor: selected ? Colors.transparent : Colors.white12,
          tileColor:
              selected ? const Color(0xff2a313b) : const Color(0xff0d1520),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: Icon(icon, color: iconColor ?? Colors.white, size: 24),
          title: Text(title, style: theme.textTheme.bodyText2),
        ),
      );
}
