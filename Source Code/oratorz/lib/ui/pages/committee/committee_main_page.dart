import 'package:flutter/material.dart' hide TabController;
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_html/html.dart' as html;

import '/config/constants/committee.dart';
import '/tools/controllers/comittee/committee.dart';
import '/tools/controllers/route.dart';
import './widgets/roll_call.dart';

class CommitteeMainPage extends StatefulWidget {
  const CommitteeMainPage({super.key});

  @override
  State<CommitteeMainPage> createState() => _CommitteeMainPageState();
}

class _CommitteeMainPageState extends State<CommitteeMainPage> {
  late final CommitteeController _committeeController;

  @override
  void initState() {
    super.initState();

    if (Get.isRegistered<CommitteeController>()) {
      _committeeController = Get.find<CommitteeController>()
        ..tabVal = COMMITTEE_TABS
            .indexWhere(
              (tab) => tab["route"]
                  .toString()
                  .contains(Get.find<RouteController>().path),
            )
            .clamp(0, double.infinity)
            .toInt();
    } else {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => context.pushReplacement("/setup"));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              SizedBox(
                width: context.width / 8,
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
                          style: context.textTheme.headline2!
                              .copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ...List.generate(COMMITTEE_TABS.length, (index) {
                          final Map<String, dynamic> _tab =
                              COMMITTEE_TABS[index];

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
                          onTap: () {
                            Get.delete<CommitteeController>();
                            context.pushReplacement("/setup");
                          },
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
          title: Text(title, style: context.textTheme.bodyText2),
        ),
      );
}
